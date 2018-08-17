//
//  Batch.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

public protocol Batch: Encodable {
    associatedtype Responses
    associatedtype Results

    func responses(from data: Data) throws -> Responses
    func results(from data: Data) -> Results

    static func responses(from results: Results) throws -> Responses
}

public struct Batch1<Request: JSONRPCKit.Request>: Batch {
    public typealias Responses = Request.Response
    public typealias Results = Result<Request.Response, JSONRPCError>

    public let batchElement: BatchElement<Request>

    public func responses(from data: Data) throws -> Responses {
        return try batchElement.response(from: data)
    }

    public func results(from data: Data) -> Results {
        return batchElement.result(from: data)
    }

    public static func responses(from results: Results) throws -> Responses {
        return try results.dematerialize()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(batchElement)
    }
}

public struct Batch2<Request1: Request, Request2: Request>: Batch {
    public typealias Responses = (Request1.Response, Request2.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>)

    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>


    public func responses(from data: Data) throws -> Responses {

        return (
            try batchElement1.response(fromArray: data),
            try batchElement2.response(fromArray: data)
        )
    }

    public func results(from data: Data) -> Results {
        return (
            batchElement1.result(from: data),
            batchElement2.result(from: data)
        )
    }

    public static func responses(from results: Results) throws -> Responses {
        return (
            try results.0.dematerialize(),
            try results.1.dematerialize()
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(batchElement1)
        try container.encode(batchElement2)
    }
}

public struct Batch3<Request1: Request, Request2: Request, Request3: Request>: Batch {
    public typealias Responses = (Request1.Response, Request2.Response, Request3.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>, Result<Request3.Response, JSONRPCError>)

    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>
    public let batchElement3: BatchElement<Request3>

    public func responses(from data: Data) throws -> Responses {
        return (
            try batchElement1.response(fromArray: data),
            try batchElement2.response(fromArray: data),
            try batchElement3.response(fromArray: data)
        )
    }

    public func results(from data: Data) -> Results {
        return (
            batchElement1.result(from: data),
            batchElement2.result(from: data),
            batchElement3.result(from: data)
        )
    }

    public static func responses(from results: Results) throws -> Responses {
        return (
            try results.0.dematerialize(),
            try results.1.dematerialize(),
            try results.2.dematerialize()
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(batchElement1)
        try container.encode(batchElement2)
        try container.encode(batchElement3)
    }
}

public struct Batch4<Request1: Request, Request2: Request, Request3: Request, Request4: Request>: Batch {
    public typealias Responses = (Request1.Response, Request2.Response, Request3.Response, Request4.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>, Result<Request3.Response, JSONRPCError>, Result<Request4.Response, JSONRPCError>)

    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>
    public let batchElement3: BatchElement<Request3>
    public let batchElement4: BatchElement<Request4>

    public func responses(from data: Data) throws -> Responses {
        return (
            try batchElement1.response(fromArray: data),
            try batchElement2.response(fromArray: data),
            try batchElement3.response(fromArray: data),
            try batchElement4.response(fromArray: data)
        )
    }

    public func results(from data: Data) -> Results {
        return (
            batchElement1.result(from: data),
            batchElement2.result(from: data),
            batchElement3.result(from: data),
            batchElement4.result(from: data)
        )
    }

    public static func responses(from results: Results) throws -> Responses {
        return (
            try results.0.dematerialize(),
            try results.1.dematerialize(),
            try results.2.dematerialize(),
            try results.3.dematerialize()
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(batchElement1)
        try container.encode(batchElement2)
        try container.encode(batchElement3)
        try container.encode(batchElement4)
    }
}

public struct Batch5<Request1: Request, Request2: Request, Request3: Request, Request4: Request, Request5: Request>: Batch {
    public typealias Responses = (Request1.Response, Request2.Response, Request3.Response, Request4.Response, Request5.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>, Result<Request3.Response, JSONRPCError>, Result<Request4.Response, JSONRPCError>, Result<Request5.Response, JSONRPCError>)

    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>
    public let batchElement3: BatchElement<Request3>
    public let batchElement4: BatchElement<Request4>
    public let batchElement5: BatchElement<Request5>

    public func responses(from data: Data) throws -> Responses {
        return (
            try batchElement1.response(fromArray: data),
            try batchElement2.response(fromArray: data),
            try batchElement3.response(fromArray: data),
            try batchElement4.response(fromArray: data),
            try batchElement5.response(fromArray: data)
        )
    }

    public func results(from data: Data) -> Results {
        return (
            batchElement1.result(from: data),
            batchElement2.result(from: data),
            batchElement3.result(from: data),
            batchElement4.result(from: data),
            batchElement5.result(from: data)
        )
    }

    public static func responses(from results: Results) throws -> Responses {
        return (
            try results.0.dematerialize(),
            try results.1.dematerialize(),
            try results.2.dematerialize(),
            try results.3.dematerialize(),
            try results.4.dematerialize()
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(batchElement1)
        try container.encode(batchElement2)
        try container.encode(batchElement3)
        try container.encode(batchElement4)
        try container.encode(batchElement5)
    }
}

public struct Batch6<Request1: Request, Request2: Request, Request3: Request, Request4: Request, Request5: Request, Request6: Request>: Batch {
    public typealias Responses = (Request1.Response, Request2.Response, Request3.Response, Request4.Response, Request5.Response, Request6.Response)
    public typealias Results = (Result<Request1.Response, JSONRPCError>, Result<Request2.Response, JSONRPCError>, Result<Request3.Response, JSONRPCError>, Result<Request4.Response, JSONRPCError>, Result<Request5.Response, JSONRPCError>, Result<Request6.Response, JSONRPCError>)

    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>
    public let batchElement3: BatchElement<Request3>
    public let batchElement4: BatchElement<Request4>
    public let batchElement5: BatchElement<Request5>
    public let batchElement6: BatchElement<Request6>

    public func responses(from data: Data) throws -> Responses {
        return (
            try batchElement1.response(fromArray: data),
            try batchElement2.response(fromArray: data),
            try batchElement3.response(fromArray: data),
            try batchElement4.response(fromArray: data),
            try batchElement5.response(fromArray: data),
            try batchElement6.response(fromArray: data)
        )
    }

    public func results(from data: Data) -> Results {
        return (
            batchElement1.result(from: data),
            batchElement2.result(from: data),
            batchElement3.result(from: data),
            batchElement4.result(from: data),
            batchElement5.result(from: data),
            batchElement6.result(from: data)
        )
    }

    public static func responses(from results: Results) throws -> Responses {
        return (
            try results.0.dematerialize(),
            try results.1.dematerialize(),
            try results.2.dematerialize(),
            try results.3.dematerialize(),
            try results.4.dematerialize(),
            try results.5.dematerialize()
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(batchElement1)
        try container.encode(batchElement2)
        try container.encode(batchElement3)
        try container.encode(batchElement4)
        try container.encode(batchElement5)
        try container.encode(batchElement6)
    }
}
