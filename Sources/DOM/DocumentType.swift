import libxml2.tree

public final class DocumentType: Node {
    public var name: String {
        return String(cString: xmlDtd.pointee.name)
    }

    public var externalId: String? {
        return String(cString: xmlDtd.pointee.ExternalID)
    }

    public var systemId: String? {
        return String(cString: xmlDtd.pointee.SystemID)
    }

    var xmlDtd: xmlDtdPtr {
        rawValue.bindMemory(to: _xmlDtd.self, capacity: 1)
    }

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_DTD_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}
