//
//  BatchElementTests.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/29.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import XCTest
@testable import JSONRPCKit

class BatchElementTests: XCTestCase {

    func testRequestObject() {
        let request = TestRequest(method: "method", parameters: ["key": "value"], extendedFields: ["exkey": "exvalue"])
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))
        XCTAssertEqual(batchElement.id, Id.number(1))
        XCTAssertEqual(batchElement.version, "2.0")

        let requestObject = batchElement.body as? [String: Any]
        XCTAssertEqual(requestObject?.keys.count, 5)
        XCTAssertEqual(requestObject?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject?["id"] as? Int, 1)
        XCTAssertEqual(requestObject?["method"] as? String, "method")
        XCTAssertEqual(requestObject?["exkey"] as? String, "exvalue")

        let parameters = requestObject?["params"] as? [String: Any]
        XCTAssertEqual(parameters?.keys.count, 1)
        XCTAssertEqual(parameters?["key"] as? String, "value")
    }

    func testNotificationRequestObject() {
        let request = TestNotificationRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        XCTAssertNil(batchElement.id)
        XCTAssertEqual(batchElement.version, "2.0")

        let requestObject = batchElement.body as? [String: Any]
        XCTAssertEqual(requestObject?.keys.count, 2)
        XCTAssertEqual(requestObject?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject?["method"] as? String, "method")
        XCTAssertNil(requestObject?["id"])
        XCTAssertNil(requestObject?["params"])
    }

    func testResponseFromObject() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject: Any = [
            "id": 1,
            "jsonrpc": "2.0",
            "result": [
                "key": "value",
            ]
        ]

        let response = try? batchElement.response(from: responseObject)
        let dictionary = response as? [String: Any]
        XCTAssertEqual(dictionary?["key"] as? String, "value")
    }

    func testResponseFromArray() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray: [Any] = [
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

        let response = try? batchElement.response(from: responseArray)
        let dictionary = response as? [String: Any]
        XCTAssertEqual(dictionary?["key1"] as? String, "value1")
    }

    func testResponseFromObjectResponseError() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject: Any = [
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
            _ = try batchElement.response(from: responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .responseError(let code, let message, let data as [String: Any])? = error {
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
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray: [Any] = [
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
            _ = try batchElement.response(from: responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .responseError(let code, let message, let data as [String: Any])? = error {
                XCTAssertEqual(code, 123)
                XCTAssertEqual(message, "abc")
                XCTAssertEqual(data["key"] as? String, "value")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectresultObjectParseError() {
        let request = TestParseErrorRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject: Any = [
            "id": 1,
            "jsonrpc": "2.0",
            "result": [:],
        ]

        do {
            _ = try batchElement.response(from: responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .resultObjectParseError(let error)? = error {
                XCTAssert(error is TestParseErrorRequest.ParseError)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayresultObjectParseError() {
        let request = TestParseErrorRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray: [Any] = [
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
            _ = try batchElement.response(from: responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .resultObjectParseError(let error)? = error {
                XCTAssert(error is TestParseErrorRequest.ParseError)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectErrorObjectParseError() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject: Any = [
            "id": 1,
            "jsonrpc": "2.0",
            "error": [
                "message": "abc",
            ]
        ]

        do {
            _ = try batchElement.response(from: responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .errorObjectParseError? = error {

            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayErrorObjectParseError() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray: [Any] = [
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
            _ = try batchElement.response(from: responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .errorObjectParseError? = error {

            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectunsupportedVersion() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject: Any = [
            "id": 1,
            "jsonrpc": "1.0",
            "result": [
                "key": "value",
            ]
        ]

        do {
            _ = try batchElement.response(from: responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .unsupportedVersion(let version)? = error {
                XCTAssertEqual(version, "1.0")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayunsupportedVersion() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray: [Any] = [
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
            _ = try batchElement.response(from: responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .unsupportedVersion(let version)? = error {
                XCTAssertEqual(version, "1.0")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectresponseNotFound() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject: Any = [
            "id": 2,
            "jsonrpc": "2.0",
            "result": [:]
        ]

        do {
            _ = try batchElement.response(from: responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .responseNotFound(let id, let object as [String: Any])? = error {
                XCTAssertEqual(id, batchElement.id)
                XCTAssertEqual(object["id"] as? Int, 2)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayresponseNotFound() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray: [Any] = [
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
            _ = try batchElement.response(from: responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .responseNotFound(let id, let object as [[String: Any]])? = error {
                XCTAssertEqual(id, batchElement.id)
                XCTAssertEqual(object[0]["id"] as? Int, 2)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectmissingBothResultAndError() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject: Any = [
            "id": 1,
            "jsonrpc": "2.0",
        ]

        do {
            _ = try batchElement.response(from: responseObject)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .missingBothResultAndError? = error {

            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArraymissingBothResultAndError() {
        let request = TestRequest(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray: [Any] = [
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
            _ = try batchElement.response(from: responseArray)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .missingBothResultAndError? = error {

            } else {
                XCTFail()
            }
        }
    }

    static var allTests = [
        ("testRequestObject", testRequestObject),
        ("testNotificationRequestObject", testNotificationRequestObject),
        ("testResponseFromObject", testResponseFromObject),
        ("testResponseFromArray", testResponseFromArray),
        ("testResponseFromObjectResponseError", testResponseFromObjectResponseError),
        ("testResponseFromArrayResponseError", testResponseFromArrayResponseError),
        ("testResponseFromObjectresultObjectParseError", testResponseFromObjectresultObjectParseError),
        ("testResponseFromArrayresultObjectParseError", testResponseFromArrayresultObjectParseError),
        ("testResponseFromObjectErrorObjectParseError", testResponseFromObjectErrorObjectParseError),
        ("testResponseFromArrayErrorObjectParseError", testResponseFromArrayErrorObjectParseError),
        ("testResponseFromObjectunsupportedVersion", testResponseFromObjectunsupportedVersion),
        ("testResponseFromArrayunsupportedVersion", testResponseFromArrayunsupportedVersion),
        ("testResponseFromObjectresponseNotFound", testResponseFromObjectresponseNotFound),
        ("testResponseFromArrayresponseNotFound", testResponseFromArrayresponseNotFound),
        ("testResponseFromObjectmissingBothResultAndError", testResponseFromObjectmissingBothResultAndError),
        ("testResponseFromArraymissingBothResultAndError", testResponseFromArraymissingBothResultAndError),
    ]
}
