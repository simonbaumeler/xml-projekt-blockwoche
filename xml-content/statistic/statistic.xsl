<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:include href="/utils/header.xsl"/>
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
                        <h3>Balken Diagramm</h3>
                        <p>
                            Das Balkendiagramm zeigt die Gesamtenergie, die von verschiedenen Anbietern bereitgestellt wird, und ermöglichen es Ihnen, einen schnellen Überblick über die Leistung jedes Anbieters zu erhalten.
                        </p>
                        <!-- Bar Chart -->
                        <xsl:apply-templates select="document('/database.xml')/energie-data/participants" mode="barChart"/>
                        <h3>Trenddiagramm</h3>
                        <p>
                            Die Trenddiagramme hingegen veranschaulichen die zeitliche Entwicklung der Energieströme, wobei Sie die Möglichkeit haben, die Energieproduktion und -nutzung im Laufe der Zeit zu verfolgen und zu analysieren.
                        </p>
                        <!-- Trend Chart -->
                        <xsl:apply-templates select="document('/database.xml')/energie-data/participants/participant" mode="trendChart"/>
                    </section>
                    <xsl:apply-templates select="/" mode="footer"/>
                </main>
            </body>
        </html>
    </xsl:template>

    <!-- Bar Chart Template -->
    <xsl:template match="participants" mode="barChart">
        <svg:svg width="800" height="270">
            <!-- Draw y-axis -->
            <svg:line x1="40" y1="30" x2="40" y2="270" style="stroke:black;stroke-width:2"/>
            <svg:text x="40" y="20" font-family="Verdana" font-size="12" fill="black" transform="rotate(90,20,20)">
                <xsl:text>Energy Anbieter</xsl:text>
            </svg:text>
            <!-- Start of x-axis -->
            <svg:line x1="40" y1="30" x2="800" y2="30" style="stroke:black;stroke-width:2"/>
            <svg:text x="50" y="20" font-family="Verdana" font-size="12" fill="black" transform="rotate(0,20,20)">
                <xsl:text>Energy</xsl:text>
            </svg:text>
            <xsl:apply-templates select="participant"/>
        </svg:svg>
    </xsl:template>

    <!-- Bar for Each Participant -->
    <xsl:template match="participant">
        <xsl:variable name="totalEnergy" select="sum(energyTransactions/energyTransaction/@amount)"/>
        <xsl:variable name="barHeight" select="$totalEnergy * 10"/> <!-- Example calculation -->
        <xsl:variable name="yPosition" select="position() * 40"/> <!-- Adjust as needed -->

        <svg:rect x="50" y="{$yPosition}" width="{$barHeight}" height="30" style="fill:#FFC374;"/>
        <svg:text x="55" y="{$yPosition + 20}" font-family="Verdana" font-size="15" fill="#124076">
            <xsl:value-of select="name"/> -
            <xsl:value-of select="$totalEnergy"/>
        </svg:text>
    </xsl:template>

    <!-- Trend Chart Template -->
    <xsl:template match="participant" mode="trendChart">
        <xsl:variable name="energyProvider" select="name"/>
        <h4>
            <xsl:value-of select="$energyProvider"/>
        </h4>
        <svg:svg width="800" height="300">
            <xsl:call-template name="drawTrendChart">
                <xsl:with-param name="energyTransactions" select="energyTransactions/energyTransaction"/>
                <xsl:with-param name="energyProvider" select="$energyProvider"/>
            </xsl:call-template>
        </svg:svg>
    </xsl:template>

    <!-- Draw Trend Chart -->
    <xsl:template name="drawTrendChart">
        <xsl:param name="energyTransactions"/>
        <xsl:param name="energyProvider"/>
        <!-- Define axes -->
        <svg:line x1="40" y1="200" x2="750" y2="200" style="stroke:black;stroke-width:2"/>
        <svg:line x1="40" y1="200" x2="40" y2="0" style="stroke:black;stroke-width:2"/>
        <!-- Y-axis label -->
        <svg:text x="40" y="20" font-family="Verdana" font-size="12" fill="black" transform="rotate(90,20,20)">
            <xsl:text>Energy Menge</xsl:text>
        </svg:text>

        <!-- Define fixed y-coordinate for text elements -->
        <xsl:variable name="textY" select="210"/>

        <!-- Draw data points -->
        <xsl:for-each select="$energyTransactions">
            <!-- Initialize current total energy variable -->
            <xsl:variable name="currentTotal">
                <!-- Call calculateSum template to calculate sum of amounts from the first to current position -->
                <xsl:call-template name="calculateSum">
                    <xsl:with-param name="energyTransactions" select="$energyTransactions"/>
                    <!-- Specify the position as the number of energy transactions -->
                    <xsl:with-param name="position" select="position()"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="x" select="(position() - 1) * 20 + 50"/>
            <!-- Calculate y-coordinate based on the current total energy -->
            <xsl:variable name="y" select="200 - ($currentTotal * 2)"/>
            <!-- Draw data point -->
            <svg:circle cx="{$x}" cy="{$y}" r="3" fill="#124076"/>
            <!-- Display timestamp -->
            <svg:text x="{$x}" y="{$textY}" font-family="Verdana" font-size="10" fill="black" transform="rotate(45,{$x},{$textY})">
                <xsl:value-of select="substring-before(@timestamp, 'T')"/>
            </svg:text>
            <!-- Display amount -->
            <svg:text x="{$x - 5}" y="{$y - 10}" font-family="Verdana" font-size="10" fill="black">
                <xsl:value-of select="$currentTotal"/>
            </svg:text>
        </xsl:for-each>
    </xsl:template>


    <!-- Calculate Sum Template -->
    <xsl:template name="calculateSum">
        <xsl:param name="energyTransactions" select="/energie-data/participants/participant/energyTransactions/energyTransaction"/>
        <xsl:param name="position"/>
        <!-- Base case: when position is 0 or less, return 0 -->
        <xsl:if test="$position &lt;= 0">
            <xsl:value-of select="0"/>
        </xsl:if>
        <!-- Recursive case: calculate sum recursively -->
        <xsl:if test="$position &gt; 0">
            <!-- Recursive call to calculate sum for previous position -->
            <xsl:variable name="previousSum">
                <xsl:call-template name="calculateSum">
                    <xsl:with-param name="energyTransactions" select="$energyTransactions"/>
                    <xsl:with-param name="position" select="$position - 1"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Calculate sum of amounts up to nth position -->
            <xsl:variable name="currentSum">
                <xsl:value-of select="$previousSum + $energyTransactions[$position]/@amount"/>
            </xsl:variable>
            <!-- Return current sum -->
            <xsl:value-of select="$currentSum"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
