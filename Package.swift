// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CommentsCore",
    products: [
        .library(name: "CommentsCore", targets: ["CommentsCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/vapor/fluent.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc.2"),
        .package(url: "https://github.com/LiveUI/DbCore.git", .branch("master")),
        .package(url: "https://github.com/LiveUI/ApiCore.git", .branch("master")),
        .package(url: "https://github.com/LiveUI/ErrorsCore.git", .branch("master")),
        .package(url: "https://github.com/LiveUI/VaporTestTools.git", .branch("master")),
        .package(url: "https://github.com/LiveUI/FluentTestTools.git", .branch("master"))
    ],
    targets: [
        .target(name: "CommentsCore", dependencies: [
            "Vapor",
            "DbCore",
            "ApiCore",
            "Fluent",
            "FluentPostgreSQL",
            "ErrorsCore"
            ]
        ),
        .testTarget(name: "CommentsCoreTests", dependencies: [
            "CommentsCore",
            "ApiCore",
            "VaporTestTools",
            "FluentTestTools",
            "ApiCoreTestTools"
            ]
        )
    ]
)
