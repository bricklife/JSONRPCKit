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

struct Call1<Request: RequestType>: CallType {
    typealias Response = Request.Response

    let element: CallElement<Request>
    
    var requestObject: AnyObject {
        return element.body
    }

    func parseResponseObject(object: AnyObject) throws -> Response {
        return try element.parseResponseObject(object)
    }
}

struct Call2<Request1: RequestType, Request2: RequestType>: CallType {
    typealias Response = (Request1.Response, Request2.Response)

    let element1: CallElement<Request1>
    let element2: CallElement<Request2>

    var requestObject: AnyObject {
        return [
            element1.body,
            element2.body,
        ]
    }

    func parseResponseObject(object: AnyObject) throws -> Response {
        guard let array = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try element1.parseResponseArray(array),
            try element2.parseResponseArray(array)
        )
    }
}

struct Call3<Request1: RequestType, Request2: RequestType, Request3: RequestType>: CallType {
    typealias Response = (Request1.Response, Request2.Response, Request3.Response)

    let element1: CallElement<Request1>
    let element2: CallElement<Request2>
    let element3: CallElement<Request3>

    var requestObject: AnyObject {
        return [
            element1.body,
            element2.body,
            element3.body,
        ]
    }

    func parseResponseObject(object: AnyObject) throws -> Response {
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
