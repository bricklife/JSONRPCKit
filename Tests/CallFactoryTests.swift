//
//  CallFactoryTests.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/29.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import XCTest
import JSONRPCKit
import Dispatch

class CallFactoryTests: XCTestCase {
    var callFactory: CallFactory!
    
    override func setUp() {
        super.setUp()

        callFactory = CallFactory(version: "2.0", idGenerator: NumberIdGenerator())
    }

    func test1() {
        let request = TestRequest(method: "method", parameters: ["key": "value"])
        let call = callFactory.create(request)

        XCTAssertEqual(call.element.id?.value as? Int, 1)
    }

    func test2() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let call = callFactory.create(request1, request2)

        XCTAssertEqual(call.element1.id?.value as? Int, 1)
        XCTAssertEqual(call.element2.id?.value as? Int, 2)
    }

    func test3() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let request3 = TestRequest(method: "method3", parameters: ["key3": "value3"])
        let call = callFactory.create(request1, request2, request3)

        XCTAssertEqual(call.element1.id?.value as? Int, 1)
        XCTAssertEqual(call.element2.id?.value as? Int, 2)
        XCTAssertEqual(call.element3.id?.value as? Int, 3)
    }

    func testThreadSafety() {
        let operationQueue = NSOperationQueue()

        for _ in 1..<10000 {
            operationQueue.addOperationWithBlock {
                let request = TestRequest(method: "method", parameters: nil)
                self.callFactory.create(request)
            }
        }

        operationQueue.waitUntilAllOperationsAreFinished()

        let nextId = callFactory.idGenerator.next().value as? Int
        XCTAssertEqual(nextId, 10000)
    }
}
