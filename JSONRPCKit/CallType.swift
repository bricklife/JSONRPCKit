//
//  CallType.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

public protocol CallType {
    associatedtype Responses
    associatedtype Results

    var requestObject: AnyObject { get }

    func responsesFromObject(object: AnyObject) throws -> Responses
    func resultsFromObject(object: AnyObject) -> Results
}

public struct Call1<Request: RequestType>: CallType {
    public typealias Responses = Request.Response
    public typealias Results = Result<Request.Response, JSONRPCError>

    public let element: CallElement<Request>
    
    public var requestObject: AnyObject {
        return element.body
    }

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        return try element.responseFromObject(object)
    }

    public func resultsFromObject(object: AnyObject) -> Results {
        return element.resultFromObject(object)
    }
}

public struct Call2<Request1: RequestType, Request2: RequestType>: CallType {
    public typealias Responses = (Request1.Response, Request2.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>)

    public let element1: CallElement<Request1>
    public let element2: CallElement<Request2>

    public var requestObject: AnyObject {
        return [
            element1.body,
            element2.body,
        ]
    }

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        guard let array = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try element1.responseFromArray(array),
            try element2.responseFromArray(array)
        )
    }

    public func resultsFromObject(object: AnyObject) -> Results {
        guard let array = object as? [AnyObject] else {
            return (
                .Failure(.NonArrayResponse(object)),
                .Failure(.NonArrayResponse(object))
            )
        }

        return (
            element1.resultFromArray(array),
            element2.resultFromArray(array)
        )
    }
}

public struct Call3<Request1: RequestType, Request2: RequestType, Request3: RequestType>: CallType {
    public typealias Responses = (Request1.Response, Request2.Response, Request3.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>, Result<Request3.Response, JSONRPCError>)

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

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        guard let array = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try element1.responseFromArray(array),
            try element2.responseFromArray(array),
            try element3.responseFromArray(array)
        )
    }

    public func resultsFromObject(object: AnyObject) -> Results {
        guard let array = object as? [AnyObject] else {
            return (
                .Failure(.NonArrayResponse(object)),
                .Failure(.NonArrayResponse(object)),
                .Failure(.NonArrayResponse(object))
            )
        }

        return (
            element1.resultFromArray(array),
            element2.resultFromArray(array),
            element3.resultFromArray(array)
        )
    }
}
