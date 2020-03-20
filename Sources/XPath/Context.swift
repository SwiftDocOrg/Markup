import libxml2

import DOM

public final class Context: RawRepresentable {
    public var rawValue: xmlXPathContextPtr

    public convenience init?(document: Document) {
        let xmlDoc = document.rawValue.bindMemory(to: _xmlDoc.self, capacity: 1)
        self.init(xmlDoc: xmlDoc)
    }

    public convenience init?(fragment: DocumentFragment) {
        let xmlNode = fragment.rawValue.bindMemory(to: _xmlNode.self, capacity: 1)
        self.init(xmlDoc: xmlNode.pointee.doc)
    }

    private convenience init?(xmlDoc: xmlDocPtr) {
        guard let context = xmlXPathNewContext(xmlDoc) else { return nil }
        defer { xmlXPathFreeContext(context) }
        self.init(rawValue: context)
    }

    public required init(rawValue: xmlXPathContextPtr) {
        self.rawValue = rawValue
    }

    public func evaluate(expression: Expression) -> XPath.Object? {
        guard let xmlObject = xmlXPathCompiledEval(expression.rawValue, rawValue) else { return nil }
//        defer { xmlXPathFreeObject(xmlObject) }

        return XPath.Object(rawValue: xmlObject)
    }

    public func test(expression: Expression) throws -> Bool {
        switch xmlXPathCompiledEvalToBoolean(expression.rawValue, rawValue) {
        case 0:
            return false
        case 1:
            return true
        default:
            throw Error.unknown
        }
    }
}
