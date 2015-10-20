<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML">
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
	<xsl:if test="table-wrap-foot">
		<div class="table-foot"><ul class="table-footnotes">
			<xsl:apply-templates select="table-wrap-foot/fn"/>
		</ul></div>
	</xsl:if>
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
	<tbody><xsl:apply-templates select="tr"/></tbody>
</xsl:template>
<xsl:template match="tr">
	<tr><xsl:apply-templates select="td"/></tr>
</xsl:template>
<xsl:template match="td">
	<xsl:choose>
		<xsl:when test="child::inline-formula">
					
					<xsl:apply-templates select="inline-formula"/>
				
		</xsl:when>
		<xsl:otherwise>
			<td rowspan="1" colspan="1"><xsl:apply-templates/></td>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

<xsl:template match="inline-formula">
	<td rowspan="1" colspan="1"><span class="inline-formula"><span class="mathjax mml-math">
			<xsl:apply-templates select="mml:math"/>
	</span></span></td>
</xsl:template>

<xsl:template match="node()|@*">
<xsl:copy>
	<xsl:apply-templates select="node()|@*"/>
</xsl:copy>
</xsl:template>

<xsl:template match="mml:mtext">
	<xsl:variable name="mtextType">
    		<xsl:value-of select="."/>
	</xsl:variable>
	
	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="dig" select="'0123456789'"/>
	<xsl:variable name="alphaTrans" select="translate($mtextType, concat($upper, $lower), '')"/>
	<xsl:variable name="digitTrans" select="translate($alphaTrans,$dig,'')"/>
	<xsl:choose>
		
		<xsl:when test="string-length($alphaTrans) > 0 and string-length($digitTrans) > 0">
			<mml:mi><xsl:value-of select="$mtextType"/></mml:mi>
		</xsl:when>
		<xsl:when test="string-length($alphaTrans) = 0 and not(parent::mml:mrow)">
			<mml:mi mathvariant="normal"><xsl:value-of select="$mtextType"/></mml:mi>
		</xsl:when>
		<xsl:otherwise>
			<mml:mtext><xsl:value-of select="$mtextType"/></mml:mtext>
		</xsl:otherwise>
		
	</xsl:choose>
	
</xsl:template>

<xsl:template match="@overflow|@id"/>

<xsl:template match="*[@ref-type = 'bibr' and @rid]">
		<a class="xref-bibr" href="#{@rid}"><xsl:apply-templates/></a>
</xsl:template>
<xsl:template match="*[@ref-type = 'table' and @rid]">
		<span class="xref-table"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="table-wrap-foot/fn">
	<li class="fn"><xsl:apply-templates select="p"/></li>
</xsl:template>

<xsl:template match="p">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:include href="formatting.xsl" />
</xsl:stylesheet>
