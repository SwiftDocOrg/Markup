Sources/HTML/HTMLTags.swift: Resources/xhtml11.xsd

%.swift: %.swift.gyb
	@gyb --line-directive '' -o $@ $<

.PHONY:
clean:
	@rm Sources/HTML/HTMLTags.swift
