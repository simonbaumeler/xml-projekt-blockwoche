<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="../utils/concat_name.xsl"/>
    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="simple" page-height="11in" page-width="8.5in">
                    <fo:region-body margin-top="1cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="simple">
                <fo:flow flow-name="xsl-region-body">
                    <!-- Title -->
                    <fo:block font-size="18pt" font-weight="bold" text-align="center" space-after="12pt">
                        Energie Data Report
                    </fo:block>
                    <fo:block>
                        <xsl:apply-templates select="/energie-data/participants/participant"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <xsl:template match="/energie-data/participants/participant">
        <!-- Participant Name -->
        <fo:block space-before="12pt" font-weight="bold" text-align="center">
            Participant Name:
        </fo:block>
        <fo:block font-size="14pt" space-before="12pt" text-align="center">
            <xsl:apply-templates select="address"/>
        </fo:block>

        <!-- Start Date and Time -->
        <fo:block space-before="12pt" font-weight="bold" text-align="center">
            Start Date and Time:
        </fo:block>
        <fo:block space-after="6pt" text-align="center">
            <xsl:value-of select="startDatetime"/>
        </fo:block>

        <!-- Address Information -->
        <fo:block space-before="12pt" font-weight="bold" text-align="center">
            Address:
        </fo:block>
        <fo:block space-after="6pt" text-align="center">
            <xsl:value-of select="address/street"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="address/housenumber"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="address/city"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="address/state"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="address/country"/>
        </fo:block>

        <!-- Energy Transactions -->
        <fo:block space-before="12pt" font-weight="bold" text-align="center">
            Energy Transactions:
        </fo:block>
        <fo:block space-after="6pt" text-align="center">
            <fo:table>
                <!-- Table Column Definitions -->
                <fo:table-column column-width="1cm"/>
                <fo:table-column column-width="6cm"/>
                <fo:table-column column-width="2cm"/>
                <fo:table-column column-width="4cm"/>
                <fo:table-column column-width="2cm"/>
                <fo:table-column column-width="3cm"/>
                <fo:table-column column-width="3cm"/>

                <!-- Table Header -->
                <fo:table-header>
                    <fo:table-row>
                        <fo:table-cell font-weight="bold" text-align="center">
                            <fo:block>ID</fo:block>
                        </fo:table-cell>
                        <fo:table-cell font-weight="bold" text-align="center">
                            <fo:block>Transaction date</fo:block>
                        </fo:table-cell>
                        <fo:table-cell font-weight="bold" text-align="center">
                            <fo:block>Direction</fo:block>
                        </fo:table-cell>
                        <fo:table-cell font-weight="bold" text-align="center">
                            <fo:block>Energy Type</fo:block>
                        </fo:table-cell>
                        <fo:table-cell font-weight="bold" text-align="center">
                            <fo:block>Amount</fo:block>
                        </fo:table-cell>
                        <fo:table-cell font-weight="bold" text-align="center">
                            <fo:block>Rate Per Unit</fo:block>
                        </fo:table-cell>
                        <fo:table-cell font-weight="bold" text-align="center">
                            <fo:block>Total Price</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>

                <!-- Table Body -->
                <fo:table-body>
                    <xsl:for-each
                            select="energyTransactions/energyTransaction">
                        <fo:table-row>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <xsl:value-of select="position()"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <xsl:value-of select="@timestamp"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="@amount &gt; 0">
                                            <xsl:value-of select="'IN'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'OUT'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <xsl:value-of select="@energyType"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <xsl:value-of select="@amount"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <xsl:value-of select="@ratePerUnit"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <xsl:value-of select="@totalPrice"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </fo:block>
        <fo:block border-top-style="solid" text-align="center"></fo:block>
    </xsl:template>

    <xsl:template match="/energie-data/participants/participant/address">
        <xsl:call-template name="concat_name">
            <xsl:with-param name="firstname" select="firstname"/>
            <xsl:with-param name="middlename" select="middlename"/>
            <xsl:with-param name="lastname" select="lastname"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>