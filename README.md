# Markup

![CI][ci badge]
[![Documentation][documentation badge]][documentation]

A Swift package for working with HTML, XML, and other markup languages,
based on [libxml2][libxml2].

**This project is under active development and is not ready for production use.**

## Features

- [x] XML Support
- [x] XHTML4 Support
- [x] XPath Expression Evaluation
- [ ] HTML5 Support (using [Gumbo][gumbo])
- [ ] CSS Selector to XPath Functionality*
- [ ] XML Namespace Support*
- [ ] DTD and Relax-NG Validation*
- [ ] XInclude Support*
- [ ] XSLT Support*
- [ ] SAX Parser Interface*
- [x] HTML and XML Function Builder Interfaces

> \* Coming soon!

## Requirements

- Swift 5.1+
- [libxml2][libxml2] _(except for macOS with Xcode 11.4 or later)_

## Usage

### XML

#### Parsing & Introspection

```swift
import XML

let xml = #"""
<?xml version="1.0" encoding="UTF-8"?>
<!-- begin greeting -->
<greeting>Hello!</greeting>
<!-- end greeting -->
"""#

let document = try XML.Document(string: xml)!
document.root?.name // "greeting"
document.root?.content // "Hello!"

document.children.count // 3 (two comment nodes and one element node)
document.root?.children.count // 1 (one text node)
```

#### Searching and XPath Expression Evaluation

```swift
document.search("//greeting").count // 1
document.evaluate("//greeting/text()") // .string("Hello!")
```

#### Modification

```swift
for case let comment as Comment in document.children {
    comment.remove()
}

document.root?.name = "valediction"
document.root?["lang"] = "it"
document.root?.content = "Arrivederci!"

document.description // =>
/*
<?xml version="1.0" encoding="UTF-8"?>
<valediction lang="it">Arrivederci!</valediction>

*/
```

* * *

### HTML

#### Parsing & Introspection

```swift
import HTML

let html = #"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
</head>
<body>
    <p>Hello, world!</p>
</body>
</html>
"""#

let document = try HTML.Document(string: html)!
document.body?.children.count // 1 (one element node)
document.body?.children.first?.name // "p"
document.body?.children.first?.text // "Hello, world!"
```

#### Searching and XPath Expression Evaluation

```swift
document.search("/body/p").count // 1
document.search("/body/p").first?.xpath // "/body/p[0]"
document.evaluate("/body/p/text()") // .string("Hello, world!")
```

#### Creation and Modification

```swift
let div = Element(name: "div")
div["class"] = "wrapper"
if let p = document.search("/body/p").first {
    p.wrap(inside: div)
}

document.body?.description // =>
/*
<div class="wrapper">
    <p>Hello, world!</p>
</div>
*/
```

#### Builder Interface

Available in Swift 5.3+.

```swift
import HTML

let document = HTML.Document {
    html(["lang": "en"]) {
        head {
            meta(["charset": "UTF-8"])
            title { "Hello, world!" }
        }

        body(["class": "beautiful"]) {
            div(["class": "wrapper"]) {
                span { "Hello," }
                tag("span") { "world!" }
            }
        }
    }
}

document.description // =>
/*
<html lang="en">
  <head>
      <meta charset="UTF-8">
      <title>Hello, world!</title>
  </head>
  <body class="beautiful">
      <?greeter start>
      <div class="wrapper">
          <span>Hello,</span>
          <span>world!</span>
      </div>
      <?greeter end>
  </body>
</html>

*/
```

## Installation

### Swift Package Manager

If you're on Linux or if you're on macOS and using Xcode < 11.4,
install the [libxml2][libxml2] system library:

```terminal
# macOS for Xcode 11.3 and earlier
$ brew install libxml2
$ brew link --force libxml2

# Linux (Ubuntu)
$ sudo apt-get install libxml2-dev
```

Add the Markup package to your target dependencies in `Package.swift`:

```swift
import PackageDescription

let package = Package(
  name: "YourProject",
  dependencies: [
    .package(
        url: "https://github.com/SwiftDocOrg/Markup",
        from: "0.1.3"
    ),
  ]
)
```

Add `Markup` as a dependency to your target(s):

```swift
targets: [
.target(
    name: "YourTarget",
    dependencies: ["Markup"]),
```

If you're using Markup in an app,
link `libxml2` to your target.
Open your Xcode project (`.xcodeproj`) or workspace (`.xcworkspace`) file,
select your top-level project entry in the Project Navigator,
and select the target using Markup listed under the Targets heading. 
Navigate to the "Build Phases" tab,
expand "Link Binary With Libraries",
and click the <kbd>+</kbd> button to add a library.
Enter "libxml2" to the search bar,
select "libxml2.tbd" from the filtered list,
and click the Add button.

<img width="512" alt="Add libxml2 library to your target" src="https://user-images.githubusercontent.com/7659/120312587-c7036d80-c28d-11eb-9388-d523c5f6916f.png">

## License

MIT

## Contact

Mattt ([@mattt](https://twitter.com/mattt))

[libxml2]: http://xmlsoft.org
[gumbo]: https://github.com/google/gumbo-parser
[ci badge]: https://github.com/SwiftDocOrg/Markup/workflows/CI/badge.svg
[documentation badge]: https://github.com/SwiftDocOrg/Markup/workflows/Documentation/badge.svg
[documentation]: https://github.com/SwiftDocOrg/Markup/wiki
