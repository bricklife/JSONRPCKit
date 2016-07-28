//
//  NumberIdentifierGenerator.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/11.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public struct NumberIdGenerator: IdGeneratorType {
    
    private var currentId = 1

    public mutating func next() -> Id {
        defer {
            currentId += 1
        }
        
        return .Number(currentId)
    }
}
