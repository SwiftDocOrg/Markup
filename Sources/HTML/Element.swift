import libxml2
@_exported import DOM

// MARK: - XPath

extension Element {
    public func search(xpath: XPath.Expression) -> [Element] {
        guard case .nodeSet(let nodeSet) = evaluate(xpath: xpath) else { return [] }
        return nodeSet.compactMap { Element($0) }
    }

    public func evaluate(xpath: XPath.Expression) -> XPath.Object? {
        guard let context = Context(element: self) else { return nil }

        guard let object = xmlXPathCompiledEval(xpath.rawValue, context.rawValue) else { return nil }
//        defer { xmlXPathFreeObject(object) }

        return XPath.Object(rawValue: object)
    }
}
