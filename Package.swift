// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONRPCKit",
    products: [
        .library(name: "JSONRPCKit", targets: ["JSONRPCKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/antitypical/Result.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "JSONRPCKit", dependencies: ["Result"]),
        .testTarget(name: "JSONRPCKitTests", dependencies: ["JSONRPCKit"]),
    ],
    swiftLanguageVersions: [4]
)
