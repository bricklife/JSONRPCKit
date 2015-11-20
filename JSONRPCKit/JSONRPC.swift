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
        let identifier = self.identifierGenerator.next()
        
        self.requests.append(self.buildJSONFromRequest(request, identifier: identifier))
        
        self.handlers[identifier] = { (json: [String: AnyObject]) -> Void in
            if let result = json["result"] {
                guard let response = request.responseFromObject(result) else {
                    handler(.Failure(.InvalidResult(result)))
                    return
                }
                
                handler(.Success(response))
                return
            }
            
            if let error = json["error"] as? [String: AnyObject] {
                guard let code = error["code"] as? Int, message = error["message"] as? String else {
                    handler(.Failure(.InvalidResponse(json)))
                    return
                }
                
                handler(.Failure(.RequestError(code, message, error["data"])))
                return
            }
            
            handler(.Failure(.InvalidResponse(json)))
        }
    }
    
    public func addNotification<T: RequestType>(request: T) {
        self.requests.append(self.buildJSONFromRequest(request))
    }
    
    private func buildJSONFromRequest<T: RequestType>(request: T, identifier: RequestIdentifier? = nil) -> [String: AnyObject] {
        var json: [String: AnyObject] = request.buildJSON()
        
        json["jsonrpc"] = self.version
        
        if let identifier = identifier {
            json["id"] = identifier.value
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
        
        guard let id = json["id"] else {
            return
        }
        
        if let identifier = RequestIdentifier(value: id), handle = self.handlers[identifier] {
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
