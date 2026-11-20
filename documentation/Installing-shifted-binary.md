<!-- documentation/Installing-shifted-binary.md -->

# Installing shifted binary – Foundry

Opening a shiftedBinary message should reveal its byte values in the editor you already use. The data is Unicode text; readable presentation requires a font that draws those code points and a rendering system that supplies it for missing glyphs.

This guide is for developers and administrators setting up Windows machines. *Shifted binary reader guide – Foundry* [1] introduces the representation proposed in *Convenient binary XML encoding* [2]. The font is needed for readable display, not for preserving the data.

## Why three fonts?

Windows applications use different text-rendering systems. A font that works when selected directly does not necessarily work as a substitute for missing glyphs in another typeface. *Table Font choices* explains the files produced to support those paths; all show the same byte values.

*Table Font choices*

| Family and file | Why it exists |
|---|---|
| **Foundry Shifted binary** — [OpenType font](../fonts/Foundry-ShiftedBinary.otf) | The main font for direct selection and embedded browser/document presentation |
| **Foundry Shifted binary GDI** — [TrueType font](../fonts/Foundry-ShiftedBinaryGDI.ttf) | The full font in TrueType form for direct selection in applications using Windows GDI |
| **Foundry Shifted binary Fallback** — [TrueType fallback font](../fonts/Foundry-ShiftedBinaryFallback.ttf) | Only the 256 shifted glyphs, with metrics suited to Windows font associations; supplies those glyphs while the surrounding typeface supplies ordinary text |

All three typefaces map only U+E100–U+E1FF: the 256 shifted-byte values. Their hexadecimal lettering comes from the original Foundry outlines. They contain no ordinary text glyphs; the required `.notdef` is empty and unmapped. Version 1.500 uses the current Foundry-alpha.ts source. Exact coverage and browser rendering are checked; earlier native-application results below describe the previous version.

“Font fallback” means selecting another font when the requested typeface has no glyph for a code point. The Fallback font serves that role. Its restricted character coverage lets it take priority for shifted values without replacing the surrounding typeface's letters or punctuation. Installing a font does not configure Windows font linking automatically.

## Configure the application

**For the complete Windows setup described here, install all three supplied font files.** They cover different rendering paths: the main OpenType font provides direct and document rendering, the GDI TrueType companion provides direct rendering in legacy applications, and the Fallback TrueType font supplies the private-use glyphs through editor fallback, GDI font linking and EUDC associations. Each application uses the path appropriate to its renderer; installing one file does not configure all of these paths.

Font installation and font resolution are separate steps. After installing the files, configure the editor font lists and the Windows associations described below. The registry-file generator associates the **Fallback** font with both GDI linking and EUDC; it does not use the full GDI companion for those associations. A machine using only a particular application may need a subset, but installing the complete set is the documented setup for the supported Windows tools.

Open the required font file in Windows and choose **Install**. Machine-wide associations require **Install for all users** and administrator rights. Restart applications that cache font lists. Keep the supplied [Foundry font licence](../fonts/LICENSE-Foundry.txt) and [copyright notice](../fonts/COPYRIGHT-Foundry.txt).

In VS Code Settings JSON, include the Fallback family with the preferred editor and terminal fonts. These settings are independent:

```json
{
  "editor.fontFamily": "'Foundry Shifted binary Fallback', Consolas, monospace",
  "terminal.integrated.fontFamily": "'Foundry Shifted binary Fallback', Consolas, monospace"
}
```

In Visual Studio, use **Tools → Options → Environment → Fonts and Colors → Text Editor**, with a composite family such as `Cascadia Code, Foundry Shifted binary Fallback`.

VS Code's Markdown preview has its own font selection. This repository includes a `markdown.styles` setting and a preview stylesheet that loads the Fallback font for U+E100–U+E1FF, including inline examples and code blocks. Open the repository as the workspace to use that setup. The Markdown source editor uses the installed Fallback family. After changing preview styles, run **Markdown: Refresh Preview** from the Command Palette.

For browser fields, supply the Fallback font through `@font-face`, limit it to `unicode-range: U+E100-E1FF`, and put it first in the field's CSS font list. The normal typeface then supplies the remaining characters.

