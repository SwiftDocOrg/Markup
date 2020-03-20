import libxml2.xpath

import DOM

public final class NodeSet: RawRepresentable, Hashable {
    public var rawValue: xmlNodeSetPtr

    public init(rawValue: xmlNodeSetPtr) {
        self.rawValue = rawValue
    }
}

