<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
	<xsl:output method="xml" indent="yes"/>


	<xsl:variable name="shiftedText">
		<xsl:text>&#xE100;&#xE101;&#xE102;&#xE103;</xsl:text>
		<xsl:text>&#xE104;&#xE105;&#xE106;&#xE107;</xsl:text>
		<xsl:text>&#xE108;&#x09;&#x0A;&#xE10B;</xsl:text>
		<xsl:text>&#xE10C;&#xE10D;&#xE10E;&#xE10F;</xsl:text>
		<xsl:text>&#xE110;&#xE111;&#xE112;&#xE113;</xsl:text>
		<xsl:text>&#xE114;&#xE115;&#xE116;&#xE117;</xsl:text>
		<xsl:text>&#xE118;&#xE119;&#xE11A;&#xE11B;</xsl:text>
		<xsl:text>&#xE11C;&#xE11D;&#xE11E;&#xE11F;</xsl:text>
		<xsl:text>&#x20;&#x21;&#x22;&#x23;&#x24;&#x25;&#x26;&#x27;</xsl:text>
		<xsl:text>&#x28;&#x29;&#x2A;&#x2B;&#x2C;&#x2D;&#x2E;&#x2F;</xsl:text>
		<xsl:text>&#x30;&#x31;&#x32;&#x33;&#x34;&#x35;&#x36;&#x37;</xsl:text>
		<xsl:text>&#x38;&#x39;&#x3A;&#x3B;&#x3C;&#x3D;&#x3E;&#x3F;</xsl:text>
		<xsl:text>&#x40;&#x41;&#x42;&#x43;&#x44;&#x45;&#x46;&#x47;</xsl:text>
		<xsl:text>&#x48;&#x49;&#x4A;&#x4B;&#x4C;&#x4D;&#x4E;&#x4F;</xsl:text>
		<xsl:text>&#x50;&#x51;&#x52;&#x53;&#x54;&#x55;&#x56;&#x57;</xsl:text>
		<xsl:text>&#x58;&#x59;&#x5A;&#x5B;&#x5C;&#x5D;&#x5E;&#x5F;</xsl:text>
		<xsl:text>&#x60;&#x61;&#x62;&#x63;&#x64;&#x65;&#x66;&#x67;</xsl:text>
		<xsl:text>&#x68;&#x69;&#x6A;&#x6B;&#x6C;&#x6D;&#x6E;&#x6F;</xsl:text>
		<xsl:text>&#x70;&#x71;&#x72;&#x73;&#x74;&#x75;&#x76;&#x77;</xsl:text>
		<xsl:text>&#x78;&#x79;&#x7A;&#x7B;&#x7C;&#x7D;&#x7E;&#x7F;</xsl:text>
		<xsl:text>&#x80;&#x81;&#x82;&#x83;&#x84;&#x85;&#x86;&#x87;</xsl:text>
		<xsl:text>&#x88;&#x89;&#x8A;&#x8B;&#x8C;&#x8D;&#x8E;&#x8F;</xsl:text>
		<xsl:text>&#x90;&#x91;&#x92;&#x93;&#x94;&#x95;&#x96;&#x97;</xsl:text>
		<xsl:text>&#x98;&#x99;&#x9A;&#x9B;&#x9C;&#x9D;&#x9E;&#x9F;</xsl:text>
		<xsl:text>&#xA0;&#xA1;&#xA2;&#xA3;&#xA4;&#xA5;&#xA6;&#xA7;</xsl:text>
		<xsl:text>&#xA8;&#xA9;&#xAA;&#xAB;&#xAC;&#xAD;&#xAE;&#xAF;</xsl:text>
		<xsl:text>&#xB0;&#xB1;&#xB2;&#xB3;&#xB4;&#xB5;&#xB6;&#xB7;</xsl:text>
		<xsl:text>&#xB8;&#xB9;&#xBA;&#xBB;&#xBC;&#xBD;&#xBE;&#xBF;</xsl:text>
		<xsl:text>&#xC0;&#xC1;&#xC2;&#xC3;&#xC4;&#xC5;&#xC6;&#xC7;</xsl:text>
		<xsl:text>&#xC8;&#xC9;&#xCA;&#xCB;&#xCC;&#xCD;&#xCE;&#xCF;</xsl:text>
		<xsl:text>&#xD0;&#xD1;&#xD2;&#xD3;&#xD4;&#xD5;&#xD6;&#xD7;</xsl:text>
		<xsl:text>&#xD8;&#xD9;&#xDA;&#xDB;&#xDC;&#xDD;&#xDE;&#xDF;</xsl:text>
		<xsl:text>&#xE0;&#xE1;&#xE2;&#xE3;&#xE4;&#xE5;&#xE6;&#xE7;</xsl:text>
		<xsl:text>&#xE8;&#xE9;&#xEA;&#xEB;&#xEC;&#xED;&#xEE;&#xEF;</xsl:text>
		<xsl:text>&#xF0;&#xF1;&#xF2;&#xF3;&#xF4;&#xF5;&#xF6;&#xF7;</xsl:text>
		<xsl:text>&#xF8;&#xF9;&#xFA;&#xFB;&#xFC;&#xFD;&#xFE;&#xFF;</xsl:text>
	</xsl:variable>
	<xsl:variable name="plainText">
		<xsl:text>&#xFFFD;&#xFFFD;&#xFFFD;&#xFFFD;</xsl:text>
		<xsl:text>&#xFFFD;&#xFFFD;&#xFFFD;&#xFFFD;</xsl:text>
		<xsl:text>&#xFFFD;&#x09;&#x0A;&#xFFFD;</xsl:text>
		<xsl:text>&#xFFFD;&#xFFFD;&#xFFFD;&#xFFFD;</xsl:text>
		<xsl:text>&#xFFFD;&#xFFFD;&#xFFFD;&#xFFFD;</xsl:text>
		<xsl:text>&#xFFFD;&#xFFFD;&#xFFFD;&#xFFFD;</xsl:text>
		<xsl:text>&#xFFFD;&#xFFFD;&#xFFFD;&#xFFFD;</xsl:text>
		<xsl:text>&#xFFFD;&#xFFFD;&#xFFFD;&#xFFFD;</xsl:text>
		<xsl:value-of select="substring($shiftedText, 33)"/>
	</xsl:variable>
	<xsl:variable name="canonicalShifted">
		<xsl:text>&#xE100;&#xE101;&#xE102;&#xE103;</xsl:text>
		<xsl:text>&#xE104;&#xE105;&#xE106;&#xE107;</xsl:text>
		<xsl:text>&#xE108;&#xE109;&#xE10A;&#xE10B;</xsl:text>
		<xsl:text>&#xE10C;&#xE10D;&#xE10E;&#xE10F;</xsl:text>
		<xsl:text>&#xE110;&#xE111;&#xE112;&#xE113;</xsl:text>
		<xsl:text>&#xE114;&#xE115;&#xE116;&#xE117;</xsl:text>
		<xsl:text>&#xE118;&#xE119;&#xE11A;&#xE11B;</xsl:text>
		<xsl:text>&#xE11C;&#xE11D;&#xE11E;&#xE11F;</xsl:text>
		<xsl:text>&#xE120;&#xE121;&#xE122;&#xE123;</xsl:text>
		<xsl:text>&#xE124;&#xE125;&#xE126;&#xE127;</xsl:text>
		<xsl:text>&#xE128;&#xE129;&#xE12A;&#xE12B;</xsl:text>
		<xsl:text>&#xE12C;&#xE12D;&#xE12E;&#xE12F;</xsl:text>
		<xsl:text>&#xE130;&#xE131;&#xE132;&#xE133;</xsl:text>
		<xsl:text>&#xE134;&#xE135;&#xE136;&#xE137;</xsl:text>
		<xsl:text>&#xE138;&#xE139;&#xE13A;&#xE13B;</xsl:text>
		<xsl:text>&#xE13C;&#xE13D;&#xE13E;&#xE13F;</xsl:text>
		<xsl:text>&#xE140;&#xE141;&#xE142;&#xE143;</xsl:text>
		<xsl:text>&#xE144;&#xE145;&#xE146;&#xE147;</xsl:text>
		<xsl:text>&#xE148;&#xE149;&#xE14A;&#xE14B;</xsl:text>
		<xsl:text>&#xE14C;&#xE14D;&#xE14E;&#xE14F;</xsl:text>
		<xsl:text>&#xE150;&#xE151;&#xE152;&#xE153;</xsl:text>
		<xsl:text>&#xE154;&#xE155;&#xE156;&#xE157;</xsl:text>
		<xsl:text>&#xE158;&#xE159;&#xE15A;&#xE15B;</xsl:text>
		<xsl:text>&#xE15C;&#xE15D;&#xE15E;&#xE15F;</xsl:text>
		<xsl:text>&#xE160;&#xE161;&#xE162;&#xE163;</xsl:text>
		<xsl:text>&#xE164;&#xE165;&#xE166;&#xE167;</xsl:text>
		<xsl:text>&#xE168;&#xE169;&#xE16A;&#xE16B;</xsl:text>
		<xsl:text>&#xE16C;&#xE16D;&#xE16E;&#xE16F;</xsl:text>
		<xsl:text>&#xE170;&#xE171;&#xE172;&#xE173;</xsl:text>
		<xsl:text>&#xE174;&#xE175;&#xE176;&#xE177;</xsl:text>
		<xsl:text>&#xE178;&#xE179;&#xE17A;&#xE17B;</xsl:text>
		<xsl:text>&#xE17C;&#xE17D;&#xE17E;&#xE17F;</xsl:text>
		<xsl:text>&#xE180;&#xE181;&#xE182;&#xE183;</xsl:text>
		<xsl:text>&#xE184;&#xE185;&#xE186;&#xE187;</xsl:text>
		<xsl:text>&#xE188;&#xE189;&#xE18A;&#xE18B;</xsl:text>
		<xsl:text>&#xE18C;&#xE18D;&#xE18E;&#xE18F;</xsl:text>
		<xsl:text>&#xE190;&#xE191;&#xE192;&#xE193;</xsl:text>
		<xsl:text>&#xE194;&#xE195;&#xE196;&#xE197;</xsl:text>
		<xsl:text>&#xE198;&#xE199;&#xE19A;&#xE19B;</xsl:text>
		<xsl:text>&#xE19C;&#xE19D;&#xE19E;&#xE19F;</xsl:text>
		<xsl:text>&#xE1A0;&#xE1A1;&#xE1A2;&#xE1A3;</xsl:text>
		<xsl:text>&#xE1A4;&#xE1A5;&#xE1A6;&#xE1A7;</xsl:text>
		<xsl:text>&#xE1A8;&#xE1A9;&#xE1AA;&#xE1AB;</xsl:text>
		<xsl:text>&#xE1AC;&#xE1AD;&#xE1AE;&#xE1AF;</xsl:text>
		<xsl:text>&#xE1B0;&#xE1B1;&#xE1B2;&#xE1B3;</xsl:text>
		<xsl:text>&#xE1B4;&#xE1B5;&#xE1B6;&#xE1B7;</xsl:text>
		<xsl:text>&#xE1B8;&#xE1B9;&#xE1BA;&#xE1BB;</xsl:text>
		<xsl:text>&#xE1BC;&#xE1BD;&#xE1BE;&#xE1BF;</xsl:text>
		<xsl:text>&#xE1C0;&#xE1C1;&#xE1C2;&#xE1C3;</xsl:text>
		<xsl:text>&#xE1C4;&#xE1C5;&#xE1C6;&#xE1C7;</xsl:text>
		<xsl:text>&#xE1C8;&#xE1C9;&#xE1CA;&#xE1CB;</xsl:text>
		<xsl:text>&#xE1CC;&#xE1CD;&#xE1CE;&#xE1CF;</xsl:text>
		<xsl:text>&#xE1D0;&#xE1D1;&#xE1D2;&#xE1D3;</xsl:text>
		<xsl:text>&#xE1D4;&#xE1D5;&#xE1D6;&#xE1D7;</xsl:text>
		<xsl:text>&#xE1D8;&#xE1D9;&#xE1DA;&#xE1DB;</xsl:text>
		<xsl:text>&#xE1DC;&#xE1DD;&#xE1DE;&#xE1DF;</xsl:text>
		<xsl:text>&#xE1E0;&#xE1E1;&#xE1E2;&#xE1E3;</xsl:text>
		<xsl:text>&#xE1E4;&#xE1E5;&#xE1E6;&#xE1E7;</xsl:text>
		<xsl:text>&#xE1E8;&#xE1E9;&#xE1EA;&#xE1EB;</xsl:text>
		<xsl:text>&#xE1EC;&#xE1ED;&#xE1EE;&#xE1EF;</xsl:text>
		<xsl:text>&#xE1F0;&#xE1F1;&#xE1F2;&#xE1F3;</xsl:text>
		<xsl:text>&#xE1F4;&#xE1F5;&#xE1F6;&#xE1F7;</xsl:text>
		<xsl:text>&#xE1F8;&#xE1F9;&#xE1FA;&#xE1FB;</xsl:text>
		<xsl:text>&#xE1FC;&#xE1FD;&#xE1FE;&#xE1FF;</xsl:text>
	</xsl:variable>
	<xsl:variable name="shiftedBinary">
		<xsl:value-of select="$shiftedText"/>
		<xsl:value-of select="$canonicalShifted"/>
	</xsl:variable>
	<xsl:variable name="toShiftedBinary">
		<xsl:value-of select="$canonicalShifted"/>
		<xsl:value-of select="$canonicalShifted"/>
	</xsl:variable>
	<xsl:variable name="toShiftedText">
		<xsl:value-of select="$shiftedText"/>
		<xsl:value-of select="$shiftedText"/>
	</xsl:variable>
	<xsl:variable name="toPlainText">
		<xsl:value-of select="$plainText"/>
		<xsl:value-of select="$plainText"/>
	</xsl:variable>
</xsl:stylesheet>
