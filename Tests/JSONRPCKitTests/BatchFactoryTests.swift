//
//  BatchFactoryTests.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/29.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import XCTest
import JSONRPCKit
import Dispatch

class BatchFactoryTests: XCTestCase {
    var batchFactory: BatchFactory!
    
    override func setUp() {
        super.setUp()

        batchFactory = BatchFactory()
    }

    func test1() {
        let request = TestRequest(method: "method", parameters: ["key": "value"])
        let batch = batchFactory.create(request)

        XCTAssertEqual(batch.batchElement.id?.value as? Int, 1)
    }

    func test2() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let batch = batchFactory.create(request1, request2)

        XCTAssertEqual(batch.batchElement1.id?.value as? Int, 1)
        XCTAssertEqual(batch.batchElement2.id?.value as? Int, 2)
    }

    func test3() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let request3 = TestRequest(method: "method3", parameters: ["key3": "value3"])
        let batch = batchFactory.create(request1, request2, request3)

        XCTAssertEqual(batch.batchElement1.id?.value as? Int, 1)
        XCTAssertEqual(batch.batchElement2.id?.value as? Int, 2)
        XCTAssertEqual(batch.batchElement3.id?.value as? Int, 3)
    }

    func test4() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let request3 = TestRequest(method: "method3", parameters: ["key3": "value3"])
        let request4 = TestRequest(method: "method4", parameters: ["key4": "value4"])
        let batch = batchFactory.create(request1, request2, request3, request4)

        XCTAssertEqual(batch.batchElement1.id?.value as? Int, 1)
        XCTAssertEqual(batch.batchElement2.id?.value as? Int, 2)
        XCTAssertEqual(batch.batchElement3.id?.value as? Int, 3)
        XCTAssertEqual(batch.batchElement4.id?.value as? Int, 4)
    }

    func test5() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let request3 = TestRequest(method: "method3", parameters: ["key3": "value3"])
        let request4 = TestRequest(method: "method4", parameters: ["key4": "value4"])
        let request5 = TestRequest(method: "method5", parameters: ["key5": "value5"])
        let batch = batchFactory.create(request1, request2, request3, request4, request5)

        XCTAssertEqual(batch.batchElement1.id?.value as? Int, 1)
        XCTAssertEqual(batch.batchElement2.id?.value as? Int, 2)
        XCTAssertEqual(batch.batchElement3.id?.value as? Int, 3)
        XCTAssertEqual(batch.batchElement4.id?.value as? Int, 4)
        XCTAssertEqual(batch.batchElement5.id?.value as? Int, 5)
    }

    func testThreadSafety() {
        let operationQueue = OperationQueue()

        for _ in 1..<10000 {
            operationQueue.addOperation {
                let request = TestRequest(method: "method", parameters: nil)
                _ = self.batchFactory.create(request)
            }
        }

        operationQueue.waitUntilAllOperationsAreFinished()

        let nextId = batchFactory.idGenerator.next().value as? Int
        XCTAssertEqual(nextId, 10000)
    }

    static var allTests = [
        ("test1", test1),
        ("test2", test2),
        ("test3", test3),
        ("test4", test4),
        ("test5", test5),
        ("testThreadSafety", testThreadSafety),
    ]
}
