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

    public init(version: String = "2.0", idGenerator: IdGeneratorType = NumberIdGenerator()) {
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
    
    public func create<Request1: RequestType, Request2: RequestType, Request3: RequestType, Request4: RequestType>(request1: Request1, _ request2: Request2, _ request3: Request3, _ request4: Request4) -> Batch4<Request1, Request2, Request3, Request4> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let batchElement1 = BatchElement(request: request1, version: version, id: idGenerator.next())
        let batchElement2 = BatchElement(request: request2, version: version, id: idGenerator.next())
        let batchElement3 = BatchElement(request: request3, version: version, id: idGenerator.next())
        let batchElement4 = BatchElement(request: request4, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return Batch4(batchElement1: batchElement1, batchElement2: batchElement2, batchElement3: batchElement3, batchElement4: batchElement4)
    }
    
    public func create<Request1: RequestType, Request2: RequestType, Request3: RequestType, Request4: RequestType, Request5: RequestType>(request1: Request1, _ request2: Request2, _ request3: Request3, _ request4: Request4, _ request5: Request5) -> Batch5<Request1, Request2, Request3, Request4, Request5> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let batchElement1 = BatchElement(request: request1, version: version, id: idGenerator.next())
        let batchElement2 = BatchElement(request: request2, version: version, id: idGenerator.next())
        let batchElement3 = BatchElement(request: request3, version: version, id: idGenerator.next())
        let batchElement4 = BatchElement(request: request4, version: version, id: idGenerator.next())
        let batchElement5 = BatchElement(request: request5, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return Batch5(batchElement1: batchElement1, batchElement2: batchElement2, batchElement3: batchElement3, batchElement4: batchElement4, batchElement5: batchElement5)
    }
    
    public func create<Request1: RequestType, Request2: RequestType, Request3: RequestType, Request4: RequestType, Request5: RequestType, Request6: RequestType>(request1: Request1, _ request2: Request2, _ request3: Request3, _ request4: Request4, _ request5: Request5, _ request6: Request6) -> Batch6<Request1, Request2, Request3, Request4, Request5, Request6> {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        let batchElement1 = BatchElement(request: request1, version: version, id: idGenerator.next())
        let batchElement2 = BatchElement(request: request2, version: version, id: idGenerator.next())
        let batchElement3 = BatchElement(request: request3, version: version, id: idGenerator.next())
        let batchElement4 = BatchElement(request: request4, version: version, id: idGenerator.next())
        let batchElement5 = BatchElement(request: request5, version: version, id: idGenerator.next())
        let batchElement6 = BatchElement(request: request6, version: version, id: idGenerator.next())
        dispatch_semaphore_signal(semaphore)

        return Batch6(batchElement1: batchElement1, batchElement2: batchElement2, batchElement3: batchElement3, batchElement4: batchElement4, batchElement5: batchElement5, batchElement6: batchElement6)
    }
}
