//
//  JSONRPC.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/09.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Result

public class JSONRPC {
    
    public let version = "2.0"
    
    private let identifierGenerator: RequestIdentifierGenerator
    
    private var requests: [[String: AnyObject]] = []
    private var handlers: [RequestIdentifier: ([String: AnyObject]) -> Void] = [:]
        
    public init(identifierGenerator: RequestIdentifierGenerator) {
        self.identifierGenerator = identifierGenerator
    }
    
    public convenience init() {
        self.init(identifierGenerator: NumberIdentifierGenerator())
    }

    public func addRequest<T: RequestType>(request: T, handler: (Result<T.Response, JSONRPCError>) -> Void) {
        let id = self.identifierGenerator.next()
        
        self.requests.append(self.buildJSONFromRequest(request, id: id))
        
        self.handlers[id] = { (json: [String: AnyObject]) -> Void in
            if let result = json["result"] {
                if let response = request.responseFromObject(result) {
                    handler(.Success(response))
                } else {
                    handler(.Failure(JSONRPCError.InvalidResult(result)))
                }
            } else if let error = json["error"] {
                handler(.Failure(JSONRPCError.ErrorRequest(error)))
            } else {
                handler(.Failure(JSONRPCError.InvalidResponse(json)))
            }
        }
    }
    
    public func addNotification<T: RequestType>(request: T) {
        self.requests.append(self.buildJSONFromRequest(request))
    }
    
    private func buildJSONFromRequest<T: RequestType>(request: T, id: RequestIdentifier? = nil) -> [String: AnyObject] {
        var json: [String: AnyObject] = request.buildJSON()
        
        json["jsonrpc"] = self.version
        
        if let id = id {
            switch id {
            case .StringType(let string):
                json["id"] = string
            case .NumberType(let number):
                json["id"] = number
            }
        }
        
        return json
    }
    
    public func buildRequestJSON() throws -> AnyObject {
        guard self.requests.count > 0 else {
            throw JSONRPCError.NoRequest
        }
        
        let json: AnyObject = (self.requests.count == 1) ? self.requests[0] : self.requests
        
        guard NSJSONSerialization.isValidJSONObject(json) else {
            throw JSONRPCError.InvalidRequest(json)
        }
        
        return json
    }
    
    private func handleResponse(json: [String: AnyObject]) throws {
        guard let version = json["jsonrpc"] as? String else {
            throw JSONRPCError.InvalidResponse(json)
        }
        
        guard version == self.version else {
            throw JSONRPCError.UnsupportedVersion(version)
        }
        
        if let id = json["id"] as? String, handle = self.handlers[.StringType(id)] {
            handle(json)
        }
        if let id = json["id"] as? Int, handle = self.handlers[.NumberType(id)] {
            handle(json)
        }
    }
    
    public func parseResponseJSON(json: AnyObject) throws {
        switch json {
        case let response as [String: AnyObject]:
            try self.handleResponse(response)

        case let responses as [[String: AnyObject]]:
            for response in responses {
                try self.handleResponse(response)
            }
            
        default:
            throw JSONRPCError.InvalidResponse(json)
        }
    }
}
