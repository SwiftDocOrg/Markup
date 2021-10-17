import libxml2

open class Node: RawRepresentable, Equatable, Hashable, CustomStringConvertible {
    public enum SpacePreservingBehavior: Int32 {
        case `default` = 0
        case preserve = 1
    }
    
    public var line: Int {
        return numericCast(xmlGetLineNo(xmlNode))
    }

    public var isBlank: Bool {
        return xmlIsBlankNode(xmlNode) != 0
    }
    
    public var spacePreservingBehavior: SpacePreservingBehavior? {
        return SpacePreservingBehavior(rawValue: xmlNodeGetSpacePreserve(xmlNode))
    }
    
    public var content: String? {
        get {
            return String(xmlString: xmlNodeGetContent(xmlNode))
        }
        
        set {
            xmlNodeSetContent(xmlNode, newValue)
        }
    }
    
    public var xpath: String? {
        guard let cString = xmlGetNodePath(xmlNode) else { return nil }
        return String(xmlString: cString)
    }
    
    func unlink() {
        xmlUnlinkNode(xmlNode)
    }
    
    // MARK: - RawRepresentable
    
    public var rawValue: UnsafeMutableRawPointer
    
    var xmlNode: xmlNodePtr {
        rawValue.bindMemory(to: _xmlNode.self, capacity: 1)
    }
    
    public required init?(rawValue: UnsafeMutableRawPointer) {
        self.rawValue = rawValue
    }
    
    public convenience init?(_ node: Node?) {
        guard let rawValue = node?.rawValue else { return nil }
        self.init(rawValue: rawValue)
    }

    // MARK: - CustomStringConvertible

    open var description: String {
        let buffer = xmlBufferCreate()
        defer { xmlBufferFree(buffer) }

        xmlNodeDump(buffer, xmlNode.pointee.doc, xmlNode, 0, 0)

        return String(cString: xmlBufferContent(buffer))
    }
}

// MARK: -

public protocol Constructable {
    static func construct(with rawValue: xmlNodePtr?) -> Node?
}

extension Constructable where Self: Node {
    
    public var children: [Node] {
        guard let firstChild = xmlNode.pointee.children else { return [] }
        return sequence(first: firstChild, next: { $0.pointee.next })
                .compactMap { Self.construct(with: $0) }
    }

    public var firstChildElement: Element? {
        return findFirstNode(start: xmlNode.pointee.children, next: { $0.pointee.next }) { node in
            node as? Element != nil
        } as? Element
    }

    public func firstChildElement(named name: String) -> Element? {
        return findFirstNode(start: xmlNode.pointee.children, next: { $0.pointee.next }) { node in
            (node as? Element)?.name == name
        } as? Element
    }

    public var lastChildElement: Element? {
        return findFirstNode(start: lastChild?.xmlNode, next: { $0.pointee.prev }) { node in
            (node as? Element) != nil
        } as? Element
    }

    public func lastChildElement(named name: String) -> Element? {
        return findFirstNode(start: lastChild?.xmlNode, next: { $0.pointee.prev }) { node in
            (node as? Element)?.name == name
        } as? Element
    }

    public var parent: Element? {
        return Element(rawValue: xmlNode.pointee.parent)
    }
    
    public var previous: Node? {
        return Self.construct(with: xmlNode.pointee.prev)
    }

    public var next: Node? {
        return Self.construct(with: xmlNode.pointee.next)
    }

    public var firstChild: Node? {
        return Self.construct(with: xmlNode.pointee.children)
    }
    
    public var lastChild: Node? {
        return Self.construct(with: xmlGetLastChild(xmlNode))
    }

    @discardableResult
    public func unwrap() -> Node? {
        let children = sequence(first: xmlNode.pointee.children, next: { $0.pointee.next }).compactMap { Node(rawValue: $0) }
        guard !children.isEmpty else { return nil }
        
        if let sibling = previous as? Element {
            children.forEach { sibling.append(sibling: $0) }
        } else if let sibling = next as? Element {
            children.forEach { sibling.prepend(sibling: $0) }
        } else if let parent = parent {
            children.forEach { parent.insert(child: $0) }
        } else {
            return nil
        }
        
        defer { unlink() }
        
        return children.first
    }
    
    private func findFirstNode(
        start: UnsafeMutablePointer<_xmlNode>?,
        next: @escaping (xmlNodePtr) -> xmlNodePtr?,
        where predicate: (Node) -> Bool ) -> Node?
    {
        var n = start
        while let each = n {
            if let node = Self.construct(with: each) {
                if predicate(node) {
                    return node
                }
            }
            n = next(each)
        }
        return nil
    }
}
