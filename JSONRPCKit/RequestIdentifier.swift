//
//  RequestIdentifier.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 11/12/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import Foundation

public enum RequestIdentifier: Hashable {
    case NumberType(Int)
    case StringType(String)
    
    public var hashValue: Int {
        switch self {
        case NumberType(let number):
            return number
        case StringType(let string):
            return string.hashValue
        }
    }
}

public func ==(lhs: RequestIdentifier, rhs: RequestIdentifier) -> Bool {
    if case let (.NumberType(lnumber), .NumberType(rnumber)) = (lhs, rhs) {
        return lnumber == rnumber
    }
    
    if case let (.StringType(lstring), .StringType(rstring)) = (lhs, rhs) {
        return lstring == rstring
    }
    
    return false
}
