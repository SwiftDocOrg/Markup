import libxml2
@_exported import DOM

extension Element {
    public var namespace: Namespace? {
        guard let rawValue = xmlNode.pointee.ns else { return nil }
        return Namespace(rawValue: rawValue)
    }

    public var namespaceDefinitions: [Namespace] {
        return sequence(first: xmlNode.pointee.nsDef, next: { $0.pointee.next }).compactMap { Namespace(rawValue: $0) }
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
