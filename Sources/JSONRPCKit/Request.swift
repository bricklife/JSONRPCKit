//
//  Request.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

/// An empty reply to signify notification.
/// Could be changed to Never in swift 4.2 when Never starts to conform to Codable
public struct NoReply: Decodable {}

public protocol Request {
    /// If `Response == NoReply`, request is treated as a notification.
    associatedtype Response: Decodable
    
    var method: String { get }
    var parameters: Encodable? { get }
    var extendedFields: Encodable? { get }
    var isNotification: Bool { get }
    
}

public extension Request {
    public var parameters: Any? {
        return nil
    }

    public var extendedFields: Encodable? {
        return nil
    }

    public var isNotification: Bool {
        return false
    }
}

public extension Request where Response == NoReply {
    public var isNotification: Bool {
        return true
    }
}
