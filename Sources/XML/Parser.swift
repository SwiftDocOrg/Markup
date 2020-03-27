import Foundation

import libxml2

public enum Parser {
    public struct Options: OptionSet {
        public var rawValue: Int32

        /// Relaxed parser
        public static let relaxed = Options(XML_PARSE_RECOVER)

        /// Substitute entities.
        public static let substituteEntities = Options(XML_PARSE_NOENT)

        /// Load external subset
        public static let loadDTDExternalSubset = Options(XML_PARSE_DTDLOAD)

        /// Use default DTD attributes
        public static let useDefaultDTDAttributes = Options(XML_PARSE_DTDATTR)

        /// Validate with the DTD
        public static let validateDTD = Options(XML_PARSE_DTDVALID)

        /// Suppress errors
        public static let suppressErrors = Options(XML_PARSE_NOERROR)

        /// Suppress warnings
        public static let suppressWarnings = Options(XML_PARSE_NOWARNING)

        /// Pedantic error reporting
        public static let pedantic = Options(XML_PARSE_PEDANTIC)

        /// Remove blank nodes
        public static let removeBlankNodes = Options(XML_PARSE_NOBLANKS)

        /// Use the SAX1 interface
        public static let useSAX1Interface = Options(XML_PARSE_SAX1)

        /// Implement XInclude substituion
        public static let implementXIncludeSubstitution = Options(XML_PARSE_XINCLUDE)

        /// Forbid network access
        public static let forbidNetworkAccess = Options(XML_PARSE_NONET)

        /// Do not reuse the context dictionary
        public static let noContextDictionaryReuse = Options(XML_PARSE_NODICT)

        /// Remove redundant namespaces declarations
        public static let removeRedundantNamespaceDeclarations = Options(XML_PARSE_NSCLEAN)

        /// Merge CDATA as text nodes
        public static let mergeCDATA = Options(XML_PARSE_NOCDATA)

        /// Do not generate XINCLUDE START/END nodes
        public static let noXIncludeDelimiterNodes = Options(XML_PARSE_NOXINCNODE)

        /// Compact small text nodes.
        /// - Warning: Modification of the resulting tree isn't allowed
        public static let compact = Options(XML_PARSE_COMPACT)

        /// Do not fixup XINCLUDE xml:base uris
        public static let noXIncludeBaseURIFixup = Options(XML_PARSE_NOBASEFIX)

        /// Relax any hardcoded limit from the parser
        public static let relaxHardcodedLimits = Options(XML_PARSE_HUGE)

        /// Ignore internal document encoding hint
        public static let ignoreEncodingHint = Options(XML_PARSE_IGNORE_ENC)

        /// Store big lines numbers in text PSVI field
        public static let bigLineNumbers = Options(XML_PARSE_BIG_LINES)

        init(_ xmlParserOption: xmlParserOption) {
            self.init(rawValue: numericCast(xmlParserOption.rawValue))
        }

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
    }

    static func parse(_ string: String, baseURL url: URL? = nil, options: Options) throws -> xmlDocPtr? {
        return string.cString(using: .utf8)?.withUnsafeBufferPointer({
            xmlReadMemory($0.baseAddress, numericCast($0.count), url?.absoluteString, nil, options.rawValue)
        })
    }
}

extension Document {
    public convenience init?(string: String, baseURL url: URL? = nil, encoding: String.Encoding = .utf8, options: Parser.Options = [.suppressWarnings, .suppressErrors, .relaxed]) throws {
        guard let xmlDoc = try Parser.parse(string, baseURL: url, options: options) else { return nil }
        self.init(rawValue: xmlDoc)
    }
}

extension DocumentFragment {
    public convenience init?(string: String, options: Parser.Options = [.suppressWarnings, .suppressErrors, .relaxed]) throws {
        guard let xmlDoc = try Parser.parse(string, options: options),
            let xmlDocFragment = xmlNewDocFragment(xmlDoc)
            else { return nil }

//        defer { xmlFree(xmlDocFragment) }

        self.init(rawValue: xmlDocFragment)
    }
}
// MARK: -

fileprivate var initialization: Void = { xmlInitParser() }()
