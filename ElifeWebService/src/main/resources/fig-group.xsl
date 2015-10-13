<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">
<xsl:import href="fig.xsl"/>


<xsl:template match="fig-group">
<div class="fig-inline-img-set fig-inline-img-set-carousel">
	 <div class="elife-fig-slider-wrapper">
		<div class="elife-fig-slider">
			<xsl:for-each select="fig">
				<xsl:variable name="title">
    					<xsl:value-of select="label"/>
				</xsl:variable>

				<xsl:variable name="figLinkFile">
    					<xsl:value-of select="graphic/@xlink:href"/>
				</xsl:variable>
				<xsl:if test="not(@specific-use)">
					<div class="elife-fig-slider-img elife-fig-slider-primary">
						<img src="[graphic-{$figLinkFile}-small]" alt="{$title}"/>
   					</div>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="//fig-group/fig[2][@specific-use]">
				
 			<div class="figure-carousel-inner-wrapper">
               			<div class="figure-carousel">
					<xsl:for-each select="fig">
						<xsl:variable name="title">
    							<xsl:value-of select="label"/>
						</xsl:variable>
						<xsl:variable name="figLinkFile">
		    					<xsl:value-of select="graphic/@xlink:href"/>
						</xsl:variable>
						<xsl:if test="@specific-use">
							 <div class="elife-fig-slider-img elife-fig-slider-secondary">
								<img src="[graphic-{$figLinkFile}-small]" alt="{$title}"/>
			    				</div>
						</xsl:if>
					</xsl:for-each>
				</div>
               		</div>
			</xsl:if>
			
		</div> 
	</div>
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
<xsl:include href="formatting.xsl" />
</xsl:stylesheet>
