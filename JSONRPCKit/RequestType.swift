//
//  RequestType.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol RequestType {
    associatedtype Response
    
    var method: String { get }
    
    var params: AnyObject? { get }
    
    func buildJSON() -> [String: AnyObject]
    
    func responseFromObject(object: AnyObject) -> Response?
}

public extension RequestType {
    
    var params: AnyObject? {
        return nil
    }
    
    func buildJSON() -> [String: AnyObject] {
        var json: [String: AnyObject] = [:]
        
        json["method"] = method
        
        if let params = params {
            json["params"] = params
        }
        
        return json
    }
}
