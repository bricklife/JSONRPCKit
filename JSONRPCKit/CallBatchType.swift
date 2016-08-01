//
//  CallBatchType.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

public protocol CallBatchType {
    associatedtype Responses
    associatedtype Results

    var requestObject: AnyObject { get }

    func responsesFromObject(object: AnyObject) throws -> Responses
    func resultsFromObject(object: AnyObject) -> Results
}

public struct CallBatch1<Request: RequestType>: CallBatchType {
    public typealias Responses = Request.Response
    public typealias Results = Result<Request.Response, JSONRPCError>

    public let call: Call<Request>
    
    public var requestObject: AnyObject {
        return call.body
    }

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        return try call.responseFromObject(object)
    }

    public func resultsFromObject(object: AnyObject) -> Results {
        return call.resultFromObject(object)
    }
}

public struct CallBatch2<Request1: RequestType, Request2: RequestType>: CallBatchType {
    public typealias Responses = (Request1.Response, Request2.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>)

    public let call1: Call<Request1>
    public let call2: Call<Request2>

    public var requestObject: AnyObject {
        return [
            call1.body,
            call2.body,
        ]
    }

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        guard let batchObjects = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try call1.responseFromBatchObjects(batchObjects),
            try call2.responseFromBatchObjects(batchObjects)
        )
    }

    public func resultsFromObject(object: AnyObject) -> Results {
        guard let batchObjects = object as? [AnyObject] else {
            return (
                .Failure(.NonArrayResponse(object)),
                .Failure(.NonArrayResponse(object))
            )
        }

        return (
            call1.resultFromBatchObjects(batchObjects),
            call2.resultFromBatchObjects(batchObjects)
        )
    }
}

public struct CallBatch3<Request1: RequestType, Request2: RequestType, Request3: RequestType>: CallBatchType {
    public typealias Responses = (Request1.Response, Request2.Response, Request3.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>, Result<Request3.Response, JSONRPCError>)

    public let call1: Call<Request1>
    public let call2: Call<Request2>
    public let call3: Call<Request3>

    public var requestObject: AnyObject {
        return [
            call1.body,
            call2.body,
            call3.body,
        ]
    }

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        guard let batchObjects = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try call1.responseFromBatchObjects(batchObjects),
            try call2.responseFromBatchObjects(batchObjects),
            try call3.responseFromBatchObjects(batchObjects)
        )
    }

    public func resultsFromObject(object: AnyObject) -> Results {
        guard let batchObjects = object as? [AnyObject] else {
            return (
                .Failure(.NonArrayResponse(object)),
                .Failure(.NonArrayResponse(object)),
                .Failure(.NonArrayResponse(object))
            )
        }

        return (
            call1.resultFromBatchObjects(batchObjects),
            call2.resultFromBatchObjects(batchObjects),
            call3.resultFromBatchObjects(batchObjects)
        )
    }
}
