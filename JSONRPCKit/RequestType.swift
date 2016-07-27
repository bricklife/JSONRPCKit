//
//  RequestType.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation

public protocol RequestType {
    associatedtype Response
    
    var method: String { get }
    var parameters: AnyObject? { get }
    
    func responseFromResultObject(resultObject: AnyObject) throws -> Response
}
