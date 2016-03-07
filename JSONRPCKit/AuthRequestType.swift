//
//  AuthRequestType.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 11/11/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol AuthRequestType : RequestType {
    
    var auth: String? { get }
}

public extension AuthRequestType {
    
    func buildJSON() -> [String: AnyObject] {
        var json: [String: AnyObject] = [:]
        
        json["method"] = method
        
        if let params = params {
            json["params"] = params
        }
        
        if let auth = auth {
            json["auth"] = auth
        }
        
        return json
    }
}
