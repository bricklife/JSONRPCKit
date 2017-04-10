//
//  IdGenerator.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/11.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol IdGenerator {

    mutating func next() -> Id
}
