//
//  Request.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol Request {
    /// If `Response == Void`, request is treated as a notification.
    associatedtype Response
    
    var method: String { get }
    var parameters: Any? { get }
    var extendedFields: [String: Any]? { get }
    var isNotification: Bool { get }
    
    func response(from resultObject: Any) throws -> Response
}

public extension Request {
    var parameters: Any? {
        return nil
    }

    var extendedFields: [String: Any]? {
        return nil
    }

    var isNotification: Bool {
        return false
    }
}

public extension Request where Response == Void {
    var isNotification: Bool {
        return true
    }

    func response(from resultObject: Any) throws -> Response {
        return ()
    }
}
