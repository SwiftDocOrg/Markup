import XCTest
import Foundation
import XML

final class XMLTests: XCTestCase {
    func testParse() throws {
        let xml = #"""
        <?xml version="1.0" encoding="UTF-8"?>
        <!-- begin greeting -->
        <greeting>Hello!</greeting>
        <!-- end greeting -->
        """#

        let document = try XML.Document(string: xml)
        XCTAssertNotNil(document)
        XCTAssertEqual(document?.properties.contains(.userBuilt), false)

        XCTAssertNotNil(document?.root)
        XCTAssertEqual(document?.root?.children.count, 1)

        let children = document?.children.map { $0 } ?? []
        XCTAssertEqual(children.count, 3)

        do {
            let comment = children[0] as! Comment
            XCTAssertEqual(comment.content?.trimmingCharacters(in: .whitespaces), "begin greeting")
            XCTAssertEqual(comment.description, "<!-- begin greeting -->")
        }

        do {
            let element = children[1] as! Element
            XCTAssertEqual(document?.root, element)

            XCTAssertEqual(element.name, "greeting")
            XCTAssertEqual(element.text, "Hello!")

            XCTAssertEqual(element.description, #"<greeting>Hello!</greeting>"#)

            element["formality"] = "standard"
            XCTAssertEqual(element.description, #"<greeting formality="standard">Hello!</greeting>"#)
        }

        do {
            let comment = children[2] as! Comment
            XCTAssertEqual(comment.content?.trimmingCharacters(in: .whitespaces), "end greeting")
            XCTAssertEqual(comment.description, "<!-- end greeting -->")
        }
    }

    func testCreate() throws {
        let document = Document()!
        XCTAssertEqual(document.properties.contains(.userBuilt), true)

        let element = Element(name: "greeting")
        element.content = "Hello!"
        element["formality"] = "standard"
        document.root = element

        element.prepend(sibling: " begin greeting " as Comment)
        element.append(sibling: " end greeting " as Comment)


        let expected: String = #"""
        <?xml version="1.0" encoding="UTF-8"?>
        <!-- begin greeting -->
        <greeting formality="standard">Hello!</greeting>
        <!-- end greeting -->

        """#

        XCTAssertEqual(document.description, expected)
    }
}
