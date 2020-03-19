import libxml2

public final class CDATA: Node {
    public convenience init?(content: String, in document: Document) {
        guard let xmlNode = xmlNewCDataBlock(document.xmlDoc, content, numericCast(content.lengthOfBytes(using: .utf8))) else { return nil }
        self.init(rawValue: UnsafeMutableRawPointer(xmlNode))
    }

    // MARK: -

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_TEXT_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}
