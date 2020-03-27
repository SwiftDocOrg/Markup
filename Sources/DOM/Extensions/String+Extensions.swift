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

// MARK: -

extension String.Encoding {
    init(ianaCharacterSetName: String) {
        switch ianaCharacterSetName {
        case "us-ascii": self = .ascii
        case "iso-2022-jp": self = .iso2022JP
        case "iso-8859-1": self = .isoLatin1
        case "iso-8859-2": self = .isoLatin2
        case "euc-jp": self = .japaneseEUC
        case "macintosh": self = .macOSRoman
        case "x-nextstep": self = .nextstep
        case "cp932": self = .shiftJIS
        case "x-mac-symbol": self = .symbol
        case "utf-8": self = .utf8
        case "utf-16": self = .utf16
        case "utf-16be": self = .utf16BigEndian
        case "utf-32": self = .utf32
        case "utf-32be": self = .utf32BigEndian
        case "utf-32le": self = .utf32LittleEndian
        case "windows-1250": self = .windowsCP1250
        case "windows-1251": self = .windowsCP1251
        case "windows-1252": self = .windowsCP1252
        case "windows-1253": self = .windowsCP1253
        case "windows-1254": self = .windowsCP1254
        default: self = .utf8
        }
    }
}
