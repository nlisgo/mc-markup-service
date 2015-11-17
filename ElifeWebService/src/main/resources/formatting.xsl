<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:template match="*[@ext-link-type = 'doi' and @xlink:href]">
			 <a href="/lookup/doi/{@xlink:href}"><xsl:apply-templates/></a>
</xsl:template>
<xsl:template match="*[@ext-link-type = 'uri' and @xlink:href]">
			 <a href="{@xlink:href}"><xsl:apply-templates/></a>
</xsl:template>
<xsl:template match="inline-graphic['@xlink:href']">
	<xsl:variable name="inlineGraphics">
		<xsl:value-of select="concat(' [inline-graphic-',@xlink:href,'-research-fig] ')"/>
	</xsl:variable>
	<xsl:value-of select="$inlineGraphics"/>
</xsl:template>

<xsl:template match="italic">
    <em>
      <xsl:apply-templates/>
    </em>
 </xsl:template>
<xsl:template match="bold">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
<xsl:template match="sub">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>

  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>
  
</xsl:stylesheet>
