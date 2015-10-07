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
	<span class="inline-linked-media-wrapper"><a href="[media-elife00288s003-download]"><i class="icon-download-alt"></i> Download source data<span class="inline-linked-media-filename">[figure-4—source-data-1.media-3.xlsx]</span></a></span>
</div>
</xsl:template>
<xsl:template match="label">
	<span class="supplementary-material-label"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="caption/p">
	<p><xsl:apply-templates/></p>
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
