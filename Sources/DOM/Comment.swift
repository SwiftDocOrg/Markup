import libxml2.tree

public final class Comment: Node {
    public func remove() {
        unlink()
    }

    public convenience init(content: String) {
        self.init(rawValue: UnsafeMutableRawPointer(xmlNewComment(content)))!
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
