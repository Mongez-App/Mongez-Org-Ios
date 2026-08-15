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
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.1.0")
    ],
    targets: [
        .target(
            name: "OrganizationAuth",
            dependencies: [
                .product(name: "Common", package: "Common"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS")
            ]
        ),
        .testTarget(
            name: "OrganizationAuthTests",
            dependencies: ["OrganizationAuth"]),
    ]
)
