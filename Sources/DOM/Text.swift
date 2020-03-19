import libxml2

public final class Text: Node {
    public func merge(with node: Text) throws {
        guard let xmlNode = xmlTextMerge(xmlNode, node.xmlNode) else { throw Error.unknown }

        xmlReplaceNode(self.xmlNode, xmlNode)
    }

    public func concatenate(_ string: String) throws {
        guard xmlTextConcat(xmlNode, string, numericCast(string.lengthOfBytes(using: .utf8))) == 0 else { throw Error.unknown }
    }

    public func remove() {
        unlink()
    }

    public convenience init(content: String) {
        self.init(rawValue: UnsafeMutableRawPointer(xmlNewText(content)))!
    }

    // MARK: -

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_TEXT_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}

// MARK: - ExpressibleByStringLiteral

extension Text: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: String) {
        self.init(content: value)
    }
}
