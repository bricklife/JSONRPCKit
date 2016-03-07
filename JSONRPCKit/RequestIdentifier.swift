//
//  RequestIdentifier.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 11/12/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import Foundation

public enum RequestIdentifier {
    case NumberIdentifier(Int)
    case StringIdentifier(String)
}

extension RequestIdentifier {
    
    public init?(value: AnyObject) {
        switch value {
        case let number as Int:
            self = .NumberIdentifier(number)
        case let string as String:
            self = .StringIdentifier(string)
        default:
            return nil
        }
    }
    
    public var value: AnyObject {
        switch self {
        case NumberIdentifier(let number):
            return number
        case StringIdentifier(let string):
            return string
        }
    }
}

extension RequestIdentifier: Hashable {
    
    public var hashValue: Int {
        switch self {
        case NumberIdentifier(let number):
            return number
        case StringIdentifier(let string):
            return string.hashValue
        }
    }
}

public func ==(lhs: RequestIdentifier, rhs: RequestIdentifier) -> Bool {
    if case let (.NumberIdentifier(left), .NumberIdentifier(right)) = (lhs, rhs) {
        return left == right
    }
    
    if case let (.StringIdentifier(left), .StringIdentifier(right)) = (lhs, rhs) {
        return left == right
    }
    
    return false
}
