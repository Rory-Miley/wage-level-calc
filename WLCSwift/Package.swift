// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WageLevelCalc",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "WageLevelCalc",
            targets: ["WageLevelCalc"]),
    ],
    targets: [
        .executableTarget(
            name: "WageLevelCalc",
            dependencies: []),
    ]
) 