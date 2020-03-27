// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var providers: [SystemPackageProvider] = [.apt(["libxml2-dev"])]
#if swift(<5.2)
providers += [.brew(["libxml2"])]
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
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .systemLibrary(
            name: "libxml2",
            path: "Modules",
            pkgConfig: "libxml-2.0",
            providers: providers
        ),
        .target(
            name: "DOM",
            dependencies: ["libxml2"]),
        .target(
            name: "HTML",
            dependencies: ["DOM", "XPath", "libxml2"]),
        .target(
            name: "XML",
            dependencies: ["DOM", "XPath", "libxml2"]),
        .target(
            name: "XPath",
            dependencies: ["DOM", "libxml2"]),
        .target(
            name: "XInclude",
            dependencies: ["libxml2"]),
        .target(
            name: "XSLT",
            dependencies: ["libxml2"]),
        .testTarget(
            name: "HTMLTests",
            dependencies: ["HTML"]),
        .testTarget(
            name: "XMLTests",
            dependencies: ["XML"]),
    ]
)
