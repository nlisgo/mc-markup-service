<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:template match="/">
<html>
	<body>
	<xsl:apply-templates select="sub-article/front-stub/contrib-group/contrib"/>
	<xsl:apply-templates select="sub-article/body"/>
	<xsl:apply-templates select="sub-article/front-stub/article-id"/>
	
	</body>
</html>
</xsl:template>


<xsl:template match="sub-article/front-stub/contrib-group/contrib">
<div class="elife-article-editors">
	<div class="elife-article-decision-reviewingeditor">
	 	<xsl:apply-templates select="name"/>, <span class="nlm-role"><xsl:value-of select="role"/></span>, <xsl:apply-templates select="aff"/>
	</div>
</div>
</xsl:template>
<xsl:template match="name">
	<xsl:apply-templates select="given-names"/>
	<xsl:apply-templates select="surname"/>
</xsl:template>

<xsl:template match="given-names">
	<span class="nlm-given-names"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="surname">
	<span class="nlm-surname"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="aff">
	<xsl:apply-templates select="institution"/>, <xsl:apply-templates select="country"/>
</xsl:template>
<xsl:template match="institution">
	<span class="nlm-institution"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="country">
	<span class="nlm-country"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="sub-article/body">
<div class="elife-article-decision-letter">
	<div class="article fulltext-view">
	 	<xsl:apply-templates select="boxed-text/p"/>
	 	<xsl:apply-templates select="p"/>
	</div>
</div>
</xsl:template>
<xsl:template match="boxed-text/p">
	 <div class="boxed-text" id="boxed-text-6">
		<p><xsl:apply-templates/></p>
	</div>
</xsl:template>
<xsl:template match="p">
		<p><xsl:apply-templates/></p>
</xsl:template>
<xsl:variable name="doi">
    <xsl:value-of select="sub-article/front-stub/article-id"/>
</xsl:variable>

<xsl:template match="sub-article/front-stub/article-id">
<div class="elife-article-decision-letter-doi">
    <strong>DOI: </strong><a href="{concat('/lookup/doi/', $doi)}">http://dx.doi.org/<xsl:value-of select="."/></a>

</div>
</xsl:template>

<!-- ============================================================= -->
  <!--  Formatting elements                                          -->
  <!-- ============================================================= -->

<xsl:template match="*[@ext-link-type = 'uri' and @xlink:href]">
			 <a href="{@xlink:href}"><xsl:apply-templates/></a>
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

