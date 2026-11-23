<!-- documentation/Shifted-binary-reader-guide.md -->

# Shifted binary reader guide – Foundry

```xml
<message><text>Hello, world!&#x0A;</text></message>
```

Open this XML message in your usual editor and its content is immediately recognisable: a greeting followed by a line feed, written here as `&#x0A;`. You can read it, search it and copy it into a stylesheet. Carrying arbitrary data in the same message is less convenient. XML forbids characters such as NUL, so arbitrary bytes cannot simply be treated as text. Base64, hexadecimal and decimal arrays can carry them, but introduce extra work when you need to inspect or manipulate the data.

Shifted binary offers another approach: represent those bytes with XML-safe Unicode code points and display their values in hex using a font. Developers and application administrators can then open the document in familiar tools—Notepad, Word, Visual Studio, VS Code or browser fields—and work with its binary fragments as text. This guide shows the representation beneath that display; a hex editor is not required.

## Start with a greeting

Consider `Hello, world!\n`, where `\n` means one line-feed byte, `0A`, rather than a backslash followed by “n”. The letters are familiar, but the terminating byte is normally invisible. *Table A greeting* shows the same fourteen bytes in canonical shifted form. The final column contains actual shifted code points; without the font, use the hex column to read their values.

*Table A greeting*

| Source bytes, hexadecimal | Shifted UTF-16 code units, hexadecimal | Shifted display |
|---|---|---|
| `48 65 6C 6C 6F 2C 20 77 6F 72 6C 64 21 0A` | `E148 E165 E16C E16C E16F E12C E120 E177 E16F E172 E16C E164 E121 E10A` | `` |

The greeting contains fourteen input bytes including the line feed. Shifting changes the value `48` to U+E148 and `0A` to U+E10A. Each displayed hex pair is a glyph, not two stored digits. The middle column shows the resulting 16-bit code units; for example, E148 is stored as bytes `48 E1` in UTF-16LE.

## When the message contains controls

A simple protocol might frame `Hello` with Start of Text (`02`) and End of Text (`03`). Those controls cannot appear directly in XML 1.0, even as numeric character references. *Table A framed message* shows how they can remain visible within the document instead.

*Table A framed message*

| Source bytes, hexadecimal | Shifted UTF-16 code units, hexadecimal | Shifted display |
|---|---|---|
| `02 48 65 6C 6C 6F 03` | `E102 E148 E165 E16C E16C E16F E103` | `` |

The XML can contain the shifted value directly:

```xml
<message><binary></binary></message>
```

Its byte meaning is `02 48 65 6C 6C 6F 03`. Opening the document in an editor configured with the font reveals those values in place. Selecting and copying a fragment retains its code points, ready for a search or a stylesheet literal.

## The representation and its cost

*The Unicode Standard* [1] defines the text representation beneath the XML. A code point is a position in the Unicode code space; an encoding such as UTF-8 or UTF-16 represents it in bytes, and a font supplies a glyph for displayable characters. XML markup and the values it carries both use that underlying text representation.

The **Private Use Area (PUA)** is a named block, U+E000–U+F8FF, in the **Unicode Basic Multilingual Plane**. *The Unicode Standard*, chapter 23 [6], reserves it for meanings agreed between applications rather than assigned by Unicode. This is what makes it suitable for the shiftedBinary convention.

Canonical shifted binary maps an input byte value `b`, from 00 to FF, to `U+E100 + b`. The resulting range U+E100–U+E1FF lies inside the PUA. It is a privately agreed mapping, not a Unicode-assigned binary alphabet.

Each shifted value occupies two bytes when encoded as UTF-16, or three as UTF-8. Distinguish the input byte value from the bytes used to store its Unicode representation. *Table Payload costs* compares the alternatives for a large binary value, excluding XML markup and allocation overhead.

*Table Payload costs*

