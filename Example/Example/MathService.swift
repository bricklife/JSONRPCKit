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
        return batch.requestObject
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
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

    var parameters: Any? {
        return [minuend, subtrahend]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct Multiply: JSONRPCKit.Request {
    typealias Response = Int
    
    let multiplicand: Int
    let multiplier: Int
    
    var method: String {
        return "multiply"
    }
    
    var parameters: Any? {
        return [multiplicand, multiplier]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct Divide: JSONRPCKit.Request {
    typealias Response = Float
    
    let dividend: Int
    let divisor: Int
    
    var method: String {
        return "divide"
    }
    
    var parameters: Any? {
        return [dividend, divisor]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
