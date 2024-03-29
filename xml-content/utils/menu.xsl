<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:variable name="sites"
        select="'index:Home,participants:Participants,edit:Participant Hinzufügen,statistic:Statistik,report:Report generieren,'" /> <!--
    must end in ',' due to strange bug -->

    <xsl:template name="tokenizeSites">
        <xsl:param name="base"/>
        <xsl:param name="pair"/>
        <xsl:param name="potential_error"/>

        <xsl:choose>
            <xsl:when test="contains($pair, ':')">
                <xsl:variable name="tokenA" select="substring-before($pair, ':')"/>
                <xsl:variable name="tokenB" select="substring-after($pair, ':')"/>

                <xsl:choose>
                    <xsl:when test="/page/key = $tokenA">
                        <div class="navActiveDiv">

                            <a href="/{$tokenA}" class="active">
                                <xsl:value-of select="$tokenB" />
                            </a>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div>

                            <a href="/{$tokenA}">
                                <xsl:value-of select="$tokenB" />
                            </a>
                        </div>

                    </xsl:otherwise>
                </xsl:choose>

                <xsl:choose>
                    <xsl:when test="$base and string-length($base) > 1">
                        <xsl:call-template name="tokenizeSites">
                            <xsl:with-param name="base" select="$base"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>

            <xsl:when test="contains($base, ',')">
                <xsl:call-template name="tokenizeSites">
                    <xsl:with-param name="base" select="substring-after($base, ',')"/>
                    <xsl:with-param name="pair" select="substring-before($base, ',')"/>
                </xsl:call-template>
            </xsl:when>

            <!-- Why does this not work? -->
            <!--<xsl:when
            test="$base and not($potential_error)">
                <xsl:call-template name="tokenizeSites">
                    <xsl:with-param name="base" select="$base" />
                    <xsl:with-param name="pair" select="$base" />
                    <xsl:with-param name="potential_error" select="'yes'" />
                </xsl:call-template>
            </xsl:when>-->

        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>