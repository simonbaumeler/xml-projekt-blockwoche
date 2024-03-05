<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

    <xsl:include href="/utils/header.xsl" />
    <xsl:include href="/utils/footer.xsl" />

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
                        <form class="form" action="/addParticipant" method="post">
                            <div>
                                <div>
                                    <label for="name">Name</label>
                                    <input type="text" id="name" name="name" required="true" />
                                </div>
                            </div>
                            <div>
                                <div>
                                    <label for="startDate">Start Date</label>
                                    <input type="date" id="startDate" name="startDate"
                                        required="true" />
                                </div>
                                <div>
                                    <label for="startTime">Start Time</label>
                                    <input type="time" id="startTime" name="startTime"
                                        required="true" />
                                </div>
                            </div>
                            <div>
                                <div>
                                    <label for="firstname">First Name</label>
                                    <input type="text" id="firstname" name="firstname"
                                        required="true" />
                                </div>
                                <div>
                                    <label for="middlename">Middle Name</label>
                                    <input type="text" id="middlename" name="middlename"
                                        required="true" />
                                </div>
                                <div>
                                    <label for="lastname">Last Name</label>
                                    <input type="text" id="lastname" name="lastname" required="true" />
                                </div>
                            </div>
                            <div>
                                <div>
                                    <label for="street">Street</label>
                                    <input type="text" id="street" name="street" required="true" />
                                </div>
                                <div>
                                    <label for="housenumber">House Number</label>
                                    <input type="text" id="housenumber" name="housenumber"
                                        required="true" />
                                </div>
                            </div>
                            <div>
                                <div>
                                    <label for="city">City</label>
                                    <input type="text" id="city" name="city" required="true" />
                                </div>
                                <div>
                                    <label for="state">State</label>
                                    <input type="text" id="state" name="state" required="true" />
                                </div>
                            </div>
                            <div>
                                <div>
                                    <label for="country">Country</label>
                                    <input type="text" id="country" name="country" required="true" />
                                </div>
                            </div>
                            <div>
                                <input type="submit" value="Hinzufügen" />
                            </div>
                        </form>
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