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

    public convenience init(target: String, content: String?) {
        let xmlNode = xmlNewPI(target, content)!
        self.init(rawValue: UnsafeMutableRawPointer(xmlNode))!
    }

    // MARK: -

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_PI_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}

// MARK: - StringBuilder

extension ProcessingInstruction {
    public convenience init(target: String, @StringBuilder _ builder: () -> String) {
        self.init(target: target, content: builder())
    }
}
