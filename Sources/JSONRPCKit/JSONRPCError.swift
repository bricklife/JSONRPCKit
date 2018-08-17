//
//  JSONRPCError.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

/// Errors that the JSONRPCKit throws
///
/// - responseError: Response had an error message with it. Data is a Decoder. Use singleValueContainer() to decode it if you want.
/// - responseNotFound: Response was not found
/// - responseParseError: Response could not be parsed. Decoding error is contained
/// - resultObjectParseError: Result object could not be parsed.
/// - errorObjectParseError: Error object could not be parsed.
/// - unsupportedVersion: Version is unsupported
/// - missingBothResultAndError: Result and Error are missing.
public enum JSONRPCError: Error {
    case responseError(code: Int, message: String, data: Decoder)
    case responseNotFound(requestId: Id?)
    case responseParseError(Error)
    case resultObjectParseError(Error)
    case errorObjectParseError(Error)
    case unsupportedVersion(String?)
    case missingBothResultAndError
}


