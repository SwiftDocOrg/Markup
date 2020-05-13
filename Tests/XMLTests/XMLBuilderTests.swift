import XCTest
import Foundation
import XML

final class XMLBuilderTests: XCTestCase {
    func testBuilder() throws {
        let actual = Document {
            Comment { "begin greeting" }
            Element(name: "greeting") { "Hello!" }
            Comment { "end greeting" }
        }

        let xml = #"""
        <?xml version="1.0" encoding="UTF-8"?>
        <!--begin greeting-->
        <greeting>Hello!</greeting>
        <!--end greeting-->

        """#

        let expected = try XML.Document(string: xml)

        XCTAssertEqual(actual?.description, expected?.description)
    }
}
