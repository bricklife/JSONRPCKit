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

public class NumberIdentifierGenerator: RequestIdentifierGenerator {
    
    private var identifier = 1
    
    public func next() -> Int {
        return self.identifier++
    }
}

public class GUIDGenerator: RequestIdentifierGenerator {
    
    public func next() -> String {
        return NSUUID().UUIDString
    }
}
