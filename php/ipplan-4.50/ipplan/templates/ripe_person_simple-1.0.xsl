<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no"/>
person: <xsl:value-of select="fname"/> <xsl:value-of select="lname"/>
org: <xsl:value-of select="torg"/>
address: <xsl:value-of select="tstreet"/>
address: <xsl:value-of select="tcity"/>
address: <xsl:value-of select="tcntry"/>
phone: <xsl:value-of select="phne"/>
email: <xsl:value-of select="mbox"/>
nic-hdl: AUTO-1
abuse-mailbox: <xsl:value-of select="orgcontactinfo"/>
mnt-by: <xsl:value-of select="maint"/>
password: <xsl:value-of select="password"/>
changed: <xsl:value-of select="orgcontactinfo"/> <xsl:value-of select="date"/>
source: <xsl:value-of select="source"/>
</xsl:stylesheet>
