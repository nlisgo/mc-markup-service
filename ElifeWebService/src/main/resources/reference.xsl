<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
	<body>
		<div class="elife-reflinks-links">
			<xsl:apply-templates select="ref-list/ref"/>
		</div>
	</body>
</html>
</xsl:template>
<xsl:template match="ref-list/ref">
	
<article class="elife-reflinks-reflink">
	<xsl:variable name="seq">
    		<xsl:value-of select="substring-after(@id,'bib')"/>
	</xsl:variable>

	<xsl:attribute name="id">
		<xsl:value-of select="concat('ref-',$seq)"/>
	</xsl:attribute>
	<xsl:attribute name="data-original">
		<xsl:value-of select="$seq"/>
	</xsl:attribute>
	<div class="elife-reflink-indicators">
            <div class="elife-reflink-indicators-left">
                <div class="elife-reflink-indicator-number">
                    <span data-counter="{$seq}">
			<xsl:value-of select="$seq"/>
		    </span>
                </div>
            </div>
        </div>
	<div class="elife-reflink-main">
 		<xsl:apply-templates select="element-citation"/>
	</div>
</article>

</xsl:template>
<xsl:template match="element-citation">
	
	<xsl:apply-templates select="article-title"/>
	<div class="elife-reflink-authors">
		<xsl:apply-templates select="person-group/name"/>
	</div>
	 <div class="elife-reflink-details">
		<span class="elife-reflink-details-journal"><span class="nlm-source"><xsl:value-of select="source"/></span></span>,
                <span class="elife-reflink-details-volume"><xsl:value-of select="volume"/></span>,
                <span class="elife-reflink-details-pages"><xsl:value-of select="fpage"/>-<xsl:value-of select="lpage"/></span>,
                <span class="elife-reflink-details-year"><xsl:value-of select="year"/></span>
		<xsl:if test="pub-id">
                <div class="elife-reflink-doi-cited-wrapper">
                    <span class="elife-reflink-details-doi"><a href="http://dx.doi.org/{pub-id}">http://dx.doi.org/<xsl:value-of select="pub-id"/></a></span>
                </div>
		</xsl:if>
	</div>
</xsl:template>

<xsl:template match="article-title">
<cite class="elife-reflink-title">
	<xsl:choose>
		<xsl:when test="../pub-id">
			<a href="http://dx.doi.org/{../pub-id}" target="_blank"><span class="nlm-article-title"><xsl:apply-templates/></span></a>
		</xsl:when>
		<xsl:otherwise>
			<span class="nlm-article-title"><xsl:apply-templates/></span>
		</xsl:otherwise>
	</xsl:choose>
	
</cite>
</xsl:template>
<xsl:template match="person-group/name">
<xsl:variable name="authorname">
    	<xsl:value-of select="concat(concat(given-names,' '),surname)"/>
</xsl:variable>

<xsl:if test="not(position() = 1)">, </xsl:if>
	<span class="elife-reflink-author">
		<a href="http://scholar.google.com/scholar?q=&quot;author:{$authorname}&quot;"><xsl:value-of select="$authorname"/></a>
	</span>
</xsl:template>
</xsl:stylesheet>



