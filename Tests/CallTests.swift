//
//  CallTests.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/29.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import XCTest
import JSONRPCKit

class CallTests: XCTestCase {

    func testRequestObject() {
        let request = TestRequest(method: "method", parameters: ["key": "value"])
        let call = Call(request: request, version: "2.0", id: Id.Number(1))
        XCTAssertEqual(call.id, Id.Number(1))
        XCTAssertEqual(call.version, "2.0")

        let requestObject = call.body as? [String: AnyObject]
        XCTAssertEqual(requestObject?.keys.count, 4)
        XCTAssertEqual(requestObject?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject?["id"] as? Int, 1)
        XCTAssertEqual(requestObject?["method"] as? String, "method")

        let parameters = requestObject?["params"] as? [String: AnyObject]
        XCTAssertEqual(parameters?.keys.count, 1)
        XCTAssertEqual(parameters?["key"] as? String, "value")
    }

    func testNotificationRequestObject() {
        let request = TestNotificationRequest(method: "method", parameters: ["key": "value"])
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        XCTAssertNil(call.id)
        XCTAssertEqual(call.version, "2.0")

        let requestObject = call.body as? [String: AnyObject]
        XCTAssertEqual(requestObject?.keys.count, 3)
        XCTAssertEqual(requestObject?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject?["method"] as? String, "method")
        XCTAssertNil(requestObject?["id"])

        let parameters = requestObject?["params"] as? [String: AnyObject]
        XCTAssertEqual(parameters?.keys.count, 1)
        XCTAssertEqual(parameters?["key"] as? String, "value")
    }

    func testResponseFromObject() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseObject: AnyObject = [
            "id": 1,
            "jsonrpc": "2.0",
            "result": [
                "key": "value",
            ]
        ]

        let response = try? call.responseFromObject(responseObject)
        XCTAssertEqual(response?["key"], "value")
    }

    func testResponseFromArray() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseArray: [AnyObject] = [
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
            ]
        ]

        let response = try? call.responseFromArray(responseArray)
        XCTAssertEqual(response?["key1"], "value1")
    }

    func testResponseFromObjectResponseError() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseObject: AnyObject = [
            "id": 1,
            "jsonrpc": "2.0",
            "error": [
                "code": 123,
                "message": "abc",
                "data": [
                    "key": "value",
                ]
            ]
        ]

        do {
            try call.responseFromObject(responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .ResponseError(let code, let message, let data as [String: AnyObject])? = error {
                XCTAssertEqual(code, 123)
                XCTAssertEqual(message, "abc")
                XCTAssertEqual(data["key"] as? String, "value")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayResponseError() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseArray: [AnyObject] = [
            [
                "id": 1,
                "jsonrpc": "2.0",
                "error": [
                    "code": 123,
                    "message": "abc",
                    "data": [
                        "key": "value",
                    ]
                ]
            ],
            [
                "id": 2,
                "jsonrpc": "2.0",
                "result": [:],
            ]
        ]

        do {
            try call.responseFromArray(responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .ResponseError(let code, let message, let data as [String: AnyObject])? = error {
                XCTAssertEqual(code, 123)
                XCTAssertEqual(message, "abc")
                XCTAssertEqual(data["key"] as? String, "value")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectResultObjectParseError() {
        let request = TestParseErrorRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseObject: AnyObject = [
            "id": 1,
            "jsonrpc": "2.0",
            "result": [:],
        ]

        do {
            try call.responseFromObject(responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .ResultObjectParseError(let error)? = error {
                XCTAssert(error is TestParseErrorRequest.ParseError)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayResultObjectParseError() {
        let request = TestParseErrorRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseArray: [AnyObject] = [
            [
                "id": 1,
                "jsonrpc": "2.0",
                "result": [:]
            ],
            [
                "id": 2,
                "jsonrpc": "2.0",
                "result": [:],
            ]
        ]

        do {
            try call.responseFromArray(responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .ResultObjectParseError(let error)? = error {
                XCTAssert(error is TestParseErrorRequest.ParseError)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectErrorObjectParseError() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseObject: AnyObject = [
            "id": 1,
            "jsonrpc": "2.0",
            "error": [
                "message": "abc",
            ]
        ]

        do {
            try call.responseFromObject(responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .ErrorObjectParseError? = error {

            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayErrorObjectParseError() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseArray: [AnyObject] = [
            [
                "id": 1,
                "jsonrpc": "2.0",
                "error": [
                    "message": "abc",
                ]
            ],
            [
                "id": 2,
                "jsonrpc": "2.0",
                "result": [:],
            ]
        ]

        do {
            try call.responseFromArray(responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .ErrorObjectParseError? = error {

            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectUnsupportedVersion() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseObject: AnyObject = [
            "id": 1,
            "jsonrpc": "1.0",
            "result": [
                "key": "value",
            ]
        ]

        do {
            try call.responseFromObject(responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .UnsupportedVersion(let version)? = error {
                XCTAssertEqual(version, "1.0")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayUnsupportedVersion() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseArray: [AnyObject] = [
            [
                "id": 1,
                "jsonrpc": "1.0",
                "result": [:],
            ],
            [
                "id": 2,
                "jsonrpc": "2.0",
                "result": [:],
            ]
        ]

        do {
            try call.responseFromArray(responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .UnsupportedVersion(let version)? = error {
                XCTAssertEqual(version, "1.0")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectResponseNotFound() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseObject: AnyObject = [
            "id": 2,
            "jsonrpc": "2.0",
            "result": [:]
        ]

        do {
            try call.responseFromObject(responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .ResponseNotFound(let id, let object as [String: AnyObject])? = error {
                XCTAssertEqual(id, call.id)
                XCTAssertEqual(object["id"] as? Int, 2)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayResponseNotFound() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseArray: [AnyObject] = [
            [
                "id": 2,
                "jsonrpc": "2.0",
                "result": [:],
            ],
            [
                "id": 3,
                "jsonrpc": "2.0",
                "result": [:],
            ]
        ]

        do {
            try call.responseFromArray(responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .ResponseNotFound(let id, let object as [[String: AnyObject]])? = error {
                XCTAssertEqual(id, call.id)
                XCTAssertEqual(object[0]["id"] as? Int, 2)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectMissingBothResultAndError() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseObject: AnyObject = [
            "id": 1,
            "jsonrpc": "2.0",
        ]

        do {
            try call.responseFromObject(responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .MissingBothResultAndError? = error {

            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayMissingBothResultAndError() {
        let request = TestRequest(method: "method", parameters: nil)
        let call = Call(request: request, version: "2.0", id: Id.Number(1))

        let responseArray: [AnyObject] = [
            [
                "id": 1,
                "jsonrpc": "2.0",
            ],
            [
                "id": 2,
                "jsonrpc": "2.0",
                "result": [:],
            ]
        ]

        do {
            try call.responseFromArray(responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .MissingBothResultAndError? = error {

            } else {
                XCTFail()
            }
        }
    }

}
