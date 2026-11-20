// examples/typescript/ShiftedBinary.ts
// (C) 2026 Data Abstraction (Pty) Ltd, all rights reserved.

import { readFileSync, writeFileSync } from 'node:fs';
import { DOMParser } from '@xmldom/xmldom';

// Contract: <message><binary>canonical shifted value</binary></message>.
// No namespace; exactly one binary element; no other elements or attributes.
// Output creation is exclusive: an existing file is never overwritten.
function decodeXml(bytes: Buffer): string {
  let encoding = 'utf-8';
  if ((bytes[0] === 0xff && bytes[1] === 0xfe) ||
      (bytes[0] === 0x3c && bytes[1] === 0)) encoding = 'utf-16le';
  else if ((bytes[0] === 0xfe && bytes[1] === 0xff) ||
           (bytes[0] === 0 && bytes[1] === 0x3c)) encoding = 'utf-16be';
  const xml = new TextDecoder(encoding, { fatal: true }).decode(bytes);
  const declared = /^<\?xml\s[^?]*\bencoding\s*=\s*['"]([^'"]+)['"]/i.exec(xml)?.[1]?.toLowerCase();
  if (declared && declared !== encoding && !(declared === 'utf-16' && encoding.startsWith('utf-16')))
    throw new Error('XML declaration disagrees with file encoding or uses an unsupported encoding');
  return xml;
}

export function readBinary(xml: string): Buffer {
  // DTDs and custom entities are not part of this interchange format.
  if (/<!DOCTYPE/i.test(xml)) throw new Error('DTDs are not supported');
  const doc = new DOMParser({ onError: (_level, message) => { throw new Error(message); } })
    .parseFromString(xml, 'application/xml');
  const root = doc.documentElement;
  if (!root || root.tagName !== 'message' || root.namespaceURI || root.attributes.length)
    throw new Error('Expected an unqualified message element without attributes');
  const children = Array.from(root.childNodes);
  const elements = children.filter(n => n.nodeType === 1);
  if (elements.length !== 1 || elements[0]!.nodeName !== 'binary' ||
      children.some(n => (n.nodeType === 3 || n.nodeType === 4) && /\S/.test(n.nodeValue ?? '')))
    throw new Error('Expected exactly one binary element');
  const binary = root.getElementsByTagName('binary')[0]!;
  if (binary.attributes.length || Array.from(binary.childNodes).some(n => n.nodeType !== 3 && n.nodeType !== 4))
    throw new Error('The binary element must contain text only');
  return Buffer.from(Array.from(binary.textContent ?? '', c => {
    const value = c.codePointAt(0)! - 0xe100;
    if (value < 0 || value > 255) throw new Error('Non-canonical character in binary value');
    return value;
  }));
}

function main(): void {
  const [operation, input, output, encoding = 'utf-16le', ...extra] = process.argv.slice(2);
  if (!input || !output || extra.length || !['encode', 'decode'].includes(operation ?? '') ||
      !['utf-16le', 'utf-8'].includes(encoding) || (operation === 'decode' && process.argv.length !== 5))
    throw new Error('Usage: ShiftedBinary encode input.bin output.xml [utf-16le|utf-8]\n       ShiftedBinary decode input.xml output.bin');
  const source = readFileSync(input);
  if (operation === 'decode') {
    writeFileSync(output, readBinary(decodeXml(source)), { flag: 'wx' });
  } else {
    const value = Array.from(source, b => String.fromCharCode(0xe100 + b)).join('');
    const xml = `<?xml version="1.0" encoding="${encoding === 'utf-16le' ? 'UTF-16' : 'UTF-8'}"?>\n<message><binary>${value}</binary></message>\n`;
    const bytes = encoding === 'utf-16le'
      ? Buffer.concat([Buffer.from([0xff, 0xfe]), Buffer.from(xml, 'utf16le')]) : Buffer.from(xml, 'utf8');
    writeFileSync(output, bytes, { flag: 'wx' });
  }
}
try { main(); } catch (error) {
  console.error(error instanceof Error ? error.message : String(error)); process.exitCode = 1;
}
