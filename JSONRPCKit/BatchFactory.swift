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

    fileprivate let semaphore = DispatchSemaphore(value: 1)

    public init(version: String = "2.0", idGenerator: IdGeneratorType = NumberIdGenerator()) {
        self.version = version
        self.idGenerator = idGenerator
    }

    public func create<Request: JSONRPCKit.Request>(_ request: Request) -> Batch1<Request> {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let batchElement = BatchElement(request: request, version: version, id: idGenerator.next())
        semaphore.signal()

        return Batch1(batchElement: batchElement)
    }

    public func create<Request1: Request, Request2: Request>(_ request1: Request1, _ request2: Request2) -> Batch2<Request1, Request2> {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let batchElement1 = BatchElement(request: request1, version: version, id: idGenerator.next())
        let batchElement2 = BatchElement(request: request2, version: version, id: idGenerator.next())
        semaphore.signal()

        return Batch2(batchElement1: batchElement1, batchElement2: batchElement2)
    }

    public func create<Request1: Request, Request2: Request, Request3: Request>(_ request1: Request1, _ request2: Request2, _ request3: Request3) -> Batch3<Request1, Request2, Request3> {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let batchElement1 = BatchElement(request: request1, version: version, id: idGenerator.next())
        let batchElement2 = BatchElement(request: request2, version: version, id: idGenerator.next())
        let batchElement3 = BatchElement(request: request3, version: version, id: idGenerator.next())
        semaphore.signal()

        return Batch3(batchElement1: batchElement1, batchElement2: batchElement2, batchElement3: batchElement3)
    }
}
