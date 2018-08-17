//
//  BatchElement.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

internal protocol BatchElementProcotol: Encodable {
    associatedtype Request: JSONRPCKit.Request

    var decoder: DecoderType { get set }
    var request: Request { get }
    var version: String { get }
    var id: Id? { get }
}

internal extension BatchElementProcotol {
    /// - Throws: JSONRPCError
    internal func response(from data: Data) throws -> Request.Response {
        switch result(from: data) {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    /// - Throws: JSONRPCError
    internal func response(fromArray data: Data) throws -> Request.Response {
        switch result(fromArray: data) {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    internal func result(from data: Data) -> Result<Request.Response, JSONRPCError> {

        var response: JSONRPCResponseResult<Request.Response>
        do {
            response = try decoder.decode(JSONRPCResponseResult<Request.Response>.self, from: data)
        } catch let error as JSONRPCError {
            return .failure(error)
        } catch {
            return .failure(.responseParseError(error))
        }

        return result(from: response)
    }

    internal func result(fromArray data: Data) -> Result<Request.Response, JSONRPCError> {

        let decoder = JSONDecoder()

        var batchContainer: UnkeyedDecodingContainer
        var batchContainer2: UnkeyedDecodingContainer
        do {
            batchContainer = try decoder.decode(JSONRPCResponseResultBatchContainer.self, from: data).container
            batchContainer2 = try decoder.decode(JSONRPCResponseResultBatchContainer.self, from: data).container
        } catch let error as JSONRPCError {
            return .failure(error)
        } catch {
            return .failure(.responseParseError(error))
        }

        var response: JSONRPCResponseResult<Request.Response>?
        do {
            while !batchContainer.isAtEnd {
                let decodedId = try? batchContainer.decode(IdOnly.self)
                if id == decodedId?.id {
                    response = try batchContainer2.decode(JSONRPCResponseResult<Request.Response>.self)
                    break
                } else {
                    // Decode nothing to keep containers at same index
                    _ = try batchContainer2.decode(NoReply.self)
                }
            }
        } catch let error as JSONRPCError {
            return .failure(error)
        } catch {
            return .failure(.responseParseError(error))
        }

        if let response = response {
            return result(from: response)
        }
        return .failure(.responseNotFound(requestId: id))
    }

    private func result(from responseObj: JSONRPCResponseResult<Request.Response>) -> Result<Request.Response, JSONRPCError> {


        let receivedVersion = responseObj.jsonrpc
        guard version == receivedVersion else {
            return .failure(.unsupportedVersion(receivedVersion))
        }

        guard id == responseObj.id else {
            return .failure(.responseNotFound(requestId: id))
        }


        switch (responseObj.result, responseObj.error) {
        case (nil, let err?):
            return .failure(.responseError(code: err.code, message: err.message, data: err.data))
        case (let res?, nil):
            return .success(res)
        default:
            return .failure(.missingBothResultAndError)
        }
    }
}

private struct IdOnly: Decodable {
    let id: Id?
}

private struct JSONRPCResponseResultBatchContainer: Decodable {
    let container: UnkeyedDecodingContainer

    init(from decoder: Decoder) throws {
        container = try decoder.unkeyedContainer()
    }
}

private struct JSONRPCResponseResult<ResultObject: Decodable>: Decodable {
    let id: Id
    let jsonrpc: String
    let result: ResultObject?
    let error: JSONRPCErrorResponse?

    private enum CodingKeys: String, CodingKey {
        case id, jsonrpc, result, error
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            id = try container.decode(Id.self, forKey: .id)
            jsonrpc = try container.decode(String.self, forKey: .jsonrpc)
        } catch {
            throw JSONRPCError.responseParseError(error)
        }

        do {
            result = try container.decodeIfPresent(ResultObject.self, forKey: .result)
        } catch {
            throw JSONRPCError.resultObjectParseError(error)
        }
        do {
            error = try container.decodeIfPresent(JSONRPCErrorResponse.self, forKey: .error)
        } catch {
            throw JSONRPCError.errorObjectParseError(error)
        }
    }
}

private struct JSONRPCErrorResponse: Decodable {
    let code: Int
    let message: String
    let data: Decoder

    private enum CodingKeys: String, CodingKey {
        case code, message, data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        data = try container.superDecoder(forKey: .data)
    }
}

internal extension BatchElementProcotol where Request.Response == NoReply {
    /// - Throws: JSONRPCError
    internal func response(from data: Data) throws -> Request.Response {
        return NoReply()
    }

    /// - Throws: JSONRPCError
    internal func response(fromArray data: Data) throws -> Request.Response {
        return NoReply()
    }

    internal func result(from data: Data) -> Result<Request.Response, JSONRPCError> {
        return .success(NoReply())
    }

    internal func result(fromArray data: Data) -> Result<Request.Response, JSONRPCError> {
        return .success(NoReply())
    }
}

public struct BatchElement<Request: JSONRPCKit.Request>: BatchElementProcotol {
    var decoder: DecoderType = JSONDecoder()

    public let request: Request
    public let version: String
    public let id: Id?

    public init(request: Request, version: String, id: Id) {
        let id: Id? = request.isNotification ? nil : id
        
        self.request = request
        self.version = version
        self.id = id
    }

    private enum CodingKeys: String, CodingKey {
        case jsonrpc
        case method
        case id
        case params
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(version, forKey: .jsonrpc)
        try container.encode(request.method, forKey: .method)
        try request.extendedFields?.encode(to: encoder)

        if let params = request.parameters {
            let paramsEncoder = container.superEncoder(forKey: .params)
            try params.encode(to: paramsEncoder)
        }
    }
}

