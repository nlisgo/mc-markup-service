<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:import href="supplementary-material.xsl"/>
<xsl:template match="/">
<html>
	<body>
	<xsl:apply-templates/>
	</body>
</html>
</xsl:template>
<xsl:template match="fig">
	<xsl:variable name="title">
    		<xsl:value-of select="label"/>
	</xsl:variable>
	<xsl:variable name="linkFile">
    		<xsl:value-of select="graphic/@xlink:href"/>
	</xsl:variable>

<div id="{@id}" class="fig-inline-img-set">
	<div class="elife-fig-image-caption-wrapper">
		<div class="fig-expansion">
			<div class="fig-inline-img">
                		<a href="[graphic-{$linkFile}-large]" class="figure-expand-popup" title="{$title}"><img data-img="[graphic-{$linkFile}-small]" src="[graphic-{$linkFile}-medium]" alt="{$title}" /></a>
            		</div>
			<div class="fig-caption">
				<span class="elife-figure-links"><span class="elife-figure-link elife-figure-link-download"><a href="[graphic-{$linkFile}-large]"  download="">Download figure</a></span><span class="elife-figure-link elife-figure-link-newtab"><a href="[graphic-{$linkFile}-large]"  target="_blank">Open in new tab</a></span></span>
				<xsl:apply-templates select="label"/>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="caption"/>
				<div class="sb-div caption-clear"></div>
			</div>
		</div>
	</div>
</div>
</xsl:template>
<xsl:template match="label">
	<xsl:choose>
		<xsl:when test="parent::fig">
			<span class="fig-label"><xsl:apply-templates/></span>
		</xsl:when>
		<xsl:otherwise>
			<span class="supplementary-material-label"><xsl:apply-templates/></span>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>
<xsl:template match="caption">
	<xsl:apply-templates select="title"/>
	<xsl:apply-templates select="p"/>
</xsl:template>
<xsl:template match="title">
	<span class="caption-title"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="p">
	<xsl:choose>
		<xsl:when test="child::supplementary-material">
			<xsl:apply-templates select="supplementary-material"/>
		</xsl:when>
		<xsl:otherwise>
			<p><xsl:apply-templates/></p>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>
<xsl:template match="supplementary-material">
		<xsl:variable name="dataDoi">
			<xsl:value-of select="object-id"/>
		</xsl:variable>	
		<div class="supplementary-material" data-doi="{$dataDoi}">
			<xsl:apply-imports/>
		</div>	
</xsl:template>

<xsl:include href="formatting.xsl" />
</xsl:stylesheet>
