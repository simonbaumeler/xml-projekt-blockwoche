<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" >

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:include href="/utils/header.xsl"/>
    <xsl:include href="/utils/footer.xsl"/>
    <xsl:include href="/utils/footer.xsl"/>

    <xsl:template match="/page">
        <html>
            <xsl:apply-templates select="title" mode="head"/>
            <body>
                <main>
                    <xsl:apply-templates select="/" mode="header"/>

                    <section>
                        <h1>
                            <xsl:value-of select="title"/>
                        </h1>
                        <xsl:apply-templates select="//content/text"/>
                    </section>

                    <svg:svg width="800" height="500">
                        <!-- Draw y-axis -->
                        <svg:line x1="40" y1="30" x2="40" y2="300" style="stroke:black;stroke-width:2"/>
                        <svg:text x="40" y="20" font-family="Verdana" font-size="12" fill="black" transform="rotate(90,20,20)">
                            <xsl:text>Energy Anbieter</xsl:text>
                        </svg:text>
                        <!-- Start of x-axis -->
                        <svg:line x1="40" y1="30" x2="800" y2="30" style="stroke:black;stroke-width:2"/>
                        <svg:text x="50" y="20" font-family="Verdana" font-size="12" fill="black" transform="rotate(0,20,20)">
                            <xsl:text>Energy</xsl:text>
                        </svg:text>
                        <xsl:apply-templates select="document('/database.xml')/energie-data/participants"/>
                    </svg:svg>


                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="/energie-data/participants/participant">
        <xsl:variable name="totalEnergy" select="sum(energyTransactions/energyTransaction/@amount)"/>
        <xsl:variable name="barHeight" select="$totalEnergy * 10"/> <!-- Example calculation -->
        <xsl:variable name="yPosition" select="position() * 20"/> <!-- Adjust as needed -->

        <svg:rect x="50" y="{$yPosition}" width="{$barHeight}" height="30" style="fill:blue;"/>
        <svg:text x="55" y="{$yPosition + 20}" font-family="Verdana" font-size="15" fill="white">
            <xsl:value-of select="name"/> - <xsl:value-of select="$barHeight"/>
        </svg:text>
    </xsl:template>

</xsl:stylesheet>
