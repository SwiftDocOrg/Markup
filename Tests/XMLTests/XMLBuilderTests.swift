import XCTest
import Foundation
import XML

#if swift(>=5.3)
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
    
    func testTraverse() throws {
        let xml = #"""
            <root/>
        """#
        
        let doc = try XML.Document(string: xml)!
        let root = doc.root!
        XCTAssertEqual(root.name, "root")
        XCTAssertNil(root.next)
        XCTAssertNil(root.previous)
    }
}
#endif
