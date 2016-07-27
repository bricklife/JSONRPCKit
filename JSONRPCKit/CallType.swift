//
//  CallType.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation

protocol CallType {
    associatedtype Response

    var requestObject: AnyObject { get }

    func parseResponseObject(object: AnyObject) throws -> Response
}

extension CallType {
    private func findObjectForId(id: RequestIdentifier, inObjects objects: [AnyObject]) -> AnyObject? {
        return objects
            .filter { $0["id"].flatMap(RequestIdentifier.init) == id }
            .first
    }
}

struct Call1<Request: RequestType>: CallType {
    typealias Response = Request.Response

    let inflatedRequest: InflatedRequest<Request>
    
    var requestObject: AnyObject {
        return inflatedRequest.body
    }

    init(request: Request, version: String, identifierGenerator: RequestIdentifierGenerator) {
        self.inflatedRequest = InflatedRequest(request: request, version: version, identifierGenerator: identifierGenerator)
    }

    func parseResponseObject(object: AnyObject) throws -> Response {
        return try inflatedRequest.parseResponseObject(object)
    }
}

struct Call2<Request1: RequestType, Request2: RequestType>: CallType {
    typealias Response = (Request1.Response, Request2.Response)

    let inflatedRequest1: InflatedRequest<Request1>
    let inflatedRequest2: InflatedRequest<Request2>

    var requestObject: AnyObject {
        return [
            inflatedRequest1.body,
            inflatedRequest2.body,
        ]
    }

    init(request1: Request1, request2: Request2, version: String, identifierGenerator: RequestIdentifierGenerator) {
        self.inflatedRequest1 = InflatedRequest(request: request1, version: version, identifierGenerator: identifierGenerator)
        self.inflatedRequest2 = InflatedRequest(request: request2, version: version, identifierGenerator: identifierGenerator)
    }

    func parseResponseObject(object: AnyObject) throws -> Response {
        guard let array = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try inflatedRequest1.parseResponseArray(array),
            try inflatedRequest2.parseResponseArray(array)
        )
    }
}

struct Call3<Request1: RequestType, Request2: RequestType, Request3: RequestType>: CallType {
    typealias Response = (Request1.Response, Request2.Response, Request3.Response)

    let inflatedRequest1: InflatedRequest<Request1>
    let inflatedRequest2: InflatedRequest<Request2>
    let inflatedRequest3: InflatedRequest<Request3>

    var requestObject: AnyObject {
        return [
            inflatedRequest1.body,
            inflatedRequest2.body,
            inflatedRequest3.body,
        ]
    }

    init(request1: Request1, request2: Request2, request3: Request3, version: String, identifierGenerator: RequestIdentifierGenerator) {
        self.inflatedRequest1 = InflatedRequest(request: request1, version: version, identifierGenerator: identifierGenerator)
        self.inflatedRequest2 = InflatedRequest(request: request2, version: version, identifierGenerator: identifierGenerator)
        self.inflatedRequest3 = InflatedRequest(request: request3, version: version, identifierGenerator: identifierGenerator)
    }

    func parseResponseObject(object: AnyObject) throws -> Response {
        guard let array = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try inflatedRequest1.parseResponseArray(array),
            try inflatedRequest2.parseResponseArray(array),
            try inflatedRequest3.parseResponseArray(array)
        )
    }
}
