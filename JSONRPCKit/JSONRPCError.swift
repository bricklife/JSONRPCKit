//
//  JSONRPCError.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public enum JSONRPCError: ErrorType {
    case NoRequest
    case InvalidRequest(AnyObject)
    case InvalidResponse(AnyObject)
    case InvalidResult(AnyObject)
    case UnsupportedVersion(String)
    case ErrorRequest(AnyObject)
}
