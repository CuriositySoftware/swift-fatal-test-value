// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-fatal-test-value",
    platforms: [.macOS(.v10_15), .iOS(.v17), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "FatalTestValue",
            targets: ["FatalTestValue"]
        ),
        .executable(
            name: "ImplementationMacroClient",
            targets: ["ImplementationMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.2"),
        .package(url: "https://github.com/apple/swift-testing.git", revision: "aa8702a"),
    ],
    targets: [
        .macro(
            name: "FatalErrorTestValueImplementationMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "FatalTestValue",
            dependencies: ["FatalErrorTestValueImplementationMacro"]
        ),
        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(
            name: "ImplementationMacroClient",
            dependencies: [
                "FatalTestValue",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "FatalErrorTestValueImplementationMacroTests",
            dependencies: [
                "FatalErrorTestValueImplementationMacro",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "Testing", package: "swift-testing"),
            ]
        ),
    ]
)
