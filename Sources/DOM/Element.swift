import libxml2

public final class Element: Node {
    public enum CloningBehavior: Int32 {
        case `default` = 0

        /// do a recursive copy (properties, namespaces and children when applicable)
        case recursive = 1

        /// copy properties and namespaces (when applicable)
        case shallow = 2
    }

    public var document: Document? {
        guard let rawValue = xmlNode.pointee.doc else { return nil }
        return Document(rawValue: UnsafeMutableRawPointer(rawValue))
    }

    public var name: String {
        get {
            return String(cString: xmlNode.pointee.name)
        }

        set {
            xmlNodeSetName(xmlNode, newValue)
        }
    }

    public subscript(attribute: String) -> String? {
        get {
            return String(xmlString: xmlGetProp(xmlNode, attribute))
        }

        set {
            if let newValue = newValue {
                xmlSetProp(xmlNode, attribute, newValue)
            } else {
                xmlUnsetProp(xmlNode, attribute)
            }
        }
    }

    public func append(sibling node: Node) {
        xmlAddNextSibling(xmlNode, node.xmlNode)
    }

    public func prepend(sibling node: Node) {
        xmlAddPrevSibling(xmlNode, node.xmlNode)
    }

    public func replace(with node: Node) {
        xmlReplaceNode(xmlNode, node.xmlNode)
    }

    public func insert(child node: Node) {
        xmlAddChild(xmlNode, node.xmlNode)
    }

    public func wrap(inside element: Element) {
        replace(with: element)
        element.insert(child: self)
    }

    func clone(behavior: CloningBehavior = .recursive) throws -> Self {
        guard let rawValue = xmlCopyNode(xmlNode, behavior.rawValue) else { throw Error.unknown }
        return Self(rawValue: UnsafeMutableRawPointer(rawValue))!
    }

    public func remove() {
        unlink()
    }

    // MARK: -

    public convenience init(name: String, attributes: [String: String] = [:]) {
        let xmlNode = xmlNewNode(nil, name)!
        self.init(rawValue: UnsafeMutableRawPointer(xmlNode))!

        for (attribute, value) in attributes {
            self[attribute] = value.description
        }
    }

    // MARK: -

    public required init?(rawValue: UnsafeMutableRawPointer?) {
        guard let rawValue = rawValue else {
             return nil
        }
        guard rawValue.bindMemory(to: _xmlNode.self, capacity: 1).pointee.type == XML_ELEMENT_NODE else { return nil }
        super.init(rawValue: rawValue)
    }
}

// MARK: -

extension Constructable where Self: Element {
    public var text: String {
        return children.compactMap { child in
            switch child {
            case let element as Self:
                return element.text
            case let text as Text where !text.isBlank:
                return text.content?.trimmingCharacters(in: .whitespacesAndNewlines)
            default:
                return nil
            }
        }.joined(separator: " ")
    }
}

// MARK: - DOMBuilder

extension Element {
    public convenience init(name: String, attributes: [String: String] = [:], @DOMBuilder children builder: () -> Node = { DocumentFragment() }) {
        self.init(name: name, attributes: attributes)

        switch builder() {
        case let fragment as DocumentFragment & Constructable:
            for child in fragment.children {
                self.insert(child: child)
            }
        case let node:
            self.insert(child: node)
        }
    }
}
