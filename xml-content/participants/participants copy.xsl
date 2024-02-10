<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <!-- Header and Footer -->
    <xsl:include href="/utils/header.xsl"/>
    <xsl:include href="/utils/footer.xsl"/>

    <!-- Optional modular functionality -->
    <xsl:include href="/utils/concat_name.xsl"/>
    <xsl:include href="/utils/date_format.xsl"/>
    <xsl:include href="/utils/energy_transaction.xsl"/>

    <!-- The actual page -->
    <xsl:template match="/page">
        <html>
            <xsl:apply-templates select="title" mode="head"/>
            <body>
                <main>
                    <xsl:apply-templates select="/" mode="header"/>

                    <section>
                        <!-- content here -->
                    </section>

                    <xsl:apply-templates select="/" mode="footer"/>
                </main>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
