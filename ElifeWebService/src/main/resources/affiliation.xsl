<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:output method="xml"/>
<xsl:template match="/">
<html>
	<body>
	<span class="aff">
	  <xsl:apply-templates/>
	</span>
	</body>
</html>
</xsl:template>

<xsl:template match="x">
<span class="x">
<xsl:apply-templates/>
</span>
</xsl:template>



<xsl:template match="institution">
<xsl:choose>
	<xsl:when test="@content-type">
		<span class="institution" data-content-type="{@content-type}"><xsl:apply-templates/></span>
	</xsl:when>
	<xsl:otherwise>
		<span class="institution"><xsl:apply-templates/></span>
	</xsl:otherwise>
</xsl:choose>

</xsl:template>


<xsl:template match="addr-line">
<span class="addr-line">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="named-content">
<span class="named-content" data-content-type="city">
<xsl:apply-templates/>
</span>
</xsl:template>

<xsl:template match="country">
<span class="country">
<xsl:apply-templates/>
 
</span>
</xsl:template>

<xsl:template match="label">
</xsl:template>

<xsl:template match="email">
<a href="mailto:{.}" class="email"><xsl:apply-templates/></a>
</xsl:template>



<xsl:include href="formatting.xsl" />

<xsl:template match="bold">
<span class="bold"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="italic">
    <span class="italic">
      <xsl:apply-templates/>
    </span>
 </xsl:template>
</xsl:stylesheet>
 
