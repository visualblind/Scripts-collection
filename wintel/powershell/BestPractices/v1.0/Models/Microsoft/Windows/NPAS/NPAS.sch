<?xml version="1.0" encoding="UTF-8" ?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:mssml="http://schemas.microsoft.com/sml/extensions/2007/03"
    xmlns:mssmlbpa="http://schemas.microsoft.com/sml/bpa/2008/02">

    <ns prefix="tns" uri="http://schemas.microsoft.com/mbca/models/NPAS/2009/11" />
    <ns prefix="mssmltrans" uri="http://schemas.microsoft.com/sml/functions/transform/2007/03" />

  <pattern>
    <rule context="tns:NPAS/tns:NPSSERVER/tns:NpsServiceStatus">
      <assert
        mssmlbpa:helpID="NpsServiceStatus"
        mssml:severity="error"
        mssml:category="mssmlbpa:prerequisite mssmlbpa:markupv2"
        test=".= 'true'">

        <mssmlbpa:title mssml:locid="NpsServiceStatus_Title"/>
        <mssmlbpa:problem mssml:locid="NpsServiceStatus_Problem"/>
        <mssmlbpa:impact mssml:locid="NpsServiceStatus_Impact"/>
        <mssmlbpa:resolution mssml:locid="NpsServiceStatus_Resolution"/>
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=155347</mssmlbpa:helpTopic>
      </assert>
      <report
          mssmlbpa:helpID="NpsServiceStatus"
          mssml:severity="info"
          mssml:category="mssmlbpa:prerequisite mssmlbpa:markupv2"
          test=".= 'true'">

        <mssmlbpa:title mssml:locid="NpsServiceStatus_Title"/>
        <mssmlbpa:compliant mssml:locid="NpsServiceStatus_Compliant"/>
      </report>
    </rule>
  </pattern>

  <pattern>
    <rule context="tns:NPAS/tns:NPSSERVER/tns:NpsCrpEnabled">
      <assert
        mssmlbpa:helpID="NpsCrpEnabled"
        mssml:severity="error"
        mssml:category="mssmlbpa:configuration mssmlbpa:markupv2"
        test=".= 'true'">

        <mssmlbpa:title mssml:locid="NpsCrpEnabled_Title"/>
        <mssmlbpa:problem mssml:locid="NpsCrpEnabled_Problem"/>
        <mssmlbpa:impact mssml:locid="NpsCrpEnabled_Impact"/>
        <mssmlbpa:resolution mssml:locid="NpsCrpEnabled_Resolution"/>
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=155350</mssmlbpa:helpTopic>
      </assert>
      <report
          mssmlbpa:helpID="NpsCrpEnabled"
          mssml:severity="info"
          mssml:category="mssmlbpa:configuration mssmlbpa:markupv2"
          test=".= 'true'">

        <mssmlbpa:title mssml:locid="NpsCrpEnabled_Title"/>
        <mssmlbpa:compliant mssml:locid="NpsCrpEnabled_Compliant"/>
      </report>
    </rule>
  </pattern>

  <pattern>
    <rule context="tns:NPAS/tns:NPSSERVER/tns:NpsNetworkPolicyEnabled">
      <assert
        mssmlbpa:helpID="NpsNetworkPolicyEnabled"
        mssml:severity="error"
        mssml:category="mssmlbpa:configuration mssmlbpa:markupv2"
        test=".= 'true'">

        <mssmlbpa:title mssml:locid="NpsNetworkPolicyEnabled_Title"/>
        <mssmlbpa:problem mssml:locid="NpsNetworkPolicyEnabled_Problem"/>
        <mssmlbpa:impact mssml:locid="NpsNetworkPolicyEnabled_Impact"/>
        <mssmlbpa:resolution mssml:locid="NpsNetworkPolicyEnabled_Resolution"/>
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=155351</mssmlbpa:helpTopic>
      </assert>
      <report
          mssmlbpa:helpID="NpsNetworkPolicyEnabled"
          mssml:severity="info"
          mssml:category="mssmlbpa:configuration mssmlbpa:markupv2"
          test=".= 'true'">

        <mssmlbpa:title mssml:locid="NpsNetworkPolicyEnabled_Title"/>
        <mssmlbpa:compliant mssml:locid="NpsNetworkPolicyEnabled_Compliant"/>
      </report>
    </rule>
  </pattern>

  <pattern>
    <rule context="tns:NPAS/tns:NPSSERVER/tns:NpsAuthentication">
      <assert
        mssmlbpa:helpID="NpsAuthentication"
        mssml:severity="warning"
        mssml:category="mssmlbpa:configuration mssmlbpa:markupv2"
        test="tns:Supported = 'true'">

        <value-of select="tns:CRPPolicyNames" />
        <value-of select="tns:NPPolicyNames" />
        <mssmlbpa:title mssml:locid="NpsAuthentication_Title"/>
        <mssmlbpa:problem mssml:locid="NpsAuthentication_Problem"/>
        <mssmlbpa:impact mssml:locid="NpsAuthentication_Impact"/>
        <mssmlbpa:resolution mssml:locid="NpsAuthentication_Resolution"/>
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=155356</mssmlbpa:helpTopic>
      </assert>
      <report
          mssmlbpa:helpID="NpsAuthentication"
          mssml:severity="info"
          mssml:category="mssmlbpa:configuration mssmlbpa:markupv2"
          test="tns:Supported = 'true'">

        <mssmlbpa:title mssml:locid="NpsAuthentication_Title"/>
        <mssmlbpa:compliant mssml:locid="NpsAuthentication_Compliant"/>
      </report>
    </rule>
  </pattern>

  <pattern>
    <rule context="tns:NPAS/tns:NPSSERVER/tns:NasRunningLocally">
      <assert
        mssmlbpa:helpID="NasRunningLocally"
        mssml:severity="error"
        mssml:category="mssmlbpa:configuration mssmlbpa:markupv2"
        test=".= 'true'">

        <mssmlbpa:title mssml:locid="NasRunningLocally_Title"/>
        <mssmlbpa:problem mssml:locid="NasRunningLocally_Problem"/>
        <mssmlbpa:impact mssml:locid="NasRunningLocally_Impact"/>
        <mssmlbpa:resolution mssml:locid="NasRunningLocally_Resolution"/>
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=155348</mssmlbpa:helpTopic>
      </assert>
      <report
          mssmlbpa:helpID="NasRunningLocally"
          mssml:severity="info"
          mssml:category="mssmlbpa:configuration mssmlbpa:markupv2"
          test=".= 'true'">

        <mssmlbpa:title mssml:locid="NasRunningLocally_Title"/>
        <mssmlbpa:compliant mssml:locid="NasRunningLocally_Compliant"/>
      </report>
    </rule>
  </pattern>

</schema>
