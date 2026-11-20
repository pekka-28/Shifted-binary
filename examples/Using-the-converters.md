<!-- examples/Using-the-converters.md -->

# Binary XML converters – Foundry

The TypeScript and C# programs convert an arbitrary binary file to a message containing canonical shifted binary, and recover the original bytes from that message:

```xml
<message><binary></binary></message>
```

This example carries `48 65 6C 6C 6F` (`Hello`). Both programs write UTF-16LE with a byte-order mark by default; choose `utf-8` for UTF-8 output without a byte-order mark. The decoder recognises UTF-8 and UTF-16 XML, including character references and CDATA. It validates the whole input before creating the output and refuses to overwrite an existing file.

## TypeScript

Install Node.js and npm. From `examples/typescript`, run:

```text
npm install
npm run build
node build/ShiftedBinary.js encode input.bin message.xml
node build/ShiftedBinary.js decode message.xml recovered.bin
node build/ShiftedBinary.js encode input.bin message-utf8.xml utf-8
```

The XML parser is [@xmldom/xmldom](https://github.com/xmldom/xmldom); the supplied package file specifies its version. TypeScript uses strict type checking.

## C#

Install the .NET 8 SDK or a compatible later SDK. From `examples/csharp`, run:

```text
dotnet run -- encode input.bin message.xml
dotnet run -- decode message.xml recovered.bin
dotnet run -- encode input.bin message-utf8.xml utf-8
```

## Message contract

These examples accept an unqualified `message` root with exactly one unqualified `binary` child and no attributes. Its value must consist entirely of U+E100–U+E1FF; an empty value represents an empty binary file. DTDs, nested content and non-canonical characters are rejected. XML formatting whitespace around the `binary` element is allowed; whitespace inside the value is data and is therefore rejected unless shifted.

The programs read complete files into memory. For an application with its own message structure, adapt the element selection to that schema and apply the same value conversion to each binary element. Use the XSLT mappings to canonicalise mixed shifted text before decoding it with these examples.

Only source and build configuration are supplied; build outputs and downloaded dependencies are not part of the distribution.
