import libxml2
import Foundation

public final class DocumentFragment: Node {
    // MARK: -

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_DOCUMENT_FRAG_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}
