<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:include href="../utils/header.xsl"/>
    <xsl:include href="../utils/footer.xsl"/>

    <xsl:template match="/page">
        <html>
            <xsl:apply-templates select="title" mode="head"/>
            <body>
                <main>
                    <xsl:apply-templates select="/" mode="header"/>

                    <section>
                        <h1><xsl:value-of select="title"/></h1>
                        <xsl:apply-templates select="//content/text"/>
                        <xsl:apply-templates select="//content/button"/>
                    </section>

                    <xsl:apply-templates select="/" mode="footer"/>
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="text">
        <p>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>

    <xsl:template match="button">
        <button onclick="window.location.href='http://localhost:3000/pdf-report';">
            <xsl:value-of select="title"/>
        </button>
    </xsl:template>

</xsl:stylesheet>