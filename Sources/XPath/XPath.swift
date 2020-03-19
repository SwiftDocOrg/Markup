import libxml2.xpath

fileprivate var initialization: Void = { xmlXPathInit() }()

public enum Error: Swift.Error {
    case unknown
}
