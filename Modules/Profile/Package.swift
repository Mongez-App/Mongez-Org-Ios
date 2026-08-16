// swift-tools-version: 5.7.1
import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Profile",
            targets: ["Profile"]),
    ],
    dependencies: [
        .package(path: "../Common"),
    ],
    targets: [
        .target(
            name: "Profile",
            dependencies: [
                .product(name: "Common", package: "Common")
            ]),
        .testTarget(
            name: "ProfileTests",
            dependencies: ["Profile"]),
    ]
)
