//
//  MathService.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 11/11/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import Foundation
import APIKit
import JSONRPCKit

// use https://github.com/jenolan/jsonrpcx-php/blob/master/examples/server.php

struct MathServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch

    typealias Response = Batch.Responses

    var baseURL: URL {
        return URL(string: "https://jsonrpckit-demo.appspot.com")!
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "/"
    }

    var parameters: Any? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(batch) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let jsonData = try JSONSerialization.data(withJSONObject:object)
        return try batch.responses(from: jsonData)
    }
}

struct CastError<ExpectedType>: Error {
    let actualValue: Any
    let expectedType: ExpectedType.Type
}

struct Subtract: JSONRPCKit.Request {
    typealias Response = Int
    
    let minuend: Int
    let subtrahend: Int
    
    var method: String {
        return "subtract"
    }

    var parameters: Encodable? {
        return [minuend, subtrahend]
    }
}

struct Multiply: JSONRPCKit.Request {
    typealias Response = Int
    
    let multiplicand: Int
    let multiplier: Int
    
    var method: String {
        return "multiply"
    }
    
    var parameters: Encodable? {
        return [multiplicand, multiplier]
    }

}

struct Divide: JSONRPCKit.Request {
    typealias Response = Float
    
    let dividend: Int
    let divisor: Int
    
    var method: String {
        return "divide"
    }
    
    var parameters: Encodable? {
        return [dividend, divisor]
    }
}
