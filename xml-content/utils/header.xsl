<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:include href="../utils/menu.xsl" />

    <xsl:template match="title" mode="head">
        <head>
            <title><xsl:value-of select="."/></title>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,width=device-width,user-scalable=no" />
            <link rel="icon" href="/favicon.ico" />
            <link rel="stylesheet" type="text/css" href="/theme.css" />
        </head>
    </xsl:template>

    <xsl:template match="/" mode="header">
        <header>
            <h1>EPAZS</h1>
            <h2>Energie-Preis-Auskunfts-Zentral-Stelle</h2>
        </header>
        <nav>
            <xsl:call-template name="tokenizeSites">
                <xsl:with-param name="base" select="$sites" />
            </xsl:call-template>
        </nav>
    </xsl:template>

</xsl:stylesheet>
