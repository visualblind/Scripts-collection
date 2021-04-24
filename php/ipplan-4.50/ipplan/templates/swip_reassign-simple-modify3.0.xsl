<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no"/>
Template: ARIN-REASSIGN-SIMPLE-3.0
1. Registration Action: M
2. Network Name: <xsl:value-of select="ntname"/>
3. IP Address and Prefix or Range: <xsl:value-of select="ntsnum"/> - <xsl:value-of select="ntenum"/>
4. Customer Name: <xsl:value-of select="org"/>
5a. Customer Address: <xsl:value-of select="street"/>
5b. Customer Address:
6. Customer City: <xsl:value-of select="city"/>
7. Customer State/Province: <xsl:value-of select="state"/>
8. Customer Postal Code: <xsl:value-of select="zipcode"/>
9. Customer Country Code: <xsl:value-of select="cntry"/>
10. Public Comments:
END OF TEMPLATE
</xsl:stylesheet>
