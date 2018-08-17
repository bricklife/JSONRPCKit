//
//  TestRequest.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/28.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import JSONRPCKit

struct TestRequestStringDict: Request {
    typealias Response = Dictionary<String, String>

    var method: String
    var parameters: Encodable?
}


struct TestNotificationRequest: Request {
    typealias Response = NoReply

    let method: String
    let parameters: Encodable?
}
