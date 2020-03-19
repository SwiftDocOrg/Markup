import libxml2.xpath

import DOM

public final class NodeSet: RawRepresentable {
    public var rawValue: xmlNodeSetPtr

    public init(rawValue: xmlNodeSetPtr) {
        self.rawValue = rawValue
    }
}

