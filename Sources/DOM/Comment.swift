import libxml2

public final class Comment: Node {
    public func remove() {
        unlink()
    }

    public convenience init(content: String) {
        let xmlNode = xmlNewComment(content)!
        self.init(rawValue: UnsafeMutableRawPointer(xmlNode))!
    }

    // MARK: -

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_COMMENT_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}

// MARK: - ExpressibleByStringLiteral

extension Comment: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: String) {
        self.init(content: value)
    }
}

// MARK: - StringBuilder

extension Comment {
    public convenience init(@StringBuilder _ builder: () -> String) {
        self.init(content: builder())
    }
}
