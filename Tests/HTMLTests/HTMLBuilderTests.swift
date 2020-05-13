import XCTest
import Foundation
import HTML

final class HTMLBuilderTests: XCTestCase {
    func testBuilder() throws {
        let actual = Document {
            Element(name: "html", attributes: ["lang": "en"]) {
                Element(name: "head") {
                    Element(name: "meta", attributes: ["charset": "UTF-8"])
                    Element(name: "title") { "Hello, world!" }
                }

                Element(name: "body", attributes: ["class": "beautiful"]) {
                    ProcessingInstruction(target: "greeter") { "start" }

                    Element(name: "div", attributes: ["class": "wrapper"]) {
                        Element(name: "span") { "Hello," }
                        Element(name: "span") { "world!" }
                    }

                    ProcessingInstruction(target: "greeter") { "end" }
                }
            }
        }

        let html = #"""
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

        """#.split(separator: "\n", omittingEmptySubsequences: false)
            .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined()

        let expected = try HTML.Document(string: html, options: [.noDefaultDTD])

        XCTAssertEqual(actual?.description, expected?.description)
    }
}
