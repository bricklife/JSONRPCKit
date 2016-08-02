//
//  RequestType.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol RequestType {
    /// If `Response == Void`, request is treated as a notification.
    associatedtype Response
    
    var method: String { get }
    var parameters: AnyObject? { get }
    var isNotification: Bool { get }
    
    func responseFromResultObject(resultObject: AnyObject) throws -> Response
}

public extension RequestType {
    public var parameters: AnyObject? {
        return nil
    }

    public var isNotification: Bool {
        return false
    }
}

public extension RequestType where Response == Void {
    public var isNotification: Bool {
        return true
    }

    public func responseFromResultObject(resultObject: AnyObject) throws -> Response {
        return ()
    }
}
