//
//  Id.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 11/12/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import Foundation

public enum Id {
    case number(Int)
    case string(Swift.String)
}

extension Id {
    
    public init?(value: Any) {
        switch value {
        case let number as Int:
            self = .number(number)
        case let string as Swift.String:
            self = .string(string)
        default:
            return nil
        }
    }
    
    public var value: Any {
        switch self {
        case .number(let number):
            return number as Any
        case .string(let string):
            return string as Any
        }
    }
}

extension Id: Hashable {
    
    public var hashValue: Int {
        switch self {
        case .number(let number):
            return number
        case .string(let string):
            return string.hashValue
        }
    }
}

extension Id: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .number(value)
        } else {
            self = .string(try container.decode(String.self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .number(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}

public func ==(lhs: Id, rhs: Id) -> Bool {
    if case let (.number(left), .number(right)) = (lhs, rhs) {
        return left == right
    }
    
    if case let (.string(left), .string(right)) = (lhs, rhs) {
        return left == right
    }
    
    return false
}