## Configure Windows font associations

**Windows font associations are a separate setup step.** Install **Foundry Shifted binary Fallback** for all users, then run the supplied [registry-file generator](../tools/Export-FontAssociations.ps1) on the destination machine, signed in as the user who will use the font:

```powershell
powershell -NoProfile -File .\tools\Export-FontAssociations.ps1
```

The script creates `Install-Foundry-fallback.reg` and `Restore-font-associations.reg` in `.cache/font-associations`. It reads the existing associations without changing them. Double-click `Install-Foundry-fallback.reg`, accept the administrator prompt, and confirm Registry Editor's import. Sign out and back in. To undo the update, double-click `Restore-font-associations.reg`, confirm its import, and sign out and back in again. Keep the pair together: the restore file contains the settings that existed when the update was generated. Generate fresh files on each destination machine: registry imports replace complete font-link lists, so these files include that machine's existing entries. Regenerate them if associations change before import.

The update adds the Fallback font to the `Microsoft Sans Serif` and `MS Shell Dlg` lists under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink`, preserving unrelated entries and their order. These GDI links supply shifted glyphs when the application requests those base typefaces [3].

The same file configures Windows' EUDC association for **Private Use Area** characters, used by Word and Notepad [4]. It sets `SystemDefaultEUDCFont` under the current user's `EUDC\<code-page number>` key to the installed Fallback font path. The generated file identifies that user's registry hive explicitly. If an unrelated EUDC font already occupies this association, the generator stops rather than replacing it.

The number is Windows' **system ANSI code page**, returned by `GetACP`: the legacy character encoding associated with **Language for non-Unicode programs** in Windows' regional settings [4, 5]. Windows uses that number to choose the EUDC registry branch even for Unicode text. It does not determine the XML document's encoding. Sign out and back in after importing to refresh cached font associations.

## If the display is wrong

Boxes indicate that the rendering system is not supplying the shifted glyphs. For applications using Windows fallback, check the installed Fallback font and the Windows associations above. Editors with their own font lists also need the application settings described earlier.

In Word, also check whether it has switched the shifted text to another typeface, particularly an East Asian assignment such as Yu Gothic (Body Asian). **The shifted characters must use the same assigned typeface as the surrounding text**, with fallback supplying their glyphs.

To correct a mixed font assignment, select the affected text, enter the intended surrounding typeface in the font-name box and press Enter. For a document intended to use Calibri throughout, select all and enter `Calibri`.

## Supported tools

*Table Application coverage* lists the supported Windows tools and the activities they support. Use the application settings or Windows associations described above.

*Table Application coverage*

| Application or path | Checked support |
|---|---|
| Notepad | Display after private-use association and restart |
| Word | Display and spacing after correcting the assigned typeface |
| MSMQ message viewer | Supported |
| VS Code and Visual Studio 2022 | XML/XSLT display, fragment copy/paste and saved values |
| VS Code Markdown | Source editor, preview tables, inline code and code blocks |
| Chrome browser fields | Input, textarea and editable content; copy/paste and HTTP text/XML/JSON |
| Windows Terminal and Console Host | Display, prompt copy/paste and message command parameters |
| VS Code integrated terminal | Display with its separate fallback setting; message parameters |

## References

1. *Shifted binary reader guide – Foundry*, [reader guide](Shifted-binary-reader-guide.md), Data Abstraction (Pty) Ltd, 16 November 2026.
2. *Convenient binary XML encoding (DA-TR-351)*, [XML encoding proposal](Convenient-binary-XML-encoding.pdf), Data Abstraction (Pty) Ltd, revised 17 November 2026.
3. *Customise font selection with font fallback and font linking*, [Windows font configuration](https://learn.microsoft.com/en-us/globalization/fonts-layout/fonts), Microsoft, 16 November 2026.
4. *EUDC*, [Windows private-use font associations](https://learn.microsoft.com/en-us/windows/win32/intl/eudc), Microsoft, 30 June 2021.
5. *GetACP function*, [system ANSI code page](https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-getacp), Microsoft, 22 February 2024.
