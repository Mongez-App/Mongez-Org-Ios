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
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        .target(
            name: "Profile",
            dependencies: [
                .product(name: "Common", package: "Common"),
                .product(name: "Swinject-Dynamic", package: "Swinject")
            ]),
        .testTarget(
            name: "ProfileTests",
            dependencies: ["Profile"]),
    ]
)
