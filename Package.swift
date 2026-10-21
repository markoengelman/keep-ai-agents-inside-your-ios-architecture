// swift-tools-version: 6.4
import PackageDescription

let strict: [SwiftSetting] = [
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("ExistentialAny"),
    .treatAllWarnings(as: .error),
]

let settings = strict + [.defaultIsolation(MainActor.self)]

let package = Package(
    name: "Favourites",
    platforms: [.iOS(.v27), .macOS(.v27)],
    products: [
        .library(name: "FavouritesDomain", targets: ["FavouritesDomain"]),
        .library(name: "FavouritesData", targets: ["FavouritesData"]),
        .library(name: "FavouritesPresentation", targets: ["FavouritesPresentation"]),
        .library(name: "FavouritesUI", targets: ["FavouritesUI"]),
    ],
    targets: [
        .target(name: "FavouritesDomain", swiftSettings: strict),
        .target(name: "FavouritesData", dependencies: ["FavouritesDomain"], swiftSettings: strict),
        .target(
            name: "FavouritesPresentation",
            dependencies: ["FavouritesDomain"],
            swiftSettings: settings
        ),
        .target(
            name: "FavouritesUI",
            dependencies: ["FavouritesPresentation"],
            swiftSettings: settings
        ),
        .testTarget(name: "FavouritesDomainTests", dependencies: ["FavouritesDomain"]),
        .testTarget(name: "ArchitectureTests"),
    ]
)
