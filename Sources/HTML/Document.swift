import libxml2
import Foundation
@_exported import DOM
@_exported import XPath

public final class Document: DOM.Document {
    public var head: Element? {
        get {
            return root?.firstChildElement(named: "head")
        }

        set {
            guard let root = root else { return }
            if let newValue = newValue {
                if let oldValue = head {
                    oldValue.replace(with: newValue)
                } else {
                    root.insert(child: newValue)
                }
            } else {
                head?.remove()
            }
        }
    }

    public var body: Element? {
        get {
            return root?.firstChildElement(named: "body")
        }

        set {
            guard let root = root else { return }
            if let newValue = newValue {
                if let oldValue = body {
                    oldValue.replace(with: newValue)
                } else {
                    root.insert(child: newValue)
                }
            } else {
                body?.remove()
            }
        }
    }

    public var title: String? {
        get {
            return head?.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        set {
            head?.content = newValue
        }
    }

    // MARK: -

    public convenience init?() {
        guard let xmlDoc = htmlNewDocNoDtD(nil, nil) else { return nil }
        self.init(rawValue: UnsafeMutableRawPointer(xmlDoc))!
    }

    // MARK: - RawRepresentable

    var htmlDoc: htmlDocPtr {
        rawValue.bindMemory(to: _xmlDoc.self, capacity: 1)
    }

    public required init?(rawValue: UnsafeMutableRawPointer) {
        guard rawValue.bindMemory(to: _xmlDoc.self, capacity: 1).pointee.type == XML_HTML_DOCUMENT_NODE else { return nil }
        super.init(rawValue: rawValue)
    }

    // MARK: - CustomStringConvertible

    public override var description: String {
        let buffer = xmlBufferCreate()
        defer { xmlBufferFree(buffer) }

        let output = xmlOutputBufferCreateBuffer(buffer, nil)
        defer { xmlOutputBufferClose(output) }

        htmlDocContentDumpFormatOutput(output, htmlDoc, nil, 0)

        return String(cString: xmlOutputBufferGetContent(output))
    }
}

// MARK: - XPath

extension Document {
    public func search(xpath: String) -> [Element] {
        guard case .nodeSet(let nodeSet) = evaluate(xpath: xpath) else { return [] }
        return nodeSet.compactMap { Element($0) }
    }

    public func evaluate(xpath: String) -> XPath.Object? {
        guard let context = xmlXPathNewContext(htmlDoc) else { return nil }
        defer { xmlXPathFreeContext(context) }

        guard let object = xmlXPathEvalExpression(xpath, context) else { return nil }
//        defer { xmlXPathFreeObject(object) }

        return XPath.Object(rawValue: object)
    }
}

// MARK: - Builder

extension Document {
    public convenience init?(@DOMBuilder builder: () -> Node) {
        self.init()

        switch builder() {
        case let fragment as DocumentFragment:
            for child in fragment.children {
                self.insert(child: child)
            }
        case let node:
            self.insert(child: node)
        }
    }
}
