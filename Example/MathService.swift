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

// https://jsonrpcx.org/AuthX/Cookbook

class MathServiceAPI {
    
    static let userName = "jenolan"
    static let APIKey = "qIQlg9S28mbK2Iolm8yffr97Yp6zMxiF"
    
    static func request(jsonrpc: JSONRPC) {
        guard let requestJSON = try? jsonrpc.buildRequestJSON() else {
            return
        }
        
        print("request:")
        print(requestJSON)
        
        let URLRequest = NSMutableURLRequest()
        URLRequest.URL = NSURL(string: "https://jsonrpcx.org/api/authUserServer.php")!
        URLRequest.HTTPMethod = "POST"
        URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(requestJSON, options: [])
        
        Alamofire.request(URLRequest)
            .responseJSON { response in
                if let responseJSON = response.result.value {
                    print("response:")
                    print(responseJSON)
                    try! jsonrpc.parseResponseJSON(responseJSON)
                }
        }
    }
}

struct Subtract: AuthRequestType {
    typealias Response = Int
    
    let userName: String
    let APIKey: String
    
    let minuend: Int
    let subtrahend: Int
    
    var method: String {
        return "subtract"
    }
    
    var params: AnyObject? {
        return [self.minuend, self.subtrahend]
    }
    
    var auth: String? {
        return "\(self.userName)|\(self.APIKey)"
    }
    
    func responseFromObject(object: AnyObject) -> Response? {
        return object as? Response
    }
}

struct Multiply: AuthRequestType {
    typealias Response = Int
    
    let userName: String
    let APIKey: String
    
    let multiplicand: Int
    let multiplier: Int
    
    var method: String {
        return "multiply"
    }
    
    var params: AnyObject? {
        return [self.multiplicand, self.multiplier]
    }
    
    var auth: String? {
        return "\(self.userName)|\(self.APIKey)"
    }
    
    func responseFromObject(object: AnyObject) -> Response? {
        return object as? Response
    }
}

struct Divide: AuthRequestType {
    typealias Response = Float
    
    let userName: String
    let APIKey: String
    
    let dividend: Int
    let divisor: Int
    
    var method: String {
        return "divide"
    }
    
    var params: AnyObject? {
        return [self.dividend, self.divisor]
    }
    
    var auth: String? {
        return "\(self.userName)|\(self.APIKey)"
    }
    
    func responseFromObject(object: AnyObject) -> Response? {
        return object as? Response
    }
}
