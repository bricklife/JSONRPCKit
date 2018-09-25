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

private struct TestRequest: Request {
    typealias Response = Int

    var method: String
    var parameters: Encodable?

    init(method: String, parameters: Encodable?) {
        self.method = method
        self.parameters = parameters
    }

}

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

    func testEncode1() {
        let request = TestRequest(method: "method", parameters: ["key": "value"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])

        let batch = batchFactory.create(request, request2)

        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(batch) else {
            XCTFail()
            return
        }
        let jsonString = String(data: data, encoding: .utf8)

        XCTAssertTrue(jsonString?.contains("\"id\":1") ?? false)
        XCTAssertTrue(jsonString?.contains("\"jsonrpc\":\"2.0\"") ?? false)
        XCTAssertTrue(jsonString?.contains("\"method\":\"method\"") ?? false)
        XCTAssertTrue(jsonString?.contains("\"params\":{\"key\":\"value\"}") ?? false)
        XCTAssertTrue(jsonString?.contains("\"id\":2") ?? false)
        XCTAssertTrue(jsonString?.contains("\"method\":\"method2\"") ?? false)
        XCTAssertTrue(jsonString?.contains("\"params\":{\"key2\":\"value2\"}") ?? false)
    }

    func testEncode2() {
        let request = TestRequest(method: "method", parameters: ["key": "value"])
        let batch = batchFactory.create(request)

        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(batch) else {
            XCTFail()
            return
        }
        let jsonString = String(data: data, encoding: .utf8)
        XCTAssertTrue(jsonString?.contains("\"id\":1") ?? false)
        XCTAssertTrue(jsonString?.contains("\"jsonrpc\":\"2.0\"") ?? false)
        XCTAssertTrue(jsonString?.contains("\"method\":\"method\"") ?? false)
        XCTAssertTrue(jsonString?.contains("\"params\":{\"key\":\"value\"}") ?? false)
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

    func test5Response() {
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

        let responseArray =
        """
        [
            {
                "id": 2,
                "jsonrpc": "2.0",
                "result": 2,
            },
            {
                "id": 3,
                "jsonrpc": "2.0",
                "result": 3,
            },
            {
                "id": 1,
                "jsonrpc": "2.0",
                "result": 1,
            },
            {
                "id": 5,
                "jsonrpc": "2.0",
                "result": 5,
            },
            {
                "id": 4,
                "jsonrpc": "2.0",
                "result": 4,
            }
        ]
        """
        let responses = try? batch.responses(from: responseArray.data(using: .utf8)!)

        XCTAssertEqual(responses?.0, 1)
        XCTAssertEqual(responses?.1, 2)
        XCTAssertEqual(responses?.2, 3)
        XCTAssertEqual(responses?.3, 4)
        XCTAssertEqual(responses?.4, 5)
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
        ("testEncode1", testEncode1),
        ("testEncode2", testEncode2),
        ("test2", test2),
        ("test3", test3),
        ("test4", test4),
        ("test5", test5),
        ("test5Response", test5Response),
        ("testThreadSafety", testThreadSafety),
    ]
}
