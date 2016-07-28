//
//  RequestTests.swift
//  RequestTests
//
//  Created by ishkawa on 2016/07/28.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import XCTest
import JSONRPCKit

class RequestTests: XCTestCase {

    var callFactory: CallFactory!
    
    override func setUp() {
        super.setUp()

        callFactory = CallFactory(version: "2.0", idGenerator: NumberIdGenerator())
    }

    func testRequest1() {
        let request = TestRequest(method: "method", parameters: ["key": "value"])
        let call = callFactory.create(request)

        XCTAssertEqual(call.element.id?.value as? Int, 1)
        XCTAssertEqual(call.element.version, "2.0")

        let requestObject = call.element.body as? [String: AnyObject]
        XCTAssertEqual(requestObject?.keys.count, 4)
        XCTAssertEqual(requestObject?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject?["id"] as? Int, 1)
        XCTAssertEqual(requestObject?["method"] as? String, "method")

        let parameters = requestObject?["params"] as? [String: AnyObject]
        XCTAssertEqual(parameters?.keys.count, 1)
        XCTAssertEqual(parameters?["key"] as? String, "value")
    }

    func testRequest2() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let call = callFactory.create(request1, request2)

        XCTAssertEqual(call.element1.id?.value as? Int, 1)
        XCTAssertEqual(call.element2.id?.value as? Int, 2)
        XCTAssertEqual(call.element1.version, "2.0")
        XCTAssertEqual(call.element2.version, "2.0")

        let requestObject1 = call.element1.body as? [String: AnyObject]
        let requestObject2 = call.element2.body as? [String: AnyObject]
        XCTAssertEqual(requestObject1?.keys.count, 4)
        XCTAssertEqual(requestObject2?.keys.count, 4)
        XCTAssertEqual(requestObject1?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject2?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject1?["id"] as? Int, 1)
        XCTAssertEqual(requestObject2?["id"] as? Int, 2)
        XCTAssertEqual(requestObject1?["method"] as? String, "method1")
        XCTAssertEqual(requestObject2?["method"] as? String, "method2")

        let parameters1 = requestObject1?["params"] as? [String: AnyObject]
        let parameters2 = requestObject2?["params"] as? [String: AnyObject]
        XCTAssertEqual(parameters1?.keys.count, 1)
        XCTAssertEqual(parameters2?.keys.count, 1)
        XCTAssertEqual(parameters1?["key1"] as? String, "value1")
        XCTAssertEqual(parameters2?["key2"] as? String, "value2")
    }

    func testRequest3() {
        let request1 = TestRequest(method: "method1", parameters: ["key1": "value1"])
        let request2 = TestRequest(method: "method2", parameters: ["key2": "value2"])
        let request3 = TestRequest(method: "method3", parameters: ["key3": "value3"])
        let call = callFactory.create(request1, request2, request3)

        XCTAssertEqual(call.element1.id?.value as? Int, 1)
        XCTAssertEqual(call.element2.id?.value as? Int, 2)
        XCTAssertEqual(call.element3.id?.value as? Int, 3)
        XCTAssertEqual(call.element1.version, "2.0")
        XCTAssertEqual(call.element2.version, "2.0")
        XCTAssertEqual(call.element3.version, "2.0")

        let requestObject1 = call.element1.body as? [String: AnyObject]
        let requestObject2 = call.element2.body as? [String: AnyObject]
        let requestObject3 = call.element3.body as? [String: AnyObject]
        XCTAssertEqual(requestObject1?.keys.count, 4)
        XCTAssertEqual(requestObject2?.keys.count, 4)
        XCTAssertEqual(requestObject3?.keys.count, 4)
        XCTAssertEqual(requestObject1?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject2?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject3?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject1?["id"] as? Int, 1)
        XCTAssertEqual(requestObject2?["id"] as? Int, 2)
        XCTAssertEqual(requestObject3?["id"] as? Int, 3)
        XCTAssertEqual(requestObject1?["method"] as? String, "method1")
        XCTAssertEqual(requestObject2?["method"] as? String, "method2")
        XCTAssertEqual(requestObject3?["method"] as? String, "method3")

        let parameters1 = requestObject1?["params"] as? [String: AnyObject]
        let parameters2 = requestObject2?["params"] as? [String: AnyObject]
        let parameters3 = requestObject3?["params"] as? [String: AnyObject]
        XCTAssertEqual(parameters1?.keys.count, 1)
        XCTAssertEqual(parameters2?.keys.count, 1)
        XCTAssertEqual(parameters3?.keys.count, 1)
        XCTAssertEqual(parameters1?["key1"] as? String, "value1")
        XCTAssertEqual(parameters2?["key2"] as? String, "value2")
        XCTAssertEqual(parameters3?["key3"] as? String, "value3")
    }

    func testNotificationRequest() {
        let request = TestNotificationRequest(method: "method", parameters: ["key": "value"])
        let call = callFactory.create(request)

        XCTAssertNil(call.element.id)
        XCTAssertEqual(call.element.version, "2.0")

        let requestObject = call.element.body as? [String: AnyObject]
        XCTAssertEqual(requestObject?.keys.count, 3)
        XCTAssertEqual(requestObject?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject?["method"] as? String, "method")
        XCTAssertNil(requestObject?["id"])

        let parameters = requestObject?["params"] as? [String: AnyObject]
        XCTAssertEqual(parameters?.keys.count, 1)
        XCTAssertEqual(parameters?["key"] as? String, "value")
    }
}
