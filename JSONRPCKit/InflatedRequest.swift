//
//  InflatedRequest.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation

struct InflatedRequest<Request: RequestType> {
    let request: Request
    let version: String
    let id: RequestIdentifier
    let body: AnyObject

    init(request: Request, version: String, identifierGenerator: RequestIdentifierGenerator) {
        let id = identifierGenerator.next()
        var body: [String: AnyObject] = [
            "jsonrpc": version,
            "id": id.value,
            "method": request.method,
        ]

        if let parameters = request.params {
            body["params"] = parameters
        }

        self.request = request
        self.version = version
        self.id = id
        self.body = body
    }

    /// - Throws: Error
    func parseResponseObject(object: AnyObject) throws -> Request.Response {
        let receivedVersion = object["version"] as? String
        guard version == receivedVersion else {
            throw JSONRPCError.UnsupportedVersion(receivedVersion)
        }

        let resultObject = object["result"] as? [String: AnyObject]
        let errorObject = object["error"] as? [String: AnyObject]

        switch (resultObject, errorObject) {
        case (nil, let errorObject?):
            throw JSONRPCError(errorObject: errorObject)

        case (let resultObject?, nil):
            if let response = request.responseFromObject(resultObject) {
                return response
            } else {
                fatalError("TODO: throw result object parse error")
            }

        default:
            throw JSONRPCError.MissingBothResultAndError(object)
        }
    }

    func parseResponseArray(array: [AnyObject]) throws -> Request.Response {
        let matchedObject = array
            .filter { $0["id"].flatMap(RequestIdentifier.init) == id }
            .first

        guard let object = matchedObject else {
            throw JSONRPCError.ResponseNotFound(requestId: id, objects: array)
        }

        return try parseResponseObject(object)
    }
}
