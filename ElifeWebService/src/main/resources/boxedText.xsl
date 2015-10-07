<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:template match="/">
<html>
	<body>
	<xsl:apply-templates/>
	</body>
</html>
</xsl:template>
<xsl:template match="boxed-text">
<div class="boxed-text" id="{@id}">
	<xsl:apply-templates select="label"/>
	<xsl:apply-templates select="caption/p"/>
	<xsl:apply-templates select="p"/>
</div>
</xsl:template>
<xsl:template match="label">
	<span class="boxed-text-label"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="caption/p">
	<xsl:choose>
		<xsl:when test="(position() = 1)">
			<p class="first-child"><xsl:apply-templates/></p>
		</xsl:when>
		<xsl:otherwise>
			<p><xsl:apply-templates/></p>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>
<xsl:template match="p">
	<p><xsl:apply-templates/></p>
</xsl:template>

 <!-- ============================================================= -->
  <!--  Formatting elements                                          -->
  <!-- ============================================================= -->

<xsl:template match="*[@ext-link-type = 'doi' and @xlink:href]">
			 <a href="/lookup/doi/{@xlink:href}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="*[@ref-type and @rid]">
	
	<a class="{concat('xref-',@ref-type)}" href="{concat('#',@rid)}"><xsl:apply-templates/></a>
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
