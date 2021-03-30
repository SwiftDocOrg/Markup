import libxml2
import Foundation

public final class DocumentFragment: Node {
    public func insert(child node: Node) {
        xmlAddChild(xmlNode, node.xmlNode)
    }

    // MARK: -

    public convenience init() {
        self.init(rawValue: xmlNewDocFragment(nil))!
    }

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_DOCUMENT_FRAG_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}

// MARK: - DOMBuilder

extension DocumentFragment {
    public convenience init(@DOMBuilder children builder: () -> Node) {
        switch builder() {
        case let fragment as DocumentFragment:
            self.init(fragment)!
        case let node:
            self.init()
            self.insert(child: node)
        }
    }
}
