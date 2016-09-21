//
//  JSONRPCError.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public enum JSONRPCError: ErrorType {
    case ResponseError(code: Int, message: String, data: AnyObject?)
    case ResponseNotFound(requestId: Id?, object: AnyObject)
    case ResultObjectParseError(ErrorType)
    case ErrorObjectParseError(ErrorType)
    case UnsupportedVersion(String?)
    case MissingBothResultAndError(AnyObject)
    case NonArrayResponse(AnyObject)

    public init(errorObject: AnyObject) {
        enum ParseError: ErrorType {
            case MissingKey(key: String, errorObject: AnyObject)
        }

        do {
            guard let code = errorObject["code"] as? Int else {
                throw ParseError.MissingKey(key: "code", errorObject: errorObject)
            }

            guard let message = errorObject["message"] as? String else {
                throw ParseError.MissingKey(key: "message", errorObject: errorObject)
            }

            self = .ResponseError(code: code, message: message, data: errorObject["data"])
        } catch {
            self = .ErrorObjectParseError(error)
        }
    }
}

