//
//  BatchFactory.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/28.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import Foundation
import Dispatch

public final class BatchFactory {
    public let version: String
    public var idGenerator: IdGeneratorType

    private let semaphore = dispatch_semaphore_create(1)

    public init(version: String, idGenerator: IdGeneratorType) {
        self.version = version
        self.idGenerator = idGenerator
    }

    public func create<Request: RequestType>(request: Request) -> Batch<Request> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let batchElement = BatchElement(request: request, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return Batch(batchElement: batchElement)
    }

    public func create<Request1: RequestType, Request2: RequestType>(request1: Request1, _ request2: Request2) -> Batch2<Request1, Request2> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let batchElement1 = BatchElement(request: request1, version: version, id: idGenerator.next())
        let batchElement2 = BatchElement(request: request2, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return Batch2(batchElement1: batchElement1, batchElement2: batchElement2)
    }

    public func create<Request1: RequestType, Request2: RequestType, Request3: RequestType>(request1: Request1, _ request2: Request2, _ request3: Request3) -> Batch3<Request1, Request2, Request3> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let batchElement1 = BatchElement(request: request1, version: version, id: idGenerator.next())
        let batchElement2 = BatchElement(request: request2, version: version, id: idGenerator.next())
        let batchElement3 = BatchElement(request: request3, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return Batch3(batchElement1: batchElement1, batchElement2: batchElement2, batchElement3: batchElement3)
    }
}
