//
//  BatchType.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

public protocol BatchType {
    associatedtype Responses
    associatedtype Results

    var requestObject: AnyObject { get }

    func responsesFromObject(object: AnyObject) throws -> Responses
    func resultsFromObject(object: AnyObject) -> Results

    static func responsesFromResults(results: Results) throws -> Responses
}

public struct Batch<Request: RequestType>: BatchType {
    public typealias Responses = Request.Response
    public typealias Results = Result<Request.Response, JSONRPCError>

    public let batchElement: BatchElement<Request>
    
    public var requestObject: AnyObject {
        return batchElement.body
    }

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        return try batchElement.responseFromObject(object)
    }

    public func resultsFromObject(object: AnyObject) -> Results {
        return batchElement.resultFromObject(object)
    }

    public static func responsesFromResults(results: Results) throws -> Responses {
        return try results.dematerialize()
    }
}

public struct Batch2<Request1: RequestType, Request2: RequestType>: BatchType {
    public typealias Responses = (Request1.Response, Request2.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>)

    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>

    public var requestObject: AnyObject {
        return [
            batchElement1.body,
            batchElement2.body,
        ]
    }

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        guard let batchObjects = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try batchElement1.responseFromBatchObjects(batchObjects),
            try batchElement2.responseFromBatchObjects(batchObjects)
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
            batchElement1.resultFromBatchObjects(batchObjects),
            batchElement2.resultFromBatchObjects(batchObjects)
        )
    }

    public static func responsesFromResults(results: Results) throws -> Responses {
        return (
            try results.0.dematerialize(),
            try results.1.dematerialize()
        )
    }
}

public struct Batch3<Request1: RequestType, Request2: RequestType, Request3: RequestType>: BatchType {
    public typealias Responses = (Request1.Response, Request2.Response, Request3.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>, Result<Request3.Response, JSONRPCError>)

    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>
    public let batchElement3: BatchElement<Request3>

    public var requestObject: AnyObject {
        return [
            batchElement1.body,
            batchElement2.body,
            batchElement3.body,
        ]
    }

    public func responsesFromObject(object: AnyObject) throws -> Responses {
        guard let batchObjects = object as? [AnyObject] else {
            throw JSONRPCError.NonArrayResponse(object)
        }

        return (
            try batchElement1.responseFromBatchObjects(batchObjects),
            try batchElement2.responseFromBatchObjects(batchObjects),
            try batchElement3.responseFromBatchObjects(batchObjects)
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
            batchElement1.resultFromBatchObjects(batchObjects),
            batchElement2.resultFromBatchObjects(batchObjects),
            batchElement3.resultFromBatchObjects(batchObjects)
        )
    }

    public static func responsesFromResults(results: Results) throws -> Responses {
        return (
            try results.0.dematerialize(),
            try results.1.dematerialize(),
            try results.2.dematerialize()
        )
    }
}
