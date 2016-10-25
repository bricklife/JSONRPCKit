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

struct MathServiceRequest<Batch: Batch>: APIKit.RequestType {
    let batch: Batch

    typealias Response = Batch.Responses

    var baseURL: NSURL {
        return NSURL(string: "https://jsonrpckit-demo.appspot.com")!
    }

    var method: HTTPMethod {
        return .POST
    }

    var path: String {
        return "/"
    }

    var parameters: AnyObject? {
        return batch.requestObject
    }

    func response(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        return try batch.responses(object)
    }
}

struct CastError<ExpectedType>: ErrorType {
    let actualValue: Any
    let expectedType: ExpectedType.Type
}

struct Subtract: JSONRPCKit.RequestType {
    typealias Response = Int
    
    let minuend: Int
    let subtrahend: Int
    
    var method: String {
        return "subtract"
    }

    var parameters: AnyObject? {
        return [minuend, subtrahend]
    }
    
    func response(resultObject: AnyObject) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct Multiply: JSONRPCKit.RequestType {
    typealias Response = Int
    
    let multiplicand: Int
    let multiplier: Int
    
    var method: String {
        return "multiply"
    }
    
    var parameters: AnyObject? {
        return [multiplicand, multiplier]
    }
    
    func response(resultObject: AnyObject) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct Divide: JSONRPCKit.RequestType {
    typealias Response = Float
    
    let dividend: Int
    let divisor: Int
    
    var method: String {
        return "divide"
    }
    
    var parameters: AnyObject? {
        return [dividend, divisor]
    }
    
    func response(resultObject: AnyObject) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
