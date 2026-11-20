// swift-tools-version:6.4

import PackageDescription

let package = Package(
  name: "{{PROJECT_SLUG}}",
  targets: [
    .target(name: "{{PROJECT_SNAKE}}", path: "src"),
    .testTarget(name: "Tests", dependencies: ["{{PROJECT_SNAKE}}"], path: "tests"),
  ]
)
