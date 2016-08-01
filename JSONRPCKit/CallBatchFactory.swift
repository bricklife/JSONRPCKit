//
//  CallBatchFactory.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/28.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Dispatch

public final class CallBatchFactory {
    public let version: String
    public var idGenerator: IdGeneratorType

    private let semaphore = dispatch_semaphore_create(1)

    public init(version: String, idGenerator: IdGeneratorType) {
        self.version = version
        self.idGenerator = idGenerator
    }

    public func create<Request: RequestType>(request: Request) -> CallBatch1<Request> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let call = Call(request: request, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return CallBatch1(call: call)
    }

    public func create<Request1: RequestType, Request2: RequestType>(request1: Request1, _ request2: Request2) -> CallBatch2<Request1, Request2> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let call1 = Call(request: request1, version: version, id: idGenerator.next())
        let call2 = Call(request: request2, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return CallBatch2(call1: call1, call2: call2)
    }

    public func create<Request1: RequestType, Request2: RequestType, Request3: RequestType>(request1: Request1, _ request2: Request2, _ request3: Request3) -> CallBatch3<Request1, Request2, Request3> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let call1 = Call(request: request1, version: version, id: idGenerator.next())
        let call2 = Call(request: request2, version: version, id: idGenerator.next())
        let call3 = Call(request: request3, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return CallBatch3(call1: call1, call2: call2, call3: call3)
    }
}
