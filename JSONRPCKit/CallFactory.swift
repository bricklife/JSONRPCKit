//
//  CallFactory.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/28.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation

public final class CallFactory {
    public let version: String
    public var idGenerator: IdGeneratorType

    public init(version: String, idGenerator: IdGeneratorType) {
        self.version = version
        self.idGenerator = idGenerator
    }

    public func create<Request: RequestType>(request: Request) -> Call1<Request> {
        let element = CallElement(request: request, version: version, id: idGenerator.next())
        return Call1(element: element)
    }

    public func create<Request1: RequestType, Request2: RequestType>(request1: Request1, request2: Request2) -> Call2<Request1, Request2> {
        let element1 = CallElement(request: request1, version: version, id: idGenerator.next())
        let element2 = CallElement(request: request2, version: version, id: idGenerator.next())
        return Call2(element1: element1, element2: element2)
    }

    public func create<Request1: RequestType, Request2: RequestType, Request3: RequestType>(request1: Request1, request2: Request2, request3: Request3) -> Call3<Request1, Request2, Request3> {
        let element1 = CallElement(request: request1, version: version, id: idGenerator.next())
        let element2 = CallElement(request: request2, version: version, id: idGenerator.next())
        let element3 = CallElement(request: request3, version: version, id: idGenerator.next())
        return Call3(element1: element1, element2: element2, element3: element3)
    }
}
