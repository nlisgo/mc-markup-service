<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:template match="/">
<html>
	<body>
	<xsl:apply-templates/>
	</body>
</html>
</xsl:template>
<xsl:template match="supplementary-material">
<div class="supplementary-material-expansion" id="{@id}">
	<xsl:apply-templates select="label"/>
	<xsl:apply-templates select="caption/p"/>
	<xsl:apply-templates select="media"/>
</div>
</xsl:template>
<xsl:template match="label">
	<span class="supplementary-material-label"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="caption/p">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="media">
<xsl:variable name="fileId">
    		<xsl:value-of select="../@id"/>
</xsl:variable>

<xsl:variable name="mediaLinkFile">
    		<xsl:value-of select="substring-before(@xlink:href, '.')"/>
</xsl:variable>
<xsl:variable name="fileName">
    		<xsl:value-of select="concat('[',../label,'media-',substring($fileId, 3, 1),'.xlsx]')"/>
</xsl:variable>
<xsl:variable name="mediaLink">
    		<xsl:value-of select="concat('[media-',$mediaLinkFile,'-download]')"/>
</xsl:variable>
<span class="inline-linked-media-wrapper"><a href="{$mediaLink}"><i class="icon-download-alt"></i> Download source data<span class="inline-linked-media-filename"><xsl:value-of select="$fileName"/></span></a></span>
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
