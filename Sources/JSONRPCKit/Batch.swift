//
//  Batch.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/27.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

public protocol DecoderType {
    func decode<T: Decodable >(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: DecoderType { }

public protocol Batch: Encodable {
    associatedtype Responses
    associatedtype Results

    var decoder: DecoderType { get set }

    func responses(from data: Data) throws -> Responses
    func results(from data: Data) -> Results

    static func responses(from results: Results) throws -> Responses
}

public struct Batch1<Request: JSONRPCKit.Request>: Batch {
    public typealias Responses = Request.Response
    public typealias Results = Result<Request.Response, JSONRPCError>

    public var batchElement: BatchElement<Request>
    public var decoder: DecoderType = JSONDecoder() {
        didSet {
            batchElement.decoder = decoder
        }
    }

    init(batchElement: BatchElement<Request>) {
        self.batchElement = batchElement
    }

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

    public var batchElement1: BatchElement<Request1>
    public var batchElement2: BatchElement<Request2>
    public var decoder: DecoderType = JSONDecoder() {
        didSet {
            batchElement1.decoder = decoder
            batchElement2.decoder = decoder
        }
    }

    init(batchElement1: BatchElement<Request1>, batchElement2: BatchElement<Request2>) {
        self.batchElement1 = batchElement1
        self.batchElement2 = batchElement2
    }

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

    public var batchElement1: BatchElement<Request1>
    public var batchElement2: BatchElement<Request2>
    public var batchElement3: BatchElement<Request3>
    public var decoder: DecoderType = JSONDecoder() {
        didSet {
            batchElement1.decoder = decoder
            batchElement2.decoder = decoder
            batchElement3.decoder = decoder
        }
    }

    init(batchElement1: BatchElement<Request1>, batchElement2: BatchElement<Request2>,
         batchElement3: BatchElement<Request3>) {
        self.batchElement1 = batchElement1
        self.batchElement2 = batchElement2
        self.batchElement3 = batchElement3
    }

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

    public var batchElement1: BatchElement<Request1>
    public var batchElement2: BatchElement<Request2>
    public var batchElement3: BatchElement<Request3>
    public var batchElement4: BatchElement<Request4>
    public var decoder: DecoderType = JSONDecoder() {
        didSet {
            batchElement1.decoder = decoder
            batchElement2.decoder = decoder
            batchElement3.decoder = decoder
            batchElement4.decoder = decoder
        }
    }

    init(batchElement1: BatchElement<Request1>, batchElement2: BatchElement<Request2>,
         batchElement3: BatchElement<Request3>, batchElement4: BatchElement<Request4>) {
        self.batchElement1 = batchElement1
        self.batchElement2 = batchElement2
        self.batchElement3 = batchElement3
        self.batchElement4 = batchElement4
    }

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

    public var batchElement1: BatchElement<Request1>
    public var batchElement2: BatchElement<Request2>
    public var batchElement3: BatchElement<Request3>
    public var batchElement4: BatchElement<Request4>
    public var batchElement5: BatchElement<Request5>
    public var decoder: DecoderType = JSONDecoder() {
        didSet {
            batchElement1.decoder = decoder
            batchElement2.decoder = decoder
            batchElement3.decoder = decoder
            batchElement4.decoder = decoder
            batchElement5.decoder = decoder
        }
    }

    init(batchElement1: BatchElement<Request1>, batchElement2: BatchElement<Request2>,
         batchElement3: BatchElement<Request3>, batchElement4: BatchElement<Request4>,
         batchElement5: BatchElement<Request5>) {
        self.batchElement1 = batchElement1
        self.batchElement2 = batchElement2
        self.batchElement3 = batchElement3
        self.batchElement4 = batchElement4
        self.batchElement5 = batchElement5
    }

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

    public var batchElement1: BatchElement<Request1>
    public var batchElement2: BatchElement<Request2>
    public var batchElement3: BatchElement<Request3>
    public var batchElement4: BatchElement<Request4>
    public var batchElement5: BatchElement<Request5>
    public var batchElement6: BatchElement<Request6>
    public var decoder: DecoderType = JSONDecoder() {
        didSet {
            batchElement1.decoder = decoder
            batchElement2.decoder = decoder
            batchElement3.decoder = decoder
            batchElement4.decoder = decoder
            batchElement5.decoder = decoder
            batchElement6.decoder = decoder
        }
    }

    init(batchElement1: BatchElement<Request1>, batchElement2: BatchElement<Request2>,
         batchElement3: BatchElement<Request3>, batchElement4: BatchElement<Request4>,
         batchElement5: BatchElement<Request5>, batchElement6: BatchElement<Request6>) {
        self.batchElement1 = batchElement1
        self.batchElement2 = batchElement2
        self.batchElement3 = batchElement3
        self.batchElement4 = batchElement4
        self.batchElement5 = batchElement5
        self.batchElement6 = batchElement6
    }

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
