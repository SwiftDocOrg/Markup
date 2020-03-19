import XCTest
import Foundation
import HTML

final class HTMLTests: XCTestCase {
    func testParse() throws {
        let html = #"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hello, world!</title>
        </head>
        <body class="beautiful">
            <div class="wrapper">
                <span>Hello,</span>
                <span>world!</span>
            </div>
        </body>
        </html>

        """#

        let document = try HTML.Document(string: html)
        XCTAssertNotNil(document)

        XCTAssertNotNil(document?.head)
        XCTAssertEqual(document?.title, "Hello, world!")

        XCTAssertEqual(document?.head?.children.filter { $0 is Element }.count, 3)

        XCTAssertNotNil(document?.body)
        XCTAssertEqual(document?.body?["class"], "beautiful")

        let results = document?.search(xpath: "//span")
        XCTAssertEqual(results?.count, 2)
        XCTAssertEqual(results?.first?.name, "span")
        XCTAssertEqual(results?.first?.text, "Hello,")

        results?.last?.name = "strong"
        XCTAssertEqual(results?.last?.name, "strong")
        XCTAssertEqual(results?.last?.text, "world!")

        results?.last?.content = "mutable world!"
        XCTAssertEqual(results?.last?.text, "mutable world!")

        XCTAssertEqual(results?.first?.parent?.text, "Hello, mutable world!")

        let a = Element(name: "a")
        a["href"] = "https://example.com/"
        XCTAssertEqual(a["href"], "https://example.com/")

        results?.first?.wrap(inside: a)
        XCTAssertEqual(results?.first?.parent, a)

        document?.search(xpath: "//div").first?.unwrap()
        XCTAssertEqual(a.parent, document?.body)
    }
}
