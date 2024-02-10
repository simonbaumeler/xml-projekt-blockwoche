<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:include href="/utils/date_format.xsl"/>
    
    <xsl:template match="energyTransactions">
        <table class="energy-transaction-table">
            <thead>
                <th>ID</th>
                <th>Transactiondate</th>
                <th>Direction</th>
                <th>EnergyType</th>
                <th>Amount</th>
                <th>RatePerUnit</th>
                <th>Total</th>
            </thead>
            <tbody>
                <xsl:apply-templates select="energyTransaction" />
            </tbody>
            <tfoot>
                <tr>
                    <th></th>
                    <th></th>
                    <th></th>
                    <th></th>
                    <th>
                        <xsl:text>Total: </xsl:text><xsl:value-of select="sum(./energyTransaction/@amount)"/>
                    </th>
                    <th>
                        <xsl:text>Total Avg. </xsl:text><xsl:value-of select="format-number((sum(./energyTransaction/@ratePerUnit) div count(./energyTransaction)), '0.0000')"/>
                    </th>
                    <th>
                        <xsl:value-of select="format-number(sum(./energyTransaction/@totalPrice), '0.0000')"/>
                    </th>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>
                        <xsl:text>Avg. </xsl:text><xsl:value-of select="format-number((sum(./energyTransaction[@amount &lt; 0]/@ratePerUnit) div count(./energyTransaction[@amount &gt; 0])), '0.0000')"/><xsl:text> (+)</xsl:text>
                    </td>
                    <td>
                        
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>
                        <xsl:text>Avg. </xsl:text><xsl:value-of select="format-number((sum(./energyTransaction[@amount &lt; 0]/@ratePerUnit) div count(./energyTransaction[@amount &lt; 0])), '0.0000')"/><xsl:text> (-)</xsl:text>
                    </td>
                    <td></td>
                </tr>
            </tfoot>
        </table>
    </xsl:template>

    <xsl:template match="energyTransaction">
        <tr>
            <td>
                <xsl:value-of select="position()"/>
            </td>
            <td>
                <xsl:call-template name="date_format">
                    <xsl:with-param name="dateTime" select="@timestamp" />
                </xsl:call-template>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="@amount &gt; 0">
                        <xsl:value-of select="'IN'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'OUT'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td><xsl:value-of select="@energyType"/></td>
            <td><xsl:value-of select="@amount"/></td>
            <td><xsl:value-of select="@ratePerUnit"/></td>
            <td><xsl:value-of select="@totalPrice"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
