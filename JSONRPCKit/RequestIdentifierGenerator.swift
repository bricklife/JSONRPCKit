//
//  RequestIdentifierGenerator.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/11.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol RequestIdentifierGenerator {
    typealias IdentifierType: Hashable
    
    func next() -> IdentifierType
}

public struct RequestIdentifierGeneratorBox<T: Hashable>: RequestIdentifierGenerator {
    private let _next: () -> T
    
    public init<P: RequestIdentifierGenerator where P.IdentifierType == T>(_ generator: P) {
        _next = generator.next
    }
    
    public func next() -> T {
        return _next()
    }
}
