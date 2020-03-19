import libxml2

import DOM

extension Node: Constructable {
    public static func construct(with rawValue: xmlNodePtr) -> Node? {
        switch rawValue.pointee.type {
        case XML_ELEMENT_NODE:
            return Element(rawValue: rawValue)
        case XML_HTML_DOCUMENT_NODE:
            return Document(rawValue: rawValue.pointee.doc)
        case XML_TEXT_NODE:
            return Text(rawValue: rawValue)
        case XML_COMMENT_NODE:
            return Comment(rawValue: rawValue)
        case XML_PI_NODE:
            return ProcessingInstruction(rawValue: rawValue)
        default:
            return nil
        }
    }

    var xmlNode: xmlNodePtr {
        rawValue.bindMemory(to: _xmlNode.self, capacity: 1)
    }

    public var parent: Node? {
        return Node.construct(with: xmlNode.pointee.parent)
    }

    public var previous: Node? {
        return Node.construct(with: xmlNode.pointee.prev)
    }

    public var next: Node? {
        return Node.construct(with: xmlNode.pointee.next)
    }
}
