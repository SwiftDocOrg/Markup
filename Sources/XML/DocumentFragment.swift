import libxml2

@_exported import DOM

extension DocumentFragment {
    public var children: [Node] {
        return sequence(first: xmlDoc.pointee.children, next: { $0.pointee.next }).compactMap { Node.construct(with: $0) }
    }
}
