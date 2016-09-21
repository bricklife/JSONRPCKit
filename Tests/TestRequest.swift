//
//  TestRequest.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/28.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import JSONRPCKit

struct TestRequest: RequestType {
    typealias Response = Any

    let method: String
    let parameters: Any?
    let extendedFields: [String : Any]?

    init(method: String, parameters: Any?, extendedFields: [String: Any]? = nil) {
        self.method = method
        self.parameters = parameters
        self.extendedFields = extendedFields
    }

    func responseFromResultObject(_ resultObject: Any) throws -> Any {
        return resultObject
    }
}

struct TestNotificationRequest: RequestType {
    typealias Response = Void

    let method: String
    let parameters: Any?
}

struct TestParseErrorRequest: RequestType {
    struct ParseError: Error {

    }

    typealias Response = Any

    let method: String
    let parameters: Any?

    func responseFromResultObject(_ resultObject: Any) throws -> Any {
        throw ParseError()
    }
}
