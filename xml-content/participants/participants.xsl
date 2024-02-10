<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:include href="/utils/header.xsl"/>
    <xsl:include href="/utils/footer.xsl"/>
    <xsl:include href="/utils/energy_transaction.xsl"/>
    <xsl:include href="/utils/concat_name.xsl"/>

    <xsl:template match="/page">
        <html>
            <xsl:apply-templates select="title" mode="head"/>
            <body>
                <main>
                    <xsl:apply-templates select="/" mode="header"/>

                    <section>
                        <h1><xsl:value-of select="title"/></h1>
                        <xsl:apply-templates select="//content/text"/>
                        <hr/>

                        <xsl:apply-templates select="document('/database.xml')/energie-data/participants" />
                    </section>

                    <xsl:apply-templates select="/" mode="footer"/>
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="/energie-data/participants/participant">
        <div class="participant-card">
            <div class="participant-card-header">
                <div class="title"><xsl:value-of select="name"/></div>
                <div class="owner-name">
                    <xsl:apply-templates select="address" />
                </div>
                <div class="date">
                    <xsl:call-template name="date_format">
                        <xsl:with-param name="dateTime" select="startDatetime" />
                    </xsl:call-template>
                </div>
            </div>
            <div class="participant-card-body">
                <xsl:apply-templates select="energyTransactions">
                    <xsl:sort select="timestamp" data-type="date" order="ascending" />
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="/energie-data/participants/participant/address">
        <div>
            <xsl:call-template name="concat_name">
                <xsl:with-param name="firstname" select="firstname" />
                <xsl:with-param name="middlename" select="middlename" />
                <xsl:with-param name="lastname" select="lastname" />
            </xsl:call-template>
        </div>
    </xsl:template>

</xsl:stylesheet>
