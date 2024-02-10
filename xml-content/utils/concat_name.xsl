<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="concat_name">
        <xsl:param name="firstname" />
        <xsl:param name="middlename" />
        <xsl:param name="lastname" />

        <xsl:value-of select="firstname"/>
        <xsl:text> </xsl:text>
        <xsl:if test="middlename">
            <xsl:value-of select="middlename"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="lastname"/>
    </xsl:template>

</xsl:stylesheet>
