//
//  CallBatchFactoryTests.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/29.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import XCTest
import JSONRPCKit
import Dispatch

class CallBatchFactoryTests: XCTestCase {
    var callBatchFactory: CallBatchFactory!
    
    override func setUp() {
        super.setUp()

        callBatchFactory = CallBatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
    }

    func test1() {
        let request = TestRequest(method: "method", parameters: ["key": "value"])
        let batch = callBatchFactory.create(request)

        XCTAssertEqual(batch.call.id?.value as? Int, 1)
    }

    func test2() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let batch = callBatchFactory.create(request1, request2)

        XCTAssertEqual(batch.call1.id?.value as? Int, 1)
        XCTAssertEqual(batch.call2.id?.value as? Int, 2)
    }

    func test3() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let request3 = TestRequest(method: "method3", parameters: ["key3": "value3"])
        let batch = callBatchFactory.create(request1, request2, request3)

        XCTAssertEqual(batch.call1.id?.value as? Int, 1)
        XCTAssertEqual(batch.call2.id?.value as? Int, 2)
        XCTAssertEqual(batch.call3.id?.value as? Int, 3)
    }

    func testThreadSafety() {
        let operationQueue = NSOperationQueue()

        for _ in 1..<10000 {
            operationQueue.addOperationWithBlock {
                let request = TestRequest(method: "method", parameters: nil)
                self.callBatchFactory.create(request)
            }
        }

        operationQueue.waitUntilAllOperationsAreFinished()

        let nextId = callBatchFactory.idGenerator.next().value as? Int
        XCTAssertEqual(nextId, 10000)
    }
}
