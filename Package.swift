// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONRPCKit",
    products: [
        .library(name: "JSONRPCKit", targets: ["JSONRPCKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/antitypical/Result.git", from: "5.0.0"),
    ],
    targets: [
        .target(name: "JSONRPCKit", dependencies: ["Result"]),
        .testTarget(name: "JSONRPCKitTests", dependencies: ["JSONRPCKit"]),
    ],
    swiftLanguageVersions: [.v4]
)
