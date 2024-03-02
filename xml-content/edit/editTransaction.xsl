<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

    <xsl:include href="/utils/header.xsl" />
    <xsl:include href="/utils/footer.xsl" />
    <xsl:include href="/utils/energy_transaction.xsl" />
    <xsl:include href="/utils/concat_name.xsl" />
    <xsl:include href="/utils/participant_card.xsl" />

    <xsl:template match="/page">
        <html>
            <xsl:apply-templates select="title" mode="head" />
            <body>
                <main>
                    <xsl:apply-templates select="/" mode="header" />

                    <section>
                        <h1>
                            <xsl:value-of select="title" />
                        </h1>
                        <xsl:apply-templates select="//content/text" />
                        <form class="transaction-form" action="/addTransaction?id={id}"
                            method="post">
                            <label for="amount">Amount</label>
                            <input type="number" id="amount" name="amount" />

                            <label for="ratePerUnit">RatePerUnit</label>
                            <input type="number" id="ratePerUnit" name="ratePerUnit" />

                            <label for="date">Date</label>
                            <input type="date" id="date" name="date" />
                            <label for="time">Time</label>
                            <input type="time" id="time" name="time" />

                            <input type="submit" value="Submit" />
                        </form>
                        <xsl:variable name="selectedId" select="id" />
                        <xsl:apply-templates
                            select="document('/database.xml' )/ energie-data/ participants/ participant[id= $selectedId]" />
                    </section>

                    <xsl:apply-templates select="/" mode="footer" />
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="text">
        <p>
            <xsl:value-of select="." />
        </p>
    </xsl:template>

</xsl:stylesheet>