import XCTest
import Foundation
import XML

final class XMLTests: XCTestCase {
    func testParseXML() throws {
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

            XCTAssertEqual(element.evaluate(xpath: "string(text())"), .string("Hello!"))
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

    func testParseXSD() throws {
        let xsd = #"""
        <?xml version="1.0" encoding="UTF-8"?>
        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" targetNamespace="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <xs:import namespace="http://www.w3.org/2001/XMLSchema-instance" schemaLocation="xsi.xsd"/>
            <xs:import namespace="http://www.w3.org/XML/1998/namespace" schemaLocation="xml.xsd"/>
            <xs:element name="Heading.class" abstract="true">
            <xs:element name="h1" substitutionGroup="xhtml:Heading.class"/>
        </xs:schema>

        """#

        let document = try XML.Document(string: xsd)

        XCTAssertNotNil(document)

        let results = document?.search(xpath: "//xs:element[not(@abstract = 'true')]")
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?["name"], "h1")
    }
    
    func testTraverse() throws {
        let xml = #"""
            <root>
                hello
                <one/>
                <two/>
                <three/>
                world
            </root>
        """#
        
        let doc = try XML.Document(string: xml, options: [.removeBlankNodes])!
        let root = doc.root!
        XCTAssertEqual(root.name, "root")
        XCTAssertNil(root.next)
        XCTAssertNil(root.previous)
        XCTAssertEqual(root.firstChildElement?.name, "one")
        XCTAssertEqual(root.lastChildElement?.name, "three")
        XCTAssertEqual(root.firstChild?.content?.trimmingCharacters(in: .whitespacesAndNewlines), "hello")
        XCTAssertEqual(root.lastChild?.content?.trimmingCharacters(in: .whitespacesAndNewlines), "world")
        XCTAssertNil(root.firstChild?.firstChild)
        XCTAssertNil(root.firstChild?.lastChild)
        XCTAssertNil(root.firstChildElement?.firstChild)
        XCTAssertNil(root.firstChildElement?.lastChild)

    }

}
