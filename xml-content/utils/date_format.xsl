<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="date_format">
        <xsl:param name="dateTime"/>
        <xsl:param name="withMs" select="'false'" />
        
        <xsl:variable name="date" select="substring-before($dateTime, 'T')"/>
        <xsl:variable name="year" select="substring($date, 1, 4)"/>
        <xsl:variable name="month" select="substring($date, 6, 2)"/>
        <xsl:variable name="day" select="substring($date, 9, 2)"/>

        <xsl:variable name="time" select="substring-after($dateTime, 'T')"/>
        <xsl:variable name="seconds" select="substring-before($time, '.')"/>
        <xsl:variable name="ms" select="substring-before($time, '.')"/>

        <xsl:choose>
            <xsl:when test="$withMs = 'true'">
                <xsl:value-of select="concat($day, '.', $month, '.', $year, ' ', $time)"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="concat($day, '.', $month, '.', $year, ' ', $seconds)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
