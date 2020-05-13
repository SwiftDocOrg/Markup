import libxml2
import Foundation
@_exported import DOM
@_exported import XPath

public final class Document: DOM.Document {
    public struct Properties: OptionSet {
        public var rawValue: Int32

        /// Document is XML well formed
        public static let wellFormed = Properties(XML_DOC_WELLFORMED)

        /// Document is Namespace valid
        public static let namespaceValid = Properties(XML_DOC_NSVALID)

        /// DTD validation was successful
        public static let dtdValid = Properties(XML_DOC_DTDVALID)

        /// XInclude substitution was done
        public static let performedXIncludeSubstitution = Properties(XML_DOC_XINCLUDE)

        /// Document was built using the API and not by parsing an instance
        public static let userBuilt = Properties(XML_DOC_USERBUILT)

        /// Built for internal processing
        public static let internalProcessing = Properties(XML_DOC_INTERNAL)

        init(_ xmlDocProperties: xmlDocProperties) {
            self.init(rawValue: numericCast(xmlDocProperties.rawValue))
        }

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
    }

    public var properties: Properties {
        return Properties(rawValue: xmlDoc.pointee.properties)
    }

    public var namespaceDefinitions: [Namespace] {
        return sequence(first: xmlDoc.pointee.oldNs, next: { $0.pointee.next }).compactMap { Namespace(rawValue: $0) }
    }

    // MARK: -

    public convenience init?(version: String? = nil) {
        guard let xmlDoc = xmlNewDoc(version) else { return nil }
        self.init(rawValue: UnsafeMutableRawPointer(xmlDoc))
    }

    // MARK: - RawRepresentable

    var xmlDoc: xmlDocPtr {
        rawValue.bindMemory(to: _xmlDoc.self, capacity: 1)
    }

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlDoc.self, capacity: 1).pointee.type == XML_DOCUMENT_NODE else { return nil }
        super.init(rawValue: rawValue)
    }

    // MARK: - CustomStringConvertible

    public override var description: String {
        var buffer: UnsafeMutablePointer<xmlChar>?
        defer { xmlFree(buffer) }

        xmlDocDumpMemoryEnc(xmlDoc, &buffer, nil, "UTF-8")

        return String(cString: buffer!)
    }
}

// MARK: - XPath

extension Document {
    public func search(xpath: XPath.Expression) -> [Element] {
        guard case .nodeSet(let nodeSet) = evaluate(xpath: xpath) else { return [] }
        return nodeSet.compactMap { Element($0) }
    }

    public func evaluate(xpath: XPath.Expression) -> XPath.Object? {
        guard let context = Context(document: self) else { return nil }
        for namespace in namespaceDefinitions {
            context.register(namespace: namespace)
        }

        guard let object = xmlXPathCompiledEval(xpath.rawValue, context.rawValue) else { return nil }
        //        defer { xmlXPathFreeObject(object) }

        return XPath.Object(rawValue: object)
    }
}

// MARK: - Builder

extension Document {
    public convenience init?(@DOMBuilder builder: () -> Node) {
        self.init()

        switch builder() {
        case let fragment as DocumentFragment & Constructable:
            for child in fragment.children {
                self.insert(child: child)
            }
        case let node:
            self.insert(child: node)
        }
    }
}
