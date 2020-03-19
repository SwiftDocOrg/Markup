import libxml2

public final class Namespace: RawRepresentable {
    public enum Kind: Hashable {
        case local
        case global
    }

    public var context: Document? {
        return Document(rawValue: rawValue.pointee.context)
    }

    public var uri: String? {
        return String(cString: self.rawValue.pointee.href)
    }

    public var prefix: String? {
        return String(cString: self.rawValue.pointee.prefix)
    }

    // MARK: - RawRepresentable

    public var rawValue: xmlNsPtr

    public required init(rawValue: xmlNsPtr) {
        self.rawValue = rawValue
    }
}

// MARK: -

extension Namespace.Kind: RawRepresentable {
    public typealias RawValue = xmlNsType

    public init?(rawValue: xmlNsType) {
        switch rawValue {
        case XML_NAMESPACE_DECL:
            self = .local
        default:
            self = .global
        }
    }

    public var rawValue: xmlNsType {
        return self == .local ? XML_NAMESPACE_DECL : xmlNsType(rawValue: 0)
    }
}
