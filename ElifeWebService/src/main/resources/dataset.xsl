<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:output method="xml"/>
<xsl:template match="/">
<html>
	<body>
	<xsl:apply-templates select="sec/p"/>
	
	</body>
</html>
</xsl:template>


<xsl:template match="sec/p">
<p>
	<xsl:if test="not(*)">
	<xsl:value-of select="."/> 
	</xsl:if>
	<xsl:apply-templates select="related-object"/>
</p>
</xsl:template>

<xsl:template match="related-object">
	<span class="related-object" id="{@id}">
	<xsl:apply-templates select="name"/>
	<xsl:apply-templates select="year"/>
	<xsl:apply-templates select="source"/>
	<xsl:apply-templates select="object-id"/>
	<xsl:apply-templates select="ext-link"/>
	<xsl:apply-templates select="comment"/>
	</span>
</xsl:template>

<xsl:template match="name">
	<span class="name"><xsl:value-of select="surname"/><xsl:text> </xsl:text><xsl:value-of select="given-names"/></span>, 
</xsl:template>

<xsl:template match="year">
	<span class="year"><xsl:apply-templates/></span>
	<span class="x">, </span>
</xsl:template>

<xsl:template match="source">
	<span class="source"><xsl:apply-templates/></span>
	<span class="x">, </span>
</xsl:template>

<xsl:template match="object-id">
	<span class="object-id"><xsl:apply-templates/></span>
	<span class="x">; </span>

</xsl:template>

<xsl:template match="comment">
	<span class="x">, </span>
	<span class="comment"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="ext-link[@ext-link-type = 'uri' and @xlink:href]">
	<a href="{ext-link}" target="_blank"><xsl:apply-templates/></a>
</xsl:template>
<xsl:include href="formatting.xsl"/>

</xsl:stylesheet> 
