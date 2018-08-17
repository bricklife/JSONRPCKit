//
//  BatchElementTests.swift
//  JSONRPCKit
//
//  Created by ishkawa on 2016/07/29.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import XCTest
@testable import JSONRPCKit

private struct TestRequest: Request {
    typealias Response = Int

    var method: String
    var parameters: Encodable?
    var extendedFields: Encodable?

    init(method: String, parameters: Encodable?, extendedFields: Encodable? = .none) {
        self.method = method
        self.parameters = parameters
        self.extendedFields = extendedFields
    }

}

class BatchElementTests: XCTestCase {

    func testRequestObject() {
        let request = TestRequest(method: "method", parameters: ["key": "value"], extendedFields: ["exkey": "exvalue"])
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))
        XCTAssertEqual(batchElement.id, Id.number(1))
        XCTAssertEqual(batchElement.version, "2.0")

        let encoder = JSONEncoder()
        let data = try! encoder.encode(batchElement)
        let requestObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] ?? [:]
        let theJSONText = String(data: data, encoding: .utf8)
        print(theJSONText ?? "")

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

        let encoder = JSONEncoder()
        let data = try! encoder.encode(batchElement)
        let requestObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] ?? [:]

        XCTAssertEqual(requestObject?.keys.count, 2)
        XCTAssertEqual(requestObject?["jsonrpc"] as? String, "2.0")
        XCTAssertEqual(requestObject?["method"] as? String, "method")
        XCTAssertNil(requestObject?["id"])
        XCTAssertNil(requestObject?["params"])
    }

    func testResponseFromObject() {
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))



        let responseObject: String =
        """
        {
            "id": 1,
            "jsonrpc": "2.0",
            "result": {
                "key": "value",
            }
        }
        """

        let response = try? batchElement.response(from: responseObject.data(using: .utf8)!)
        XCTAssertEqual(response?["key"], "value")
    }

    func testResponseFromArray() {
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray =
        """
        [
            {
                "id": 1,
                "jsonrpc": "2.0",
                "result": {
                    "key1": "value1",
                }
            },
            {
                "id": 2,
                "jsonrpc": "2.0",
                "result": {
                    "key2": "value2",
                }
            }
        ]
        """

        let response = try? batchElement.response(fromArray: responseArray.data(using: .utf8)!)
        XCTAssertEqual(response?["key1"], "value1")
    }

    func testResponseFromObjectResponseError() {
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject =
        """
        {
            "id": 1,
            "jsonrpc": "2.0",
            "error": {
                "code": 123,
                "message": "abc",
                "data": {
                    "key": "value",
                }
            }
        }
        """

        do {
            _ = try batchElement.response(from: responseObject.data(using: .utf8)!)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .responseError(let code, let message, let data)? = error {
                XCTAssertEqual(code, 123)
                XCTAssertEqual(message, "abc")

                let container = try? data.singleValueContainer()
                let dataDict = try? container?.decode(Dictionary<String, String>.self)
                XCTAssertEqual(dataDict??["key"], "value")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayResponseError() {
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray =
        """
        [
            {
                "id": 1,
                "jsonrpc": "2.0",
                "error": {
                    "code": 123,
                    "message": "abc",
                    "data": {
                        "key": "value",
                    }
                }
            },
            {
                "id": 2,
                "jsonrpc": "2.0",
                "result": {},
            }
        ]
        """

        do {
            _ = try batchElement.response(fromArray: responseArray.data(using: .utf8)!)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .responseError(let code, let message, let data)? = error {
                XCTAssertEqual(code, 123)
                XCTAssertEqual(message, "abc")
                let container = try? data.singleValueContainer()
                let dataDict = try? container?.decode(Dictionary<String, String>.self)
                XCTAssertEqual(dataDict??["key"], "value")
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectresultObjectParseError() {


        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject =
        """
        {
            "id": 1,
            "jsonrpc": "2.0",
            "result": 1,
        }
        """

        do {
            _ = try batchElement.response(from: responseObject.data(using: .utf8)!)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            guard case .resultObjectParseError(let e)? = error,
                case DecodingError.typeMismatch = e else {
                    XCTFail("Wrong error type!")
                    return
            }
        }
    }

    func testResponseFromArrayresultObjectParseError() {
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject =
        """
        [
            {
                "id": 1,
                "jsonrpc": "2.0",
                "result": 1
            },
            {
                "id": 2,
                "jsonrpc": "2.0",
                "result": 2,
            }
        ]
        """

        do {
            _ = try batchElement.response(fromArray: responseObject.data(using: .utf8)!)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            guard case .resultObjectParseError(let e)? = error,
                case DecodingError.typeMismatch = e else {
                    XCTFail("Wrong error type!")
                    return
            }
        }
    }

    func testResponseFromObjectErrorObjectParseError() {
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject =
        """
        {
            "id": 1,
            "jsonrpc": "2.0",
            "error": {
                "message": "abc",
            }
        }
        """

        do {
            _ = try batchElement.response(from: responseObject.data(using: .utf8)!)
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

        let responseArray =
        """
        [
            {
                "id": 1,
                "jsonrpc": "2.0",
                "error": {
                    "message": "abc",
                }
            },
            {
                "id": 2,
                "jsonrpc": "2.0",
                "result": 123,
            }
        ]
        """

        do {
            _ = try batchElement.response(fromArray: responseArray.data(using: .utf8)!)
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
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject =
        """
        {
            "id": 1,
            "jsonrpc": "1.0",
            "result": {
                "key": "value",
            }
        }
        """
        do {
            _ = try batchElement.response(from: responseObject.data(using: .utf8)!)
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
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(2))

        let responseArray =
        """
        [
            {
                "id": 1,
                "jsonrpc": "2.0",
                "result": {},
            },
            {
                "id": 2,
                "jsonrpc": "1.0",
                "result": {},
            }
        ]
        """
        do {
            _ = try batchElement.response(fromArray: responseArray.data(using: .utf8)!)
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
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject =
        """
        {
            "id": 2,
            "jsonrpc": "2.0",
            "result": {}
        }
        """

        do {
            _ = try batchElement.response(from: responseObject.data(using: .utf8)!)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .responseNotFound(let id)? = error {
                XCTAssertEqual(id, batchElement.id)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromArrayresponseNotFound() {
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray =
        """
        [
            {
                "id": 2,
                "jsonrpc": "2.0",
                "result": {},
            },
            {
                "id": 3,
                "jsonrpc": "2.0",
                "result": {},
            }
        ]
        """

        do {
            _ = try batchElement.response(fromArray: responseArray.data(using: .utf8)!)
            XCTFail()
        } catch {
            let error = error as? JSONRPCError
            if case .responseNotFound(let id)? = error {
                XCTAssertEqual(id, batchElement.id)
            } else {
                XCTFail()
            }
        }
    }

    func testResponseFromObjectmissingBothResultAndError() {
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseObject =
        """
        {
            "id": 1,
            "jsonrpc": "2.0",
        }
        """

        do {
            _ = try batchElement.response(from: responseObject.data(using: .utf8)!)
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
        let request = TestRequestStringDict(method: "method", parameters: nil)
        let batchElement = BatchElement(request: request, version: "2.0", id: Id.number(1))

        let responseArray =
        """
        [
            {
                "id": 1,
                "jsonrpc": "2.0",
            },
            {
                "id": 2,
                "jsonrpc": "2.0",
                "result": {},
            }
        ]
        """

        do {
            _ = try batchElement.response(fromArray: responseArray.data(using: .utf8)!)
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
