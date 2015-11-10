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
    
    private var requests: [[String: AnyObject]] = []
    private var handlers: [String: ([String: AnyObject]) -> Void] = [:]

    public init() {
    }
    
    public func addRequest<T: RequestType>(request: T, handler: (Result<T.Response, JSONRPCError>) -> Void) {
        let id = NSUUID().UUIDString
        
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
    
    private func buildJSONFromRequest<T: RequestType>(request: T, id: String? = nil) -> [String: AnyObject] {
        var json: [String: AnyObject] = [:]
        
        json["jsonrpc"] = self.version
        
        json["method"] = request.method
        
        if let params = request.params {
            json["params"] = params
        }
        
        if let id = id {
            json["id"] = id
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
        
        if let id = json["id"] as? String, handle = self.handlers[id] {
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
