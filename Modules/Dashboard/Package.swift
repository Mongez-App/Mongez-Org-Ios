// swift-tools-version: 5.7.1
import PackageDescription

let package = Package(
    name: "Dashboard",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Dashboard",
            targets: ["Dashboard"]),
    ],
    dependencies: [
        .package(path: "../Common"),
    ],
    targets: [
        .target(
            name: "Dashboard",
            dependencies: [
                .product(name: "Common", package: "Common")
            ]),
        .testTarget(
            name: "DashboardTests",
            dependencies: ["Dashboard"]),
    ]
)
