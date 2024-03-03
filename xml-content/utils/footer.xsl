<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/" mode="footer">
        <footer>
            <div class="impressum-container">
                <div class="column">
                    <h4>Angaben gemäß § 5 TMG:</h4>
                    <p>EPASZ GmbH<br/>
                        Musterstraße 123<br/>
                        12345 Musterstadt</p>

                    <h4>Kontakt:</h4>
                    <p>Telefon: +49 (0)123 456789<br/>
                        Fax: +49 (0)123 456789<br/>
                        E-Mail: info@max-mustermann.de</p>
                </div>

                <div class="column">
                    <h4>Registereintrag:</h4>
                    <p>Eintragung im Handelsregister.<br/>
                        Registergericht: Amtsgericht Musterstadt<br/>
                        Registernummer: HRB 12345</p>

                    <h4>Umsatzsteuer-ID:</h4>
                    <p>Umsatzsteuer-Identifikationsnummer gemäß §27a Umsatzsteuergesetz:<br/>
                        DE 123456789</p>
                </div>

                <div class="column">
                    <h4>Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV:</h4>
                    <p>Max Mustermann<br/>
                        Musterstraße 123<br/>
                        12345 Musterstadt</p>
                </div>
            </div>

            <small>Copyright © by Team 01 - 2024. Alle Rechte vorbehalten.</small>
        </footer>
    </xsl:template>

</xsl:stylesheet>
