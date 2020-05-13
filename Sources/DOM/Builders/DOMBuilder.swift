@_functionBuilder
public struct DOMBuilder {

    // MARK: buildBlock

    public static func buildBlock(_ children: Node...) -> Node {
        let fragment = DocumentFragment()
        for child in children.compactMap({ $0 }) {
            guard !child.isBlank else { continue }
            fragment.insert(child: child)
        }

        return fragment
    }

    // MARK: buildIf

    public static func buildIf(_ child: Node?) -> Node {
        if let child = child {
            return child
        } else {
            return DocumentFragment()
        }
    }

    // MARK: buildEither

    public static func buildEither(first: Node) -> Node {
        return first
    }

    public static func buildEither(second: Node) -> Node {
        return second
    }
}
