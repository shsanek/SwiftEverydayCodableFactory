// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "SwiftEverydayCodableFactory",
    products: [
        .library(
            name: "SwiftEverydayCodableFactory",
            targets: ["SwiftEverydayCodableFactory"]),
    ],
    dependencies: [
        .swiftEveryday("SwiftEverydayUtils"),
    ],
    targets: [
        .target(
            name: "SwiftEverydayCodableFactory",
            dependencies: ["SwiftEverydayUtils"]
        ),
        .testTarget(
            name: "SwiftEverydayCodableFactoryTests",
            dependencies: ["SwiftEverydayCodableFactory"]),
    ]
)

extension Package.Dependency {
    enum Source {
        case version(Version)
        case branch(name: String)
    }
    static let swiftEverydaySource: Source = .branch(name: "master")

    static func swiftEveryday(_ name: String) -> Package.Dependency {
        let file = #file
        let url = URL(filePath: file).deletingLastPathComponent().deletingLastPathComponent()
        if url.lastPathComponent == "SwiftEverydayProject" {
            return .package(name: name, path: "../\(name)")
        } else {
            switch swiftEverydaySource {
            case .version(let version):
                return .package(url: "https://github.com/shsanek/\(name).git", exact: version)
            case .branch(let branch):
                return .package(url: "https://github.com/shsanek/\(name).git", branch: branch)
            }
        }
    }
}
