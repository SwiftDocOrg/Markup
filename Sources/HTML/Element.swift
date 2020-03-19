import libxml2
@_exported import DOM

// MARK: - CustomStringConvertible

extension Element: CustomStringConvertible {
    public var description: String {
        let buffer = xmlBufferCreate()
        defer { xmlBufferFree(buffer) }

        htmlNodeDump(buffer, xmlNode.pointee.doc, xmlNode)

        return String(cString: xmlBufferContent(buffer))
    }
}
