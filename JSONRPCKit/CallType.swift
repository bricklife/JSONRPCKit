//
//  CallType.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol CallType {
    associatedtype Response

    var requestObject: AnyObject { get }

    func parseResponseObject(object: AnyObject) throws -> Response
}

public struct Call1<Request: RequestType>: CallType {
    public typealias Response = Request.Response

    public let element: CallElement<Request>
    
    public var requestObject: AnyObject {
        return element.body
    }

    public func parseResponseObject(object: AnyObject) throws -> Response {
        return try element.parseResponseObject(object)
    }
}

public struct Call2<Request1: RequestType, Request2: RequestType>: CallType {
    public typealias Response = (Request1.Response, Request2.Response)

    public let element1: CallElement<Request1>
    public let element2: CallElement<Request2>

    public var requestObject: AnyObject {
        return [
            element1.body,
            element2.body,
        ]
    }

    public func parseResponseObject(object: AnyObject) throws -> Response {
        guard let array = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try element1.parseResponseArray(array),
            try element2.parseResponseArray(array)
        )
    }
}

public struct Call3<Request1: RequestType, Request2: RequestType, Request3: RequestType>: CallType {
    public typealias Response = (Request1.Response, Request2.Response, Request3.Response)

    public let element1: CallElement<Request1>
    public let element2: CallElement<Request2>
    public let element3: CallElement<Request3>

    public var requestObject: AnyObject {
        return [
            element1.body,
            element2.body,
            element3.body,
        ]
    }

    public func parseResponseObject(object: AnyObject) throws -> Response {
        guard let array = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try element1.parseResponseArray(array),
            try element2.parseResponseArray(array),
            try element3.parseResponseArray(array)
        )
    }
}
