import libxml2.tree
import Foundation

public final class DocumentFragment: Node {
    public var xmlDoc: xmlDocPtr {
        rawValue.bindMemory(to: _xmlDoc.self, capacity: 1)
    }

    // MARK: -

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlDoc.self, capacity: 1).pointee.type == XML_DOCUMENT_FRAG_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}
