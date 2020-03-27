import libxml2

fileprivate var initialization: Void = { xmlXPathInit() }()

public enum Error: Swift.Error {
    case unknown
}
