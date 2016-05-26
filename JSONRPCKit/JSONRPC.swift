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

    public func addRequest<T: RequestType>(request: T, queue: dispatch_queue_t? = dispatch_get_main_queue(), handler: (Result<T.Response, JSONRPCError>) -> Void) {
        let identifier = identifierGenerator.next()
        
        requests.append(buildJSONFromRequest(request, identifier: identifier))
        
        handlers[identifier] = { (json: [String: AnyObject]) -> Void in
            func executeHandler(result: Result<T.Response, JSONRPCError>) {
                if let queue = queue {
                    dispatch_async(queue) {
                        handler(result)
                    }
                } else {
                    handler(result)
                }
            }
            
            if let result = json["result"] {
                guard let response = request.responseFromObject(result) else {
                    executeHandler(.Failure(.InvalidResult(result)))
                    return
                }
                
                executeHandler(.Success(response))
                return
            }
            
            if let error = json["error"] as? [String: AnyObject] {
                guard let code = error["code"] as? Int, message = error["message"] as? String else {
                    executeHandler(.Failure(.InvalidResponse(json)))
                    return
                }
                
                executeHandler(.Failure(.RequestError(code, message, error["data"])))
                return
            }
            
            executeHandler(.Failure(.InvalidResponse(json)))
        }
    }
    
    public func addNotification<T: RequestType>(request: T) {
        requests.append(buildJSONFromRequest(request))
    }
    
    private func buildJSONFromRequest<T: RequestType>(request: T, identifier: RequestIdentifier? = nil) -> [String: AnyObject] {
        var json: [String: AnyObject] = request.buildJSON()
        
        json["jsonrpc"] = version
        
        if let identifier = identifier {
            json["id"] = identifier.value
        }
        
        return json
    }
    
    public func buildRequestJSON() throws -> AnyObject {
        guard requests.count > 0 else {
            throw JSONRPCError.NoRequest
        }
        
        let json: AnyObject = (requests.count == 1) ? requests[0] : requests
        
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
        
        if let identifier = json["id"].flatMap(RequestIdentifier.init) {
            handlers[identifier]?(json)
        }
    }
    
    public func parseResponseJSON(json: AnyObject) throws {
        switch json {
        case let response as [String: AnyObject]:
            try handleResponse(response)

        case let responses as [[String: AnyObject]]:
            for response in responses {
                try handleResponse(response)
            }
            
        default:
            throw JSONRPCError.InvalidResponse(json)
        }
    }
}
