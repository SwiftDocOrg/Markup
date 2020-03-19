import libxml2

import DOM
import XPath

extension XPath.NodeSet: RandomAccessCollection {
    public subscript(position: Int) -> Node? {
        precondition(position >= startIndex && position <= endIndex)
        guard let rawValue = rawValue.pointee.nodeTab[position] else { return nil }
        return Node.construct(with: rawValue)
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return Int(rawValue.pointee.nodeNr)
    }
}
