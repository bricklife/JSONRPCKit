//
//  NumberIdentifierGenerator.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/11.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public class NumberIdentifierGenerator: RequestIdentifierGenerator {
    
    private var currentIdentifier = 1
    
    public func next() -> RequestIdentifier {
        return .NumberIdentifier(self.currentIdentifier++)
    }
}
