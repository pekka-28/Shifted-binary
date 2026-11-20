<!-- README.md -->

# Foundry Shifted binary

Binary data can travel inside XML, but working with its contents is less convenient than working with ordinary text. Base64 obscures individual bytes, while hexadecimal represents each byte with two characters, so a string search can match across byte boundaries.

Shifted binary represents each byte as one XML-safe Unicode character. Every character boundary is therefore a byte boundary: ordinary string operations can find, extract and replace binary fragments without first decoding the whole value. It is intended for developers and application administrators who need to inspect and manipulate binary messages using familiar XML tools.

The mapping is simple: byte `00` becomes U+E100, `41` becomes U+E141, and `FF` becomes U+E1FF. This is a private-use convention agreed between applications. It preserves byte values without interpreting their meaning.

Foundry’s companion fonts make those characters readable by displaying each one as its two-digit hexadecimal value. The displayed `41` is one character, not two stored digits. The fonts supply only the 256 shifted-byte characters; surrounding text keeps its normal typeface. A font is needed to see the hex display, but not to preserve or process the data.

This representation trades storage space for convenient processing. Each source byte occupies three bytes in UTF-8 or two in UTF-16. The [reader guide](documentation/Shifted-binary-reader-guide.md) explains the mapping, illustrates it with short messages, and compares it with Base64 and hexadecimal.

## Follow a message through the tools

The [SBE-to-FIXML case study](documentation/Using-shifted-binary-in-XSLT.md) shows the approach in use. A trading order encoded using Simple Binary Encoding is carried in XML as shifted binary. An XSLT stylesheet extracts its fields, interprets their values and produces FIXML.

The distinction matters: shifted binary makes the bytes accessible to string operations; the message schema supplies their meaning. The example includes its input, transformation, expected output and reference archive so that you can follow and reproduce the process. Its implementation limits are documented in the case study.

To try it:

1. Download and extract this repository, keeping its folder structure intact.
2. Follow the [installation guide](documentation/Installing-shifted-binary.md) to display shifted values in your editor or document viewer. Opening the extracted folder as a VS Code workspace applies the supplied Markdown preview settings.
3. Work through the [case study](documentation/Using-shifted-binary-in-XSLT.md). The [developer tooling guide](examples/Using-the-tooling.md) identifies the supplied files and gives the commands for running the example.

To use your own data, start with the [TypeScript and C# converters](examples/Using-the-converters.md). They convert binary files to canonical shifted-binary XML and recover the original bytes. The supplied mapping stylesheets support further XML and XSLT processing.

## Explore further

The [complete contents](CONTENTS.md) lists the fonts, tools and documents. The principal guides are available as Markdown, HTML, PDF and editable Word files.

For the underlying proposal and type specification, read *Convenient binary XML encoding*, available in [PDF](documentation/Convenient-binary-XML-encoding.pdf) and [Word](documentation/Convenient-binary-XML-encoding.docx).

## Licence and integrity

The fonts retain the [PolyForm Noncommercial licence](fonts/LICENSE-Foundry.txt) and [Data Abstraction copyright and commercial-licensing notice](fonts/COPYRIGHT-Foundry.txt). Source files retain their own notices.

The [manifest](manifest.json) supplies SHA-256 hashes for the packaged files. [Outline provenance](fonts/outline-source.json) records the Foundry source used to generate the hexadecimal lettering.
