<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no"/>
inetnum: <xsl:value-of select="ntsnum"/> - <xsl:value-of select="ntenum"/>
netname: <xsl:value-of select="orgid"/>
descr: <xsl:value-of select="org"/>
country: <xsl:value-of select="cntry"/>
admin-c: <xsl:value-of select="nichandl"/>
tech-c: <xsl:value-of select="techhandle"/>
status: <xsl:value-of select="assigntype"/>
remarks: <xsl:value-of select="remarks"/>
mnt-by: <xsl:value-of select="maint"/>
password: <xsl:value-of select="password"/>
changed: <xsl:value-of select="orgcontactinfo"/> <xsl:value-of select="date"/>
source: <xsl:value-of select="source"/>
</xsl:stylesheet>
