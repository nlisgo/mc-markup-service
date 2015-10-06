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
		<xsl:value-of select="@id"/>
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
		<xsl:apply-templates select="person-group[@person-group-type='author']/name"/>
		<xsl:apply-templates select="person-group[@person-group-type='author']/etal"/>
	</div>
	 <div class="elife-reflink-details">
		<xsl:apply-templates select="source"/>
                <xsl:apply-templates select="volume"/>
		<xsl:if test="fpage">
			<span class="elife-reflink-details-pages"><xsl:apply-templates select="fpage"/>-<xsl:apply-templates select="lpage"/></span>,
		</xsl:if>
                <xsl:apply-templates select="publisher-name"/>
		<xsl:apply-templates select="publisher-loc"/>
		<xsl:apply-templates select="year"/>
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
	<xsl:choose>
		<xsl:when test="suffix">
			<xsl:value-of select="concat(given-names,' ',surname,' ',suffix)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat(given-names,' ',surname)"/>
		</xsl:otherwise>
	</xsl:choose>
    		
</xsl:variable>

<xsl:if test="not(position() = 1)">, </xsl:if>
	<span class="elife-reflink-author">
		<a href="http://scholar.google.com/scholar?q=&quot;author:{$authorname}&quot;"><xsl:value-of select="$authorname"/></a>
	</span>
</xsl:template>
<xsl:template match="source">
	<span class="elife-reflink-details-journal"><span class="nlm-source"><xsl:apply-templates/></span></span>,
</xsl:template>
<xsl:template match="volume">
	<span class="elife-reflink-details-volume"><xsl:apply-templates/></span>,
</xsl:template>
<xsl:template match="fpage">
	<xsl:apply-templates/>
</xsl:template>
<xsl:template match="lpage">
	<xsl:apply-templates/>
</xsl:template>
<xsl:template match="publisher-name">
	<span class="elife-reflink-details-pub-name"><span class="nlm-publisher-name"><xsl:apply-templates/></span></span>,
</xsl:template>
<xsl:template match="publisher-loc">
	 <span class="elife-reflink-details-pub-loc"><span class="nlm-publisher-loc"><xsl:apply-templates/></span></span>,
</xsl:template>
<xsl:template match="year">
	<span class="elife-reflink-details-year"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="etal">
	<xsl:text> et al.</xsl:text>
</xsl:template>

  <!-- ============================================================= -->
  <!--  Formatting elements                                          -->
  <!-- ============================================================= -->


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



