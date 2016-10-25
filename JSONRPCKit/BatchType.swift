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

    var requestObject: Any { get }

    func responses(from object: Any) throws -> Responses
    func results(from object: Any) -> Results

    static func responses(from results: Results) throws -> Responses
}

public struct Batch<Request: RequestType>: BatchType {
    public typealias Responses = Request.Response
    public typealias Results = Result<Request.Response, JSONRPCError>

    public let batchElement: BatchElement<Request>
    
    public var requestObject: Any {
        return batchElement.body
    }

    public func responses(from object: Any) throws -> Responses {
        return try batchElement.response(from: object)
    }

    public func results(from object: Any) -> Results {
        return batchElement.result(from: object)
    }

    public static func responses(from results: Results) throws -> Responses {
        return try results.dematerialize()
    }
}

public struct Batch2<Request1: RequestType, Request2: RequestType>: BatchType {
    public typealias Responses = (Request1.Response, Request2.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>)

    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>

    public var requestObject: Any {
        return [
            batchElement1.body,
            batchElement2.body,
        ]
    }

    public func responses(from object: Any) throws -> Responses {
        guard let batchObjects = object as? [Any] else {
            throw JSONRPCError.nonArrayResponse(object)
        }

        return (
            try batchElement1.response(from: batchObjects),
            try batchElement2.response(from: batchObjects)
        )
    }

    public func results(from object: Any) -> Results {
        guard let batchObjects = object as? [Any] else {
            return (
                .failure(.nonArrayResponse(object)),
                .failure(.nonArrayResponse(object))
            )
        }

        return (
            batchElement1.result(from: batchObjects),
            batchElement2.result(from: batchObjects)
        )
    }

    public static func responses(from results: Results) throws -> Responses {
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

    public var requestObject: Any {
        return [
            batchElement1.body,
            batchElement2.body,
            batchElement3.body,
        ]
    }

    public func responses(from object: Any) throws -> Responses {
        guard let batchObjects = object as? [Any] else {
            throw JSONRPCError.nonArrayResponse(object)
        }

        return (
            try batchElement1.response(from: batchObjects),
            try batchElement2.response(from: batchObjects),
            try batchElement3.response(from: batchObjects)
        )
    }

    public func results(from object: Any) -> Results {
        guard let batchObjects = object as? [Any] else {
            return (
                .failure(.nonArrayResponse(object)),
                .failure(.nonArrayResponse(object)),
                .failure(.nonArrayResponse(object))
            )
        }

        return (
            batchElement1.result(from: batchObjects),
            batchElement2.result(from: batchObjects),
            batchElement3.result(from: batchObjects)
        )
    }

    public static func responses(from results: Results) throws -> Responses {
        return (
            try results.0.dematerialize(),
            try results.1.dematerialize(),
            try results.2.dematerialize()
        )
    }
}
