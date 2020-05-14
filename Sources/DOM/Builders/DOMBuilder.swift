@_functionBuilder
public struct DOMBuilder {

    // MARK: buildExpression

    public static func buildExpression(_ node: Node) -> Node {
        return node
    }

    public static func buildExpression(_ string: String) -> Node {
        return Text(content: string)
    }

    // MARK: buildBlock

    public static func buildBlock(_ children: Node...) -> Node {
        let fragment = DocumentFragment()
        for child in children.compactMap({ $0 }) {
            guard !child.isBlank else { continue }
            fragment.insert(child: child)
        }

        return fragment
    }

    public static func buildBlock(_ strings: String...) -> Node {
        return Text(content: strings.joined(separator: "\n\n"))
    }

    // MARK: buildIf

    public static func buildIf(_ child: Node?) -> Node {
        if let child = child {
            return child
        } else {
            return DocumentFragment()
        }
    }

    public static func buildIf(_ string: String?) -> Node {
        return Text(content: string ?? "")
    }

    // MARK: buildEither

    public static func buildEither(first: Node) -> Node {
        return first
    }

    public static func buildEither(second: Node) -> Node {
        return second
    }

    public static func buildEither(first: String) -> Node {
        return Text(content: first)
    }

    public static func buildEither(second: String) -> Node {
        return Text(content: second)
    }
}
