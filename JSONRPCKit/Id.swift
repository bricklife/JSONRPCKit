//
//  Id.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 11/12/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import Foundation

public enum Id {
    case Number(Int)
    case String(Swift.String)
}

extension Id {
    
    public init?(value: AnyObject) {
        switch value {
        case let number as Int:
            self = .Number(number)
        case let string as Swift.String:
            self = .String(string)
        default:
            return nil
        }
    }
    
    public var value: AnyObject {
        switch self {
        case Number(let number):
            return number
        case String(let string):
            return string
        }
    }
}

extension Id: Hashable {
    
    public var hashValue: Int {
        switch self {
        case Number(let number):
            return number
        case String(let string):
            return string.hashValue
        }
    }
}

public func ==(lhs: Id, rhs: Id) -> Bool {
    if case let (.Number(left), .Number(right)) = (lhs, rhs) {
        return left == right
    }
    
    if case let (.String(left), .String(right)) = (lhs, rhs) {
        return left == right
    }
    
    return false
}
