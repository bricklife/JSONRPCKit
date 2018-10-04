// swift-tools-version:4.2
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
        .target(
            name: "JSONRPCKit",
            dependencies: ["Result"]
        ),
        .testTarget(
            name: "JSONRPCKitTests",
            dependencies: ["JSONRPCKit"]
        ),
    ],
    swiftLanguageVersions: [ .v4, .v4_2]
)
