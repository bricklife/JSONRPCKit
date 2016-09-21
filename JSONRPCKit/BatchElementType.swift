//
//  BatchElement.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

public protocol BatchElementType {
    associatedtype Request: RequestType

    var request: Request { get }
    var version: String { get }
    var id: Id? { get }
    var body: Any { get }

    func responseFromObject(_ object: Any) throws -> Request.Response
    func responseFromBatchObjects(_ objects: [Any]) throws -> Request.Response

    func resultFromObject(_ object: Any) -> Result<Request.Response, JSONRPCError>
    func resultFromBatchObjects(_ objects: [Any]) -> Result<Request.Response, JSONRPCError>
}

public extension BatchElementType {
    /// - Throws: JSONRPCError
    public func responseFromObject(_ object: Any) throws -> Request.Response {
        switch resultFromObject(object) {
        case .success(let response):
            return response

        case .failure(let error):
            throw error
        }
    }

    /// - Throws: JSONRPCError
    public func responseFromBatchObjects(_ objects: [Any]) throws -> Request.Response {
        switch resultFromBatchObjects(objects) {
        case .success(let response):
            return response

        case .failure(let error):
            throw error
        }
    }

    public func resultFromObject(_ object: Any) -> Result<Request.Response, JSONRPCError> {
        guard let dictionary = object as? [String: Any] else {
            fatalError("FIXME")
        }
        
        let receivedVersion = dictionary["jsonrpc"] as? String
        guard version == receivedVersion else {
            return .failure(.unsupportedVersion(receivedVersion))
        }

        guard id == dictionary["id"].flatMap(Id.init) else {
            return .failure(.responseNotFound(requestId: id, object: dictionary))
        }

        let resultObject = dictionary["result"]
        let errorObject = dictionary["error"]

        switch (resultObject, errorObject) {
        case (nil, let errorObject?):
            return .failure(JSONRPCError(errorObject: errorObject))

        case (let resultObject?, nil):
            do {
                return .success(try request.responseFromResultObject(resultObject))
            } catch {
                return .failure(.resultObjectParseError(error))
            }

        default:
            return .failure(.missingBothResultAndError(dictionary))
        }
    }

    public func resultFromBatchObjects(_ objects: [Any]) -> Result<Request.Response, JSONRPCError> {
        let matchedObject = objects
            .flatMap { $0 as? [String: Any] }
            .filter { $0["id"].flatMap(Id.init) == id }
            .first

        guard let object = matchedObject else {
            return .failure(.responseNotFound(requestId: id, object: objects))
        }

        return resultFromObject(object)
    }
}

public extension BatchElementType where Request.Response == Void {
    public func responseFromObject(_ object: Any) throws -> Request.Response {
        return ()
    }

    public func responseFromBatchObjects(_ objects: [Any]) throws -> Request.Response {
        return ()
    }

    public func resultFromObject(_ object: Any) -> Result<Request.Response, JSONRPCError> {
        return .success()
    }

    public func resultFromBatchObjects(_ objects: [Any]) -> Result<Request.Response, JSONRPCError> {
        return .success()
    }
}

public struct BatchElement<Request: RequestType>: BatchElementType {
    public let request: Request
    public let version: String
    public let id: Id?
    public let body: Any

    public init(request: Request, version: String, id: Id) {
        let id: Id? = request.isNotification ? nil : id
        var body: [String: Any] = [
            "jsonrpc": version as Any,
            "method": request.method as Any,
        ]

        if let id = id {
            body["id"] = id.value
        }

        if let parameters = request.parameters {
            body["params"] = parameters
        }

        request.extendedFields?.forEach { key, value in
            body[key] = value
        }

        self.request = request
        self.version = version
        self.id = id
        self.body = body as Any
    }
}

