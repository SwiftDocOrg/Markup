import libxml2

public final class Expression: RawRepresentable {
    public var rawValue: xmlXPathCompExprPtr

    public required init?(rawValue: xmlXPathCompExprPtr) {
        self.rawValue = rawValue
    }

    public convenience init?(_ string: String) {
        guard let compiledExpression = xmlXPathCompile(string) else { return nil }
//        defer { xmlXPathFreeCompExpr(compiledExpression) }
        self.init(rawValue: compiledExpression)
    }
}

// MARK: - ExpressibleByStringLiteral

extension Expression: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: String) {
        self.init(value)!
    }
}