| Representation | UTF-8 bytes per source byte | UTF-16 bytes per source byte |
|---|---:|---:|
| Base64 | About 1.33 | About 2.67 |
| Hexadecimal | 2 | 4 |
| Decimal array¹ | About 3.57 | About 7.14 |
| Canonical shifted binary | 3 | 2 |

¹Unpadded decimal values, one separator between values, uniformly distributed bytes.

UTF-16 suits documents dominated by shifted content. UTF-8 can be smaller when shifted data is only a fragment: with otherwise ASCII content, the break-even point is half the document's code points. Non-ASCII scripts change that balance. In-memory costs follow the runtime, not simply the operating system; .NET strings use UTF-16 on Windows and other platforms.

The processing benefit is that every shifted value remains a separate, searchable string element. A fragment can be found, sliced or substituted without decoding base64 groups, checking hexadecimal pair alignment or parsing decimal tokens. All these representations can be passed as whole string parameters; shifted binary simplifies working with their byte content. *Using shifted binary in XSLT – Foundry* [2] shows how.

Hexadecimal and Base64 carry binary data, but neither gives ordinary string search the same byte-boundary semantics. In hexBinary text, `contains('1ABC', 'AB')` is true although the bytes are `1A BC`. A general aligned search in XSLT 1.0 needs extra logic, typically a recursive template that finds a candidate, checks its alignment and continues after an unaligned occurrence. Canonical shifted binary needs no such search machinery: every character boundary is a byte boundary.

Base64 characters encode groups of six bits rather than individual bytes. An independently encoded fragment is therefore not generally searchable in the encoded whole using `contains()`; its encoding depends on its alignment within the surrounding bytes. Search requires decoding or equivalent encoding-aware handling. These are processing trade-offs alongside the storage costs in *Table Payload costs*.

## Making it visible

*Convenient binary XML encoding* [3] references the Unicode proposal *Terminal Graphics for Unicode* [7] as background to representing byte values visibly. The XML proposal brings representation and presentation together: binary values should remain usable in text documents and be recognisable when those documents are opened. Its private-use mapping provides the starting point for this implementation; it does not imply that Unicode has standardised shifted binary.

Foundry Shifted binary gives each shifted code point a glyph showing its byte value in hex. The font changes what the reader sees, not the message. It is installed on development and application-management machines; recipients do not need it merely to preserve or process the data.

Applications differ in how they select a font for a code point missing from the surrounding typeface. *Installing shifted binary – Foundry* [4] explains the three font files, application settings and supported tools. The related *Barcode fonts – Foundry* [5] also uses fonts to make data visible, with a separate encoding purpose.

## References

1. *The Unicode Standard, version 17.0, chapter 2: General Structure*, [Unicode specification](https://www.unicode.org/versions/Unicode17.0.0/core-spec/chapter-2/), Unicode Consortium, 2025.
2. *Using shifted binary in XSLT – Foundry*, [SBE-to-FIXML case study](Using-shifted-binary-in-XSLT.md), Data Abstraction (Pty) Ltd, 16 November 2026.
3. *Convenient binary XML encoding (DA-TR-351)*, [revised XML encoding proposal](Convenient-binary-XML-encoding.pdf), Data Abstraction (Pty) Ltd, revised 17 November 2026.
4. *Installing shifted binary – Foundry*, [installation guide](Installing-shifted-binary.md), Data Abstraction (Pty) Ltd, 16 November 2026.
5. *Barcode fonts – Foundry*, [Foundry repository](https://github.com/pekka-28/Foundry), Data Abstraction (Pty) Ltd, 16 November 2026.
6. *The Unicode Standard, version 17.0, chapter 23: Special Areas and Format Characters*, [Private Use Area definition](https://www.unicode.org/versions/Unicode17.0.0/core-spec/chapter-23/), Unicode Consortium, 2025.
7. *Terminal Graphics for Unicode*, [Unicode proposal cited in Convenient binary XML encoding](https://www.columbia.edu/kermit/ftp/ucsterminal/ucsterminal_02.txt), Frank da Cruz, Kermit Project, Columbia University, October 1998.
