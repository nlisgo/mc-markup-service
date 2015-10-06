<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:template match="/">
<html>
	<body>
	<xsl:apply-templates/>
	</body>
</html>
</xsl:template>

<xsl:template match="table-wrap">
<div class="table-expansion" id="{@id}">
	<div class="table-caption">
		<xsl:apply-templates select="label"/>
		<xsl:apply-templates select="caption/p"/>
		<div class="sb-div caption-clear"></div>
	</div>
		<xsl:apply-templates select="table"/>
	<div class="table-foot"></div>
</div>
</xsl:template>

<xsl:template match="label">
	<span class="table-label"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="caption/p">
	<p><xsl:apply-templates/></p>
</xsl:template>
<xsl:template match="table">
	<table frame="hsides" rules="groups">
		<xsl:apply-templates select="thead"/>
		<xsl:apply-templates select="tbody"/>
	</table>
</xsl:template>

<xsl:template match="thead">
	<thead><xsl:apply-templates select="tr"/></thead>
</xsl:template>
<xsl:template match="tbody">
	<tbody id="tbody-1"><xsl:apply-templates select="tr"/></tbody>
</xsl:template>
<xsl:template match="tr">
	<tr><xsl:apply-templates select="td"/></tr>
</xsl:template>
<xsl:template match="td">
	<td rowspan="1" colspan="1"><xsl:apply-templates/></td>
</xsl:template>
 <!-- ============================================================= -->
  <!--  Formatting elements                                          -->
  <!-- ============================================================= -->

<xsl:template match="*[@ext-link-type = 'doi' and @xlink:href]">
			 <a href="/lookup/doi/{@xlink:href}"><xsl:apply-templates/></a>
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
