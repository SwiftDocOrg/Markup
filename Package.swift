// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(Windows)
let systemLibraries: [Target] = []
let systemDependencies: [Target.Dependency] = []
#else
var providers: [SystemPackageProvider] = [.apt(["libxml2-dev"])]
#if swift(<5.2)
providers += [.brew(["libxml2"])]
#endif
let systemLibraries: [Target] = [
    .systemLibrary(
        name: "libxml2",
        path: "Modules",
        pkgConfig: "libxml-2.0",
        providers: providers
    )
]
let systemDependencies: [Target.Dependency] = [
    "libxml2"
]
#endif

let package = Package(
    name: "Markup",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Markup",
            targets: ["XML", "HTML"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: systemLibraries + [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DOM",
            dependencies: systemDependencies),
        .target(
            name: "HTML",
            dependencies: ["DOM", "XPath"] + systemDependencies,
            exclude: ["HTMLTags.swift.gyb"]),
        .target(
            name: "XML",
            dependencies: ["DOM", "XPath"] + systemDependencies),
        .target(
            name: "XPath",
            dependencies: ["DOM"] + systemDependencies),
        .target(
            name: "XInclude",
            dependencies: systemDependencies),
        .target(
            name: "XSLT",
            dependencies: systemDependencies),
        .testTarget(
            name: "HTMLTests",
            dependencies: ["HTML"]),
        .testTarget(
            name: "XMLTests",
            dependencies: ["XML"]),
    ]
)
