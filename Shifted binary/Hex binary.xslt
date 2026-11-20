<?xml version="1.0" encoding="utf-8"?>
<!-- Hex binary.xslt
     (C) 2026 Data Abstraction (Pty) Ltd, all rights reserved.
     Optional XSLT 1.0 boundary converters. Original tables remain unchanged. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sb="urn:data-abstraction:shifted-binary" exclude-result-prefixes="sb">
  <xsl:import href="Shifted%20binary.xslt"/>
  <xsl:variable name="sb:hex" select="'0123456789ABCDEF'"/>

  <!-- Public: accepts hexBinary lexical content after XML whitespace collapse.
       Empty input is valid; separators and internal whitespace are rejected. -->
  <xsl:template name="sb:hex-to-shifted">
    <xsl:param name="value" select="''"/>
    <xsl:variable name="hex" select="translate(normalize-space(string($value)), 'abcdef', 'ABCDEF')"/>
    <xsl:choose>
      <xsl:when test="string-length($hex) mod 2 != 0 or translate($hex, $sb:hex, '') != ''">
        <xsl:message terminate="yes">SBHEX001: expected an even number of hexadecimal digits, without separators.</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="sb:hex-range"><xsl:with-param name="value" select="$hex"/></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Public: canonical shifted alphabet only. Normalise mixed input explicitly. -->
  <xsl:template name="sb:shifted-to-hex">
    <xsl:param name="value" select="''"/>
    <xsl:choose>
      <xsl:when test="translate(string($value), string($canonicalShifted), '') != ''">
        <xsl:message terminate="yes">SBHEX002: expected only U+E100 through U+E1FF.</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="sb:shifted-range"><xsl:with-param name="value" select="string($value)"/></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Internal: balanced splitting bounds recursive depth logarithmically.
       Validation happens once at the public boundary, before any output. -->
  <xsl:template name="sb:hex-range">
    <xsl:param name="value"/>
    <xsl:variable name="length" select="string-length($value)"/>
    <xsl:choose>
      <xsl:when test="$length &gt; 2">
        <xsl:variable name="split" select="2 * floor($length div 4)"/>
        <xsl:call-template name="sb:hex-range"><xsl:with-param name="value" select="substring($value, 1, $split)"/></xsl:call-template>
        <xsl:call-template name="sb:hex-range"><xsl:with-param name="value" select="substring($value, $split + 1)"/></xsl:call-template>
      </xsl:when>
      <xsl:when test="$length = 2">
        <xsl:variable name="high" select="string-length(substring-before($sb:hex, substring($value, 1, 1)))"/>
        <xsl:variable name="low" select="string-length(substring-before($sb:hex, substring($value, 2, 1)))"/>
        <xsl:value-of select="substring(string($canonicalShifted), 16 * $high + $low + 1, 1)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sb:shifted-range">
    <xsl:param name="value"/>
    <xsl:variable name="length" select="string-length($value)"/>
    <xsl:choose>
      <xsl:when test="$length &gt; 1">
        <xsl:variable name="split" select="floor($length div 2)"/>
        <xsl:call-template name="sb:shifted-range"><xsl:with-param name="value" select="substring($value, 1, $split)"/></xsl:call-template>
        <xsl:call-template name="sb:shifted-range"><xsl:with-param name="value" select="substring($value, $split + 1)"/></xsl:call-template>
      </xsl:when>
      <xsl:when test="$length = 1">
        <xsl:variable name="byte" select="string-length(substring-before(string($canonicalShifted), $value))"/>
        <xsl:value-of select="substring($sb:hex, floor($byte div 16) + 1, 1)"/>
        <xsl:value-of select="substring($sb:hex, ($byte mod 16) + 1, 1)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
