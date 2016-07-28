//
//  ResponseTests.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/28.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import XCTest
import JSONRPCKit

class ResponseTests: XCTestCase {

    var callFactory: CallFactory!
    
    override func setUp() {
        super.setUp()

        callFactory = CallFactory(version: "2.0", idGenerator: NumberIdGenerator())
    }

    func testResponse1() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = callFactory.create(request)

        let responseObject: AnyObject = [
            "id": 1,
            "jsonrpc": "2.0",
            "result": [
                "key": "value",
            ]
        ]

        do {
            let response = try call.parseResponseObject(responseObject)
            XCTAssertEqual(response["key"], "value")
        } catch {
            XCTFail()
        }
    }

    func testResponse2() {
        let request1 = TestRequest(method: "method1", parameters: nil)
        let request2 = TestRequest(method: "method2", parameters: nil)
        let call = callFactory.create(request1, request2)

        let responseObject: AnyObject = [
            [
                "id": 1,
                "jsonrpc": "2.0",
                "result": [
                    "key1": "value1",
                ]
            ],
            [
                "id": 2,
                "jsonrpc": "2.0",
                "result": [
                    "key2": "value2",
                ]
            ],
        ]

        do {
            let (response1, response2) = try call.parseResponseObject(responseObject)
            XCTAssertEqual(response1["key1"], "value1")
            XCTAssertEqual(response2["key2"], "value2")
        } catch {
            XCTFail()
        }
    }

    func testResponse3() {
        let request1 = TestRequest(method: "method1", parameters: nil)
        let request2 = TestRequest(method: "method2", parameters: nil)
        let request3 = TestRequest(method: "method3", parameters: nil)
        let call = callFactory.create(request1, request2, request3)

        let responseObject: AnyObject = [
            [
                "id": 1,
                "jsonrpc": "2.0",
                "result": [
                    "key1": "value1",
                ]
            ],
            [
                "id": 2,
                "jsonrpc": "2.0",
                "result": [
                    "key2": "value2",
                ]
            ],
            [
                "id": 3,
                "jsonrpc": "2.0",
                "result": [
                    "key3": "value3",
                ]
            ],
        ]

        do {
            let (response1, response2, response3) = try call.parseResponseObject(responseObject)
            XCTAssertEqual(response1["key1"], "value1")
            XCTAssertEqual(response2["key2"], "value2")
            XCTAssertEqual(response3["key3"], "value3")
        } catch {
            XCTFail()
        }
    }
}