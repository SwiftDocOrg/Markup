import libxml2
@_exported import DOM

extension Element {
    public var namespace: Namespace? {
        guard let rawValue = xmlNode.pointee.ns else { return nil }
        return Namespace(rawValue: rawValue)
    }

    public var namespaceDefinitions: [Namespace] {
        guard let nsDef = xmlNode.pointee.nsDef else { return [] }
        return sequence(first: nsDef, next: { $0.pointee.next }).compactMap { Namespace(rawValue: $0) }
    }

    public subscript(attribute: String, namespace: Namespace?) -> String? {
        get {
            if let namespace = namespace {
                return String(xmlString: xmlGetNsProp(xmlNode, attribute, namespace.uri))
            } else {
                return String(xmlString: xmlGetNoNsProp(xmlNode, attribute))
            }
        }
        
        set {
            if let namespace = namespace {
                xmlSetNsProp(xmlNode, namespace.rawValue, attribute, newValue)
            } else {
                xmlSetProp(xmlNode, attribute, newValue)
            }
        }
    }
}

// MARK: - XPath

extension Element {
    public func search(xpath: XPath.Expression) -> [Element] {
        guard case .nodeSet(let nodeSet) = evaluate(xpath: xpath) else { return [] }
        return nodeSet.compactMap { Element($0) }
    }

    public func evaluate(xpath: XPath.Expression) -> XPath.Object? {
        guard let context = Context(element: self) else { return nil }
        for namespace in namespaceDefinitions {
            context.register(namespace: namespace)
        }

        guard let object = xmlXPathCompiledEval(xpath.rawValue, context.rawValue) else { return nil }
//        defer { xmlXPathFreeObject(object) }

        return XPath.Object(rawValue: object)
    }
}
