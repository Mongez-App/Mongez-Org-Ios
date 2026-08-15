// swift-tools-version: 5.7.1
import PackageDescription

let package = Package(
    name: "OrganizationAuth",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "OrganizationAuth",
            targets: ["OrganizationAuth"]),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.19.0"),
    ],
    targets: [
        .target(
            name: "OrganizationAuth",
            dependencies: [
                .product(name: "Common", package: "Common"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            resources: [.process("Themes/Assets.xcassets")]
        ),
        .testTarget(
            name: "OrganizationAuthTests",
            dependencies: ["OrganizationAuth"]),
    ]
)
