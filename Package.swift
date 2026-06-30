// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "JournalWidget",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "JournalWidget", targets: ["JournalWidget"])
    ],
    targets: [
        .executableTarget(
            name: "JournalWidget",
            path: "Sources"
        )
    ]
)