<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:template match="/">
<html>
	<body>
		<xsl:apply-templates/>
	</body>
</html>
</xsl:template>

<!--check for sub article type-->
<xsl:variable name="subArticleType">
	<xsl:choose>
		<xsl:when test="sub-article[@article-type='article-commentary']">decision-letter</xsl:when>
		<xsl:otherwise>author-response</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template match="sub-article">
	<xsl:apply-templates select="front-stub/contrib-group/contrib"/>
	<xsl:apply-templates select="body"/>
	<xsl:apply-templates select="front-stub/article-id"/>
</xsl:template>

<xsl:template match="body">
<div class="elife-article-{$subArticleType}">
   	<div class="article fulltext-view">
		<xsl:apply-templates select="boxed-text/p"/>
	 	<xsl:apply-templates select="p"/>
	</div>
</div>
</xsl:template>

<xsl:template match="front-stub/contrib-group/contrib">
<div class="elife-article-editors">
	<div class="elife-article-decision-reviewingeditor">
	 	<xsl:apply-templates select="name"/>, <span class="nlm-role"><xsl:value-of select="role"/></span>, <xsl:apply-templates select="aff"/>
	</div>
</div>
</xsl:template>
<xsl:template match="name">
	<span class="nlm-given-names"><xsl:apply-templates select="given-names"/></span><xsl:text> </xsl:text><span class="nlm-surname"><xsl:apply-templates select="surname"/></span>
</xsl:template>

<xsl:template match="given-names">
	<xsl:apply-templates/>
</xsl:template>
<xsl:template match="surname">
	<xsl:apply-templates/>
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


<xsl:template match="boxed-text/p">
	 <div class="boxed-text">
		<p><xsl:apply-templates/></p>
	</div>
</xsl:template>

<xsl:template match="p">
		<p>
			<xsl:apply-templates/>
		</p>
</xsl:template>
<xsl:variable name="doi">
    <xsl:value-of select="sub-article/front-stub/article-id"/>
</xsl:variable>

<xsl:template match="front-stub/article-id">
<div class="elife-article-{$subArticleType}-doi">
    <strong>DOI: </strong><a href="{concat('/lookup/doi/', $doi)}">http://dx.doi.org/<xsl:value-of select="."/></a>

</div>
</xsl:template>
<xsl:include href="formatting.xsl" />
</xsl:stylesheet> 

