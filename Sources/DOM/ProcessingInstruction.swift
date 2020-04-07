import libxml2

public final class ProcessingInstruction: Node {
    public var target: String {
        get {
            return String(cString: xmlNode.pointee.name)
        }

        set {
            xmlNodeSetName(xmlNode, newValue)
        }
    }

    public func remove() {
        unlink()
    }

    // MARK: -

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
