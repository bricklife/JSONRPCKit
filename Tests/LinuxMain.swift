import XCTest
@testable import JSONRPCKitTests

XCTMain([
    testCase(BatchElementTests.allTests),
    testCase(BatchFactoryTests.allTests),
    testCase(AnyEncodableTests.allTests),
])
