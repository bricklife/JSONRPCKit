//
//  CallElement.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol CallElementType {
    associatedtype Request: RequestType

    var request: Request { get }
    var version: String { get }
    var id: Id? { get }
    var body: AnyObject { get }

    func parseResponseObject(object: AnyObject) throws -> Request.Response
    func parseResponseArray(array: [AnyObject]) throws -> Request.Response
}

public extension CallElementType {
    /// - Throws: JSONRPCError
    func parseResponseObject(object: AnyObject) throws -> Request.Response {
        let receivedVersion = object["jsonrpc"] as? String
        guard version == receivedVersion else {
            throw JSONRPCError.UnsupportedVersion(receivedVersion)
        }

        let resultObject = object["result"] as? [String: AnyObject]
        let errorObject = object["error"] as? [String: AnyObject]

        switch (resultObject, errorObject) {
        case (nil, let errorObject?):
            throw JSONRPCError(errorObject: errorObject)

        case (let resultObject?, nil):
            do {
                return try request.responseFromResultObject(resultObject)
            } catch {
                throw JSONRPCError.ResultObjectParseError(error)
            }

        default:
            throw JSONRPCError.MissingBothResultAndError(object)
        }
    }

    /// - Throws: JSONRPCError
    func parseResponseArray(array: [AnyObject]) throws -> Request.Response {
        let matchedObject = array
            .filter { $0["id"].flatMap(Id.init) == id }
            .first

        guard let object = matchedObject else {
            throw JSONRPCError.ResponseNotFound(requestId: id, objects: array)
        }

        return try parseResponseObject(object)
    }
}

public extension CallElementType where Request.Response == Void {
    public func parseResponseObject(object: AnyObject) throws -> Request.Response {
        return ()
    }

    public func parseResponseArray(array: [AnyObject]) throws -> Request.Response {
        return ()
    }
}

public struct CallElement<R: RequestType>: CallElementType {
    public typealias Request = R

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

