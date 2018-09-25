//
//  AnyEncodableTests.swift
//  JSONRPCKitTests
//
//  Created by Olli Tapaninen on 20/08/2018.
//  Copyright © 2018 Shinichiro Oba. All rights reserved.
//

import XCTest
@testable import JSONRPCKit

private struct AnyEncodable2: Encodable {

    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

private struct AnyEncodable3: Encodable {

    private let value: Encodable
    public init<T: Encodable>(_ wrapped: T) {
        value = wrapped
    }

    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

class AnyEncodableTests: XCTestCase {

    
    func testEncodeDate() {

        let date = Date(timeIntervalSince1970: 0)

        // This test will fail if you substitute AnyEncodable2 or AnyEncodable3 here.
        // Somehow the dateEncodingStrategy is lost in those implementations.
        // swift 4.1
        let array = [AnyEncodable(date), AnyEncodable("date")]

        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "fi_FI")
        encoder.dateEncodingStrategy = .formatted(formatter)

        let data = try? encoder.encode(array)

        let json = String(data: data ?? Data(), encoding: .utf8)
        XCTAssertEqual(json, "[\"1970-01-01\",\"date\"]")
    }

    static var allTests = [
        ("testEncodeDate", testEncodeDate),
        ]
}
