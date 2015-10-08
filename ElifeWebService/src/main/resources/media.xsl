<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:template match="/">
<html>
	<body>
	<xsl:apply-templates/>
	</body>
</html>
</xsl:template>
<xsl:template match="media">
<xsl:variable name="videoFile">
    		<xsl:value-of select="concat('[video-',@id,'-inline]')"/>
</xsl:variable>
<xsl:variable name="VideoLink">
    		<xsl:value-of select="concat('[video-',@id,'-download]')"/>
</xsl:variable>
<div class="media video-content" id="{@id}">
	<div class="media-inline video-inline">
		<div class="elife-inline-video">
			<xsl:value-of select="$videoFile"/>
			<div class="elife-video-links"><span class="elife-video-link elife-video-link-download">
				<a href="{$VideoLink}">Download Video</a></span>
			</div>
		</div>
	</div>
	<div class="media-caption">
		<xsl:apply-templates select="label"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="caption"/>
	</div>
</div>
</xsl:template>
<xsl:template match="label">
	<span class="media-label"><xsl:apply-templates/></span>
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
		<xsl:when test="(position() = 1)">
			<p class="first-child"><xsl:apply-templates/></p>
		</xsl:when>
		<xsl:otherwise>
			<p><xsl:apply-templates/></p>
		</xsl:otherwise>
	</xsl:choose>
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
