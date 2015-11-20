<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">
<xsl:output method="xml"/>

<xsl:template match="article-meta">
	
	<xsl:for-each select="contrib-group/contrib[not(@id) and @contrib-type='author']/contrib-id">
		<xsl:variable name="contribId">
			<xsl:value-of select="."/>
		</xsl:variable>
		<h4 class="equal-contrib-label"><xsl:value-of select="../collab"/></h4>
		<ul>
		<xsl:call-template name="contribTemplate">
			<xsl:with-param name="contrib_id" select="$contribId"/>
		</xsl:call-template>
		</ul>		
	</xsl:for-each>
</xsl:template>

<xsl:template name="contribTemplate">
	<xsl:param name="contrib_id"/>
	<xsl:for-each select="../../../contrib-group/contrib[@contrib-type='author non-byline']/contrib-id[text()=$contrib_id]/..">
		<xsl:choose>
			<xsl:when test="position()=1"> 
				<li class="first">
					<xsl:apply-templates select="name"/><xsl:apply-templates select="aff"/>
				</li>
			</xsl:when>
			<xsl:when test="position()=last()"> 
				<li class="last">
					<xsl:apply-templates select="name"/><xsl:apply-templates select="aff"/>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<xsl:apply-templates select="name"/><xsl:apply-templates select="aff"/>
				</li>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:for-each>
</xsl:template>
<xsl:template match="name">
	<xsl:value-of select="given-names"/><xsl:text> </xsl:text><xsl:value-of select="surname"/>, 
</xsl:template>
<xsl:template match="aff">
	<xsl:if test="position()!=1">; </xsl:if>
	<span class="aff"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="institution">
	<span class="institution"><xsl:apply-templates/></span> 
</xsl:template>
<xsl:template match="addr-line">
	<span class="addr-line"><xsl:apply-templates select="named-content"/></span>
</xsl:template>
<xsl:template match="named-content">
	<xsl:choose>
		<xsl:when test="not(parent::addr-line)"> 
			<span class="named-content"><xsl:apply-templates/></span>
		</xsl:when>
		<xsl:otherwise>
			<span class="named-content"><xsl:apply-templates/></span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="country">
	<span class="country"><xsl:apply-templates/></span>
</xsl:template>

<xsl:include href="formatting.xsl" />
</xsl:stylesheet>