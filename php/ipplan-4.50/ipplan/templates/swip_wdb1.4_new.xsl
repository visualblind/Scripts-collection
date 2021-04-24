<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no"/>
WDB_version: 1.4
---
(N)new (M)modify (D)delete: N
(A)allocate (S)assign: S
---
ntsnum: <xsl:value-of select="ntsnum"/>
ntenum: <xsl:value-of select="ntenum"/>
ntname: <xsl:value-of select="ntname"/>
org: <xsl:value-of select="org"/>
street: <xsl:value-of select="street"/>
city: <xsl:value-of select="city"/>
state: <xsl:value-of select="state"/>
zipcode: <xsl:value-of select="zipcode"/>
cntry: <xsl:value-of select="cntry"/>
maint: <xsl:value-of select="maint"/>
---
hname: <xsl:value-of select="hname1"/>
ipaddr: <xsl:value-of select="ipaddr1"/>
---
hname: <xsl:value-of select="hname2"/>
ipaddr: <xsl:value-of select="hname2"/>
---
hname: <xsl:value-of select="hname3"/>
ipaddr: <xsl:value-of select="hname3"/>
---
nichandl: <xsl:value-of select="nichandl"/>
lname: <xsl:value-of select="lname"/>
fname: <xsl:value-of select="fname"/>
mname: <xsl:value-of select="mname"/>
org: <xsl:value-of select="torg"/>
street: <xsl:value-of select="tstreet"/>
city: <xsl:value-of select="tcity"/>
state: <xsl:value-of select="tstate"/>
zipcode: <xsl:value-of select="tzipcode"/>
cntry: <xsl:value-of select="tcntry"/>
phne: <xsl:value-of select="phne"/>
mbox: <xsl:value-of select="mbox"/>
END OF FILE
</xsl:stylesheet>
