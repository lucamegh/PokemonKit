// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "PokemonKit",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "PokemonKit",
      targets: ["PokemonKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
    .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.10.0")
  ],
  targets: [
    .target(
      name: "PokeAPI",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies")
      ]
    ),
    .target(
      name: "PokemonKit",
      dependencies: [
        "PokeAPI",
        "ShakespeareTranslator",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Tagged", package: "swift-tagged")
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "ShakespeareTranslator",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies")
      ]
    ),
    .testTarget(
      name: "PokemonKitTests",
      dependencies: ["PokemonKit"]
    )
  ]
)
