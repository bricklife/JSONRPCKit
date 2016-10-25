//
//  TestRequest.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/28.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import JSONRPCKit

struct TestRequest: Request {
    typealias Response = Any

    let method: String
    let parameters: Any?
    let extendedFields: [String : Any]?

    init(method: String, parameters: Any?, extendedFields: [String: Any]? = nil) {
        self.method = method
        self.parameters = parameters
        self.extendedFields = extendedFields
    }

    func response(from resultObject: Any) throws -> Any {
        return resultObject
    }
}

struct TestNotificationRequest: Request {
    typealias Response = Void

    let method: String
    let parameters: Any?
}

struct TestParseErrorRequest: Request {
    struct ParseError: Error {

    }

    typealias Response = Any

    let method: String
    let parameters: Any?

    func response(from resultObject: Any) throws -> Any {
        throw ParseError()
    }
}
