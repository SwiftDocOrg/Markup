import libxml2

import Foundation

public enum Parser {
    public struct Options: OptionSet {
        public var rawValue: Int32

        /// Relaxed parsing
        public static let relaxed = Options(HTML_PARSE_RECOVER)

        /// Do not default a doctype if not found
        public static let noDefaultDTD = Options(HTML_PARSE_NODEFDTD)

        /// Suppress errors
        public static let suppressErrors = Options(HTML_PARSE_NOERROR)

        /// Suppress warnings
        public static let suppressWarnings = Options(HTML_PARSE_NOWARNING)

        /// Pedantic error reporting
        public static let pedantic = Options(HTML_PARSE_PEDANTIC)

        /// Remove blank nodes
        public static let removeBlankNodes = Options(HTML_PARSE_NOBLANKS)

        /// Forbid network access
        public static let forbidNetworkAccess = Options(HTML_PARSE_NONET)

        /// Do not add implied html/body... elements
        public static let omitImpliedTags = Options(HTML_PARSE_NOIMPLIED)

        /// Compact small text nodes
        public static let compact = Options(HTML_PARSE_COMPACT)

        /// Ignore internal document encoding hint
        public static let ignoreDocumentEncodingHint = Options(HTML_PARSE_IGNORE_ENC)

        init(_ xmlParserOption: htmlParserOption) {
            self.init(rawValue: numericCast(xmlParserOption.rawValue))
        }

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
    }

    static func parse(_ string: String, baseURL url: URL? = nil, options: Options) throws -> xmlDocPtr? {
        return string.cString(using: .utf8)?.withUnsafeBufferPointer({
            htmlReadMemory($0.baseAddress, numericCast($0.count), url?.absoluteString, nil, options.rawValue)
        })
    }
}

extension Document {
    public convenience init?(string: String, baseURL url: URL? = nil, encoding: String.Encoding = .utf8, options: Parser.Options = [.suppressWarnings, .suppressErrors, .relaxed]) throws {
        guard let pointer = try Parser.parse(string, baseURL: url, options: options) else { return nil }
        self.init(rawValue: pointer)
    }
}

extension DocumentFragment {
    public convenience init?(string: String, options: Parser.Options = [.suppressWarnings, .suppressErrors, .relaxed]) throws {
        guard let htmlDoc = try Parser.parse(string, options: options),
            let htmlDocFragment = xmlNewDocFragment(htmlDoc)
        else { return nil }

//        defer { xmlFree(htmlDocFragment) }

        self.init(rawValue: htmlDocFragment)
    }
}


// MARK: -

fileprivate var initialization: Void = { xmlInitParser() }()
