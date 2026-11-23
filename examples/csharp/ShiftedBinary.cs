// examples/csharp/ShiftedBinary.cs
// (C) 2026 Data Abstraction (Pty) Ltd, all rights reserved.

using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;

internal static class ShiftedBinary
{
    private static int Main(string[] args)
    {
        try
        {
            if (args.Length < 3 || args.Length > 4 ||
                (args[0] != "encode" && args[0] != "decode") ||
                (args[0] == "decode" && args.Length != 3) ||
                (args.Length == 4 && args[3] != "utf-16le" && args[3] != "utf-8"))
                throw new ArgumentException("Usage: ShiftedBinary encode input.bin output.xml [utf-16le|utf-8]\n       ShiftedBinary decode input.xml output.bin");
            byte[] output;
            if (args[0] == "encode")
            {
                var value = new string(File.ReadAllBytes(args[1]).Select(b => (char)(0xe100 + b)).ToArray());
                using var buffer = new MemoryStream();
                var settings = new XmlWriterSettings {
                    Encoding = args.Length == 4 && args[3] == "utf-8"
                        ? new UTF8Encoding(false, true) : new UnicodeEncoding(false, true, true),
                    Indent = false
                };
                using (var writer = XmlWriter.Create(buffer, settings))
                    new XDocument(new XElement("message", new XElement("binary", value))).Save(writer);
                output = buffer.ToArray();
            }
            else
            {
                using var reader = XmlReader.Create(args[1], new XmlReaderSettings {
                    DtdProcessing = DtdProcessing.Prohibit, XmlResolver = null,
                    IgnoreWhitespace = false
                });
                var doc = XDocument.Load(reader, LoadOptions.PreserveWhitespace);
                var root = doc.Root;
                if (root == null || root.Name != "message" || root.HasAttributes ||
                    root.Elements().Count() != 1 || root.Elements().Single().Name != "binary" ||
                    root.Nodes().OfType<XText>().Any(t => !string.IsNullOrWhiteSpace(t.Value)))
                    throw new FormatException("Expected <message><binary>value</binary></message>");
                var binary = root.Element("binary")!;
                if (binary.HasAttributes || binary.Nodes().Any(n => n is not XText))
                    throw new FormatException("The binary element must contain text only");
                output = binary.Value.Select(c => c >= 0xe100 && c <= 0xe1ff
                    ? (byte)(c - 0xe100) : throw new FormatException("Non-canonical character in binary value")).ToArray();
            }
            // Validate the complete input before opening the destination. Never overwrite.
            using var destination = new FileStream(args[2], FileMode.CreateNew, FileAccess.Write);
            destination.Write(output);
            return 0;
        }
        catch (Exception error) { Console.Error.WriteLine(error.Message); return 1; }
    }
}
