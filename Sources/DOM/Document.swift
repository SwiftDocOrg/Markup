import libxml2
import Foundation

open class Document: Node {
    public enum CloningBehavior: Int32 {
        case `default` = 0

        /// If recursive, the content tree will be copied too as well as DTD, namespaces and entities.
        case recursive = 1
    }

    public var type: DocumentType? {
        return DocumentType(rawValue: xmlGetIntSubset(xmlDoc))
    }
    
    public var version: String? {
        return String(cString: xmlDoc.pointee.version)
    }
    
    public var encoding: String.Encoding {
        let ianaCharacterSetName = String(cString: xmlDoc.pointee.encoding)
        return String.Encoding(ianaCharacterSetName: ianaCharacterSetName)
    }

    public var root: Element? {
        get {
            guard let rawValue = xmlDocGetRootElement(xmlDoc) else { return nil }
            return Element(rawValue: rawValue)
        }

        set {
            if let newValue = newValue {
                xmlDocSetRootElement(xmlDoc, newValue.xmlNode)
            } else {
                root?.unlink()
            }
        }
    }

    func clone(behavior: CloningBehavior = .recursive) throws -> Self {
        guard let rawValue = xmlCopyDoc(xmlDoc, behavior.rawValue) else { throw Error.unknown }
        return Self(rawValue: UnsafeMutableRawPointer(rawValue))!
    }

    // MARK: -

    var xmlDoc: xmlDocPtr {
        rawValue.bindMemory(to: _xmlDoc.self, capacity: 1)
    }
}
