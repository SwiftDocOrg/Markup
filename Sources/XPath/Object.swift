import libxml2.xpath

public enum Object {
    case nodeSet(NodeSet)
    case boolean(Bool)
    case number(Double)
    case string(String)
    case undefined

    public init?(rawValue: xmlXPathObjectPtr) {
        switch rawValue.pointee.type {
        case XPATH_NODESET:
            self = .nodeSet(NodeSet(rawValue: rawValue.pointee.nodesetval))
        case XPATH_BOOLEAN:
            self = .boolean(rawValue.pointee.boolval == 1) // TODO: formalize in extension
        case XPATH_NUMBER:
            self = .number(rawValue.pointee.floatval)
        case XPATH_STRING:
            self = .string(String(cString: rawValue.pointee.stringval))
        default:
            self = .undefined
        }
    }

//    public var XPATH_POINT: xmlXPathObjectType { get }
//    public var XPATH_RANGE: xmlXPathObjectType { get }
//    public var XPATH_LOCATIONSET: xmlXPathObjectType { get }
//    public var XPATH_USERS: xmlXPathObjectType { get }
//    public var XPATH_XSLT_TREE: xmlXPathObjectType { get } /* An XSLT value tree, non modifiable */
}
