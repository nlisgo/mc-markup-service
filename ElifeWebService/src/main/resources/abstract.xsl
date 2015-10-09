<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

<xsl:template match="/">
<html>
<body>
	<xsl:apply-templates select="abstract/p"/>
</body>
</html>
</xsl:template>

<xsl:template match="abstract/p">
	 <p><xsl:apply-templates/></p>
</xsl:template>
<xsl:include href="formatting.xsl" />
</xsl:stylesheet>
