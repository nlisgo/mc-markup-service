<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">
<xsl:import href="fig.xsl"/>


<xsl:template match="fig-group">
<div class="fig-inline-img-set fig-inline-img-set-carousel">
	<div class="elife-fig-image-caption-wrapper">
		<xsl:apply-templates select="fig"/>
	</div>
</div>	
</xsl:template>

<xsl:template match="fig">
		<xsl:variable name="dataDoi">
			<xsl:value-of select="object-id"/>
		</xsl:variable>	
		<div class="fig" data-doi="{$dataDoi}">
			<xsl:apply-imports/>
		</div>	
</xsl:template>
</xsl:stylesheet>
