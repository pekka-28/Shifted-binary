<!-- examples/Using-the-tooling.md -->

# Developer tooling – Foundry

The supplied tools support three distinct tasks: moving bytes across the XML boundary, manipulating those bytes as strings in XSLT, and interpreting a particular message schema. Start with the [SBE-to-FIXML case study](../documentation/Using-shifted-binary-in-XSLT.md) for the transformation itself. This guide identifies the files and how to run them so that you do not need to inspect every source file first.

## Choose the tool

Use the following entry points:

| Task | Entry point | Input and result |
|---|---|---|
| Carry binary data in XML or recover it | [Binary XML converters](Using-the-converters.md) | Binary file to canonical shiftedBinary XML, or that XML back to the original bytes; TypeScript and C# build/run commands are included. |
| Canonicalise, expose readable characters or produce a plain display | [Mapping stylesheet](../Shifted%20binary/Shifted%20binary.xslt) | XPath `translate()` with the mapping variables described below. |
| Convert hexadecimal at an XML boundary | [Hex conversion stylesheet](../Shifted%20binary/Hex%20binary.xslt) | Hex digits to canonical shifted characters, or canonical shifted characters to uppercase hex. |
| Reproduce the trading-order example | [SBE reference archive](../documentation/references/SBE-to-FIXML-XSLT-case-study%20bis.zip) | Supplied shifted XML order to FIXML; includes the schema and full generator. |
| Configure readable Windows display | [Installation guide](../documentation/Installing-shifted-binary.md) | Three complementary fonts plus application and Windows association setup. |

The font affects display only. Conversion and transformation operate on stored characters and do not require a font.

## Use the mapping stylesheet

Import `Shifted binary.xslt` from your stylesheet, adjusting the relative path to its location. The import must precede other top-level declarations. The stylesheet supplies variables; it does not read a binary file or infer a message schema. With the value in `$value`, select the target mapping as follows:

| Expression | Result |
|---|---|
| `translate($value, $shiftedBinary, $toShiftedBinary)` | Canonical U+E100–U+E1FF representation for recognised byte-valued characters. |
| `translate($value, $shiftedBinary, $toShiftedText)` | Readable mixed representation; retains shifted controls and is no longer generally a value of the restricted canonical type. |
| `translate($value, $shiftedBinary, $toPlainText)` | Plain display; replaces unsupported controls with U+FFFD and can lose information. |

Validate canonical input with `translate($value, string($canonicalShifted), '') = ''`. The mapping operation leaves unrecognised characters unchanged; it is not itself an alphabet validator. Preserve mixed whitespace and keep carriage return shifted as U+E10D. The [position paper](../documentation/Convenient-binary-XML-encoding.pdf) explains the conversion results and type restrictions in more depth.

## Convert hexadecimal

Import `Hex binary.xslt`, which imports the mapping stylesheet itself, and bind `sb` to `urn:data-abstraction:shifted-binary`. Call the named template `sb:hex-to-shifted` with parameter `value` containing hex digits, or `sb:shifted-to-hex` with `value` containing canonical shifted characters. A named-template result is a result-tree fragment in XSLT 1.0; use `string()` to pass its text to another operation.

Hex input accepts either letter case and surrounding XML whitespace. It rejects separators, invalid digits and odd digit counts. The reverse operation returns uppercase hex and rejects noncanonical input. Both accept an empty value. These templates convert representations; field interpretation still belongs to the message schema.

## Run the trading-order transformation

Extract the SBE reference archive into a working folder. Its files have the following roles:

| File | Role |
|---|---|
| `README-SBE-FIXML.md` | Original archive instructions and scope. |
| `NewOrderSingle.sbe.xml` | Binary message schema. |
| `generate-FIXML-decoder.xslt` | Full generator, applied to the schema to produce a transformation stylesheet. |
| `NewOrderSingle-to-FIXML.xslt` | Supplied generated transformation. |
| `Shifted binary.xslt` | Mapping tables imported by the generator and transformation. |
| `NewOrderSingle-shifted-message.xml` | Ready-to-run input representing the 68-byte order. |
| `NewOrderSingle-expected.fixml.xml` | Expected XML business result. |

Keep these files together so relative imports resolve. From that extracted folder, run this PowerShell command sequence with .NET's XSLT processor. It creates a fresh result file and leaves the supplied files unchanged:

```powershell
$outputPath = Join-Path $PWD 'NewOrderSingle-result.fixml.xml'
if (Test-Path -LiteralPath $outputPath) {
    throw 'Choose a fresh output filename.'
}
$transform = [System.Xml.Xsl.XslCompiledTransform]::new()
$transform.Load(
    (Join-Path $PWD 'NewOrderSingle-to-FIXML.xslt'),
    [System.Xml.Xsl.XsltSettings]::Default,
    [System.Xml.XmlUrlResolver]::new()
)
$transform.Transform(
    (Join-Path $PWD 'NewOrderSingle-shifted-message.xml'),
    $outputPath
)
```

The result is order ORD00001 for account ACCT01, buying 7 units of GEM4 at 99.610, with timestamp `2014-10-06T20:27:24.432Z` and no stop price. XML whitespace, prefixes and attribute ordering may differ between processors without changing that result.

To reproduce the stylesheet, use the same processor sequence with `generate-FIXML-decoder.xslt` as the stylesheet, `NewOrderSingle.sbe.xml` as the input and a fresh output such as `Regenerated-order.xslt`. Keep the result beside the mapping stylesheet, then use it in place of `NewOrderSingle-to-FIXML.xslt` for the message transformation.

The archive remains illustrative reference code. Its body-length and 64-bit arithmetic limitations, timestamp precision and fixed-layout scope are explained in the case study. Those limitations matter when adapting it to production messages.
