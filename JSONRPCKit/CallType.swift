//
//  Call.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

public protocol CallType {
    associatedtype Request: RequestType

    var request: Request { get }
    var version: String { get }
    var id: Id? { get }
    var body: AnyObject { get }

    func responseFromObject(object: AnyObject) throws -> Request.Response
    func responseFromArray(array: [AnyObject]) throws -> Request.Response

    func resultFromObject(object: AnyObject) -> Result<Request.Response, JSONRPCError>
    func resultFromArray(array: [AnyObject]) -> Result<Request.Response, JSONRPCError>
}

public extension CallType {
    /// - Throws: JSONRPCError
    func responseFromObject(object: AnyObject) throws -> Request.Response {
        switch resultFromObject(object) {
        case .Success(let response):
            return response

        case .Failure(let error):
            throw error
        }
    }

    /// - Throws: JSONRPCError
    func responseFromArray(array: [AnyObject]) throws -> Request.Response {
        switch resultFromArray(array) {
        case .Success(let response):
            return response

        case .Failure(let error):
            throw error
        }
    }

    func resultFromObject(object: AnyObject) -> Result<Request.Response, JSONRPCError> {
        let receivedVersion = object["jsonrpc"] as? String
        guard version == receivedVersion else {
            return .Failure(.UnsupportedVersion(receivedVersion))
        }

        guard id == object["id"].flatMap(Id.init) else {
            return .Failure(.ResponseNotFound(requestId: id, object: object))
        }

        let resultObject: AnyObject? = object["result"]
        let errorObject: AnyObject? = object["error"]

        switch (resultObject, errorObject) {
        case (nil, let errorObject?):
            return .Failure(JSONRPCError(errorObject: errorObject))

        case (let resultObject?, nil):
            do {
                return .Success(try request.responseFromResultObject(resultObject))
            } catch {
                return .Failure(.ResultObjectParseError(error))
            }

        default:
            return .Failure(.MissingBothResultAndError(object))
        }
    }

    func resultFromArray(array: [AnyObject]) -> Result<Request.Response, JSONRPCError> {
        let matchedObject = array
            .filter { $0["id"].flatMap(Id.init) == id }
            .first

        guard let object = matchedObject else {
            return .Failure(.ResponseNotFound(requestId: id, object: array))
        }

        return resultFromObject(object)
    }
}

public extension CallType where Request.Response == Void {
    public func responseFromObject(object: AnyObject) throws -> Request.Response {
        return ()
    }

    public func responseFromArray(array: [AnyObject]) throws -> Request.Response {
        return ()
    }

    func resultFromObject(object: AnyObject) -> Result<Request.Response, JSONRPCError> {
        return .Success()
    }

    func resultFromArray(array: [AnyObject]) -> Result<Request.Response, JSONRPCError> {
        return .Success()
    }
}

public struct Call<Request: RequestType>: CallType {
    public let request: Request
    public let version: String
    public let id: Id?
    public let body: AnyObject

    public init(request: Request, version: String, id: Id) {
        let id: Id? = request.isNotification ? nil : id
        var body: [String: AnyObject] = [
            "jsonrpc": version,
            "method": request.method,
        ]

        if let id = id {
            body["id"] = id.value
        }

        if let parameters = request.parameters {
            body["params"] = parameters
        }

        self.request = request
        self.version = version
        self.id = id
        self.body = body
    }
}

