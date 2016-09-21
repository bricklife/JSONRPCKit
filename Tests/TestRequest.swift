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
    typealias Response = AnyObject

    let method: String
    let parameters: AnyObject?
    let extendedFields: [String : AnyObject]?

    init(method: String, parameters: AnyObject?, extendedFields: [String: AnyObject]? = nil) {
        self.method = method
        self.parameters = parameters
        self.extendedFields = extendedFields
    }

    func responseFromResultObject(resultObject: AnyObject) throws -> AnyObject {
        return resultObject
    }
}

struct TestNotificationRequest: RequestType {
    typealias Response = Void

    let method: String
    let parameters: AnyObject?
}

struct TestParseErrorRequest: RequestType {
    struct ParseError: ErrorType {

    }

    typealias Response = AnyObject

    let method: String
    let parameters: AnyObject?

    func responseFromResultObject(resultObject: AnyObject) throws -> AnyObject {
        throw ParseError()
    }
}
