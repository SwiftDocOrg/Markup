import libxml2

extension String {
    public init?(xmlString: UnsafeMutablePointer<xmlChar>!, freeWhenDone: Bool = true) {
        guard let xmlString = xmlString else { return nil }
        defer {
            if freeWhenDone {
                xmlFree(xmlString)
            }
        }

        self.init(cString: xmlString)
    }
}
