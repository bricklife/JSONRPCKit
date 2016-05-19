//
//  MathService.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 11/11/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import Foundation
import JSONRPCKit
import Alamofire

// use https://github.com/jenolan/jsonrpcx-php/blob/master/examples/server.php

class MathServiceAPI {
    
    static func request(jsonrpc: JSONRPC, errorHandler: ((error: NSError) -> Void)? = nil) {
        guard let requestJSON = try? jsonrpc.buildRequestJSON() else {
            return
        }
        
        print("request:", requestJSON, separator: "\n")
        
        let URLRequest = NSMutableURLRequest()
        URLRequest.URL = NSURL(string: "https://jsonrpckit-demo.appspot.com")!
        URLRequest.HTTPMethod = "POST"
        URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(requestJSON, options: [])
        
        Alamofire.request(URLRequest)
            .responseJSON { response in
                switch response.result {
                case .Success(let responseJSON):
                    print("response:", responseJSON, separator: "\n")
                    
                    do {
                        try jsonrpc.parseResponseJSON(responseJSON)
                    } catch {}
                    
                case .Failure(let error):
                    print("error:", error, separator: "\n")
                    
                    if let errorHandler = errorHandler {
                        errorHandler(error: error)
                    }
                }
        }
    }
}

struct Subtract: RequestType {
    typealias Response = Int
    
    let minuend: Int
    let subtrahend: Int
    
    var method: String {
        return "subtract"
    }
    
    var params: AnyObject? {
        return [minuend, subtrahend]
    }
    
    func responseFromObject(object: AnyObject) -> Response? {
        return object as? Response
    }
}

struct Multiply: RequestType {
    typealias Response = Int
    
    let multiplicand: Int
    let multiplier: Int
    
    var method: String {
        return "multiply"
    }
    
    var params: AnyObject? {
        return [multiplicand, multiplier]
    }
    
    func responseFromObject(object: AnyObject) -> Response? {
        return object as? Response
    }
}

struct Divide: RequestType {
    typealias Response = Float
    
    let dividend: Int
    let divisor: Int
    
    var method: String {
        return "divide"
    }
    
    var params: AnyObject? {
        return [dividend, divisor]
    }
    
    func responseFromObject(object: AnyObject) -> Response? {
        return object as? Response
    }
}
