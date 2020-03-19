import libxml2

public final class ProcessingInstruction: Node {
    public func remove() {
        unlink()
    }

    public convenience init?(name: String, content: String?) {
        guard let xmlNode = xmlNewPI(name, content) else { return nil }
        self.init(rawValue: UnsafeMutableRawPointer(xmlNode))
    }

    // MARK: -

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_PI_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}
