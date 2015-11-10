//
//  MathService.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 11/11/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import Foundation
import JSONRPCKit

// https://jsonrpcx.org/AuthX/Cookbook

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
        return object as? Int
    }
}
