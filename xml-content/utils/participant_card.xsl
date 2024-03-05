<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/energie-data/participants/participant">
        <div class="participant-card">
            <div class="participant-card-header">
                <div class="title">
                    <xsl:value-of select="name" />
                </div>
                <div class="owner-name">
                    <xsl:apply-templates select="address" />
                </div>
                <div class="date">
                    <xsl:call-template name="date_format">
                        <xsl:with-param name="dateTime" select="startDatetime" />
                    </xsl:call-template>
                </div>
                <a href="/participant?id={id}">
                    Bearbeiten
                </a>
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