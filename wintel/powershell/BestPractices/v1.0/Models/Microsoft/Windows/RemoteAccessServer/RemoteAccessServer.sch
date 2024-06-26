<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:mssml="http://schemas.microsoft.com/sml/extensions/2007/03"
    xmlns:mssmlbpa="http://schemas.microsoft.com/sml/bpa/2008/02">

    <ns prefix="tns" uri="http://schemas.microsoft.com/bestpractices/models/ServerManager/RemoteAccess/2008/04" />
    <ns prefix="mssmltrans" uri="http://schemas.microsoft.com/sml/functions/transform/2007/03" />

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:VPNEnabled">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153257</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRASDisabled_title"/>
                <mssmlbpa:problem mssml:locid = "RRASDisabled_problem"/>
                <mssmlbpa:impact mssml:locid = "RRASDisabled_impact"/>
                <mssmlbpa:resolution mssml:locid = "RRASDisabled_resolution"/>
            </assert>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153257</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRASDisabled_title"/>
                <mssmlbpa:compliant mssml:locid = "RRASDisabled_compliant"/>
            </report>

        </rule>
    </pattern>
 
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DAEnabled">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244310</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DirectAccessDisabled_title"/>
                <mssmlbpa:problem mssml:locid = "DirectAccessDisabled_problem"/>
                <mssmlbpa:impact mssml:locid = "DirectAccessDisabled_impact"/>
                <mssmlbpa:resolution mssml:locid = "DirectAccessDisabled_resolution"/>
            </assert>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244310</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DirectAccessDisabled_title"/>
                <mssmlbpa:compliant mssml:locid = "DirectAccessDisabled_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RRASRunning">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153258</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRASStopped_title"/>
                <mssmlbpa:problem mssml:locid = "RRASStopped_problem"/>
                <mssmlbpa:impact mssml:locid = "RRASStopped_impact"/>
                <mssmlbpa:resolution mssml:locid = "RRASStopped_resolution"/>
            </assert>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153258</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRASStopped_title"/>
                <mssmlbpa:compliant mssml:locid = "RRASStopped_compliant"/>
            </report>

        </rule>
    </pattern>
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:VpnEnabled">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153259</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "VPNConfigured_title"/>
                <mssmlbpa:problem mssml:locid = "VPNConfigured_problem"/>
                <mssmlbpa:impact mssml:locid = "VPNConfigured_impact"/>
                <mssmlbpa:resolution mssml:locid = "VPNConfigured_resolution"/>
            </assert>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153259</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "VPNConfigured_title"/>
                <mssmlbpa:compliant mssml:locid = "VPNConfigured_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:LoggingEnabled">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153260</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "EventLog_title"/>
                <mssmlbpa:problem mssml:locid = "EventLog_problem"/>
                <mssmlbpa:impact mssml:locid = "EventLog_impact"/>
                <mssmlbpa:resolution mssml:locid = "EventLog_resolution"/>
            </assert>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153260</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "EventLog_title"/>
                <mssmlbpa:compliant mssml:locid = "EventLog_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:RRASRunning = 'true']/tns:InterfaceList/tns:AllInterfaceDisabled">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'All' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153261</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InterfaceEnabled_title"/>
                <mssmlbpa:problem mssml:locid = "InterfaceEnabled_problem"/>
                <mssmlbpa:impact mssml:locid = "InterfaceEnabled_impact"/>
                <mssmlbpa:resolution mssml:locid = "InterfaceEnabled_resolution"/>
            </report>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'None' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153261</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InterfaceEnabled_title"/>
                <mssmlbpa:compliant mssml:locid = "InterfaceEnabled_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and tns:RRASRunning = 'true']/tns:InterfaceList[tns:AllInterfaceDisabled = 'Some']/tns:Interface">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:Enabled = 'true' ">
                <value-of  select="tns:IfName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153262</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InterfaceDisabled_title"/>
                <mssmlbpa:problem mssml:locid = "InterfaceDisabled_problem"/>
                <mssmlbpa:impact mssml:locid = "InterfaceDisabled_impact"/>
                <mssmlbpa:resolution mssml:locid = "InterfaceDisabled_resolution"/>
            </assert>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and tns:RRASRunning = 'true']/tns:InterfaceList/tns:AllEnabledIfReachable">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'None' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153263</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InterfaceReachable_title"/>
                <mssmlbpa:problem mssml:locid = "InterfaceReachable_problem"/>
                <mssmlbpa:impact mssml:locid = "InterfaceReachable_impact"/>
                <mssmlbpa:resolution mssml:locid = "InterfaceReachable_resolution"/>
            </report>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'All' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153263</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InterfaceReachable_title"/>
                <mssmlbpa:compliant mssml:locid = "InterfaceReachable_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and tns:RRASRunning = 'true']/tns:InterfaceList[tns:AllEnabledIfReachable = 'Some']/tns:Interface[tns:Enabled = 'true']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:Reachable = 'true' ">
                <value-of  select="tns:IfName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153264</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InterfaceUnReachable_title"/>
                <mssmlbpa:problem mssml:locid = "InterfaceUnReachable_problem"/>
                <mssmlbpa:impact mssml:locid = "InterfaceUnReachable_impact"/>
                <mssmlbpa:resolution mssml:locid = "InterfaceUnReachable_resolution"/>
            </assert>

        </rule>
    </pattern>


    <pattern>
        <rule context = "tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and tns:RRASRunning = 'true']/tns:IPv4Router[tns:RoutingConfigured = 'true']">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:ForwardingEnabled = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153265</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv4Router_title"/>
                <mssmlbpa:problem mssml:locid = "IPv4Router_problem"/>
                <mssmlbpa:impact mssml:locid = "IPv4Router_impact"/>
                <mssmlbpa:resolution mssml:locid = "IPv4Router_resolution"/>
            </assert>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:ForwardingEnabled = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153265</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv4Router_title"/>
                <mssmlbpa:compliant mssml:locid = "IPv4Router_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and tns:RRASRunning = 'true']/tns:IPv6Router[tns:RoutingConfigured = 'true']">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:ForwardingEnabled = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153266</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv6Router_title"/>
                <mssmlbpa:problem mssml:locid = "IPv6Router_problem"/>
                <mssmlbpa:impact mssml:locid = "IPv6Router_impact"/>
                <mssmlbpa:resolution mssml:locid = "IPv6Router_resolution"/>
            </assert>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:ForwardingEnabled = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153266</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv6Router_title"/>
                <mssmlbpa:compliant mssml:locid = "IPv6Router_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "count(tns:IPv4Router) = 1 ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153267</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv4Routing_title"/>
                <mssmlbpa:problem mssml:locid = "IPv4Routing_problem"/>
                <mssmlbpa:impact mssml:locid = "IPv4Routing_impact"/>
                <mssmlbpa:resolution mssml:locid = "IPv4Routing_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "count(tns:IPv4Router) = 1 ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153267</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv4Routing_title"/>
                <mssmlbpa:compliant mssml:locid = "IPv4Routing_compliant"/>
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "count(tns:IPv6Router) = 1 ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153269</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv6Routing_title"/>
                <mssmlbpa:problem mssml:locid = "IPv6Routing_problem"/>
                <mssmlbpa:impact mssml:locid = "IPv6Routing_impact"/>
                <mssmlbpa:resolution mssml:locid = "IPv6Routing_resolution"/>
            </assert>


            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "count(tns:IPv6Router) = 1 ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153269</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv6Routing_title"/>
                <mssmlbpa:compliant mssml:locid = "IPv6Routing_compliant"/>
            </report>

        </rule>
    </pattern>


    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:AllPortsDisabled">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153270</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "Ports_title"/>
                <mssmlbpa:problem mssml:locid = "Ports_problem"/>
                <mssmlbpa:impact mssml:locid = "Ports_impact"/>
                <mssmlbpa:resolution mssml:locid = "Ports_resolution"/>
            </report>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153270</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "Ports_title"/>
                <mssmlbpa:compliant mssml:locid = "Ports_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and count(tns:AllPortsDisabled) = 0]/tns:Port">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:Protocol != 'PPTP' and tns:PortCount = '0' ">
                <value-of select="tns:Protocol" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153271</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "PortProtocol_title"/>
                <mssmlbpa:problem mssml:locid = "PortProtocol_problem"/>
                <mssmlbpa:impact mssml:locid = "PortProtocol_impact"/>
                <mssmlbpa:resolution mssml:locid = "PortProtocol_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and count(tns:AllPortsDisabled) = 0]/tns:Port[tns:Protocol = 'PPTP']">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:PortCount = '1' ">
                <value-of select="tns:Protocol" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153271</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "PortProtocolPPTP_title"/>
                <mssmlbpa:problem mssml:locid = "PortProtocolPPTP_problem"/>
                <mssmlbpa:impact mssml:locid = "PortProtocol_impact"/>
                <mssmlbpa:resolution mssml:locid = "PortProtocol_resolution"/>
            </report>

        </rule>
    </pattern>


    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and tns:RRASRunning = 'true']/tns:IKEEXTRunning">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153272</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IKEv2Service_title"/>
                <mssmlbpa:problem mssml:locid = "IKEv2Service_problem"/>
                <mssmlbpa:impact mssml:locid = "IKEv2Service_impact"/>
                <mssmlbpa:resolution mssml:locid = "IKEv2Service_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153272</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IKEv2Service_title"/>
                <mssmlbpa:compliant mssml:locid = "IKEv2Service_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:InterfaceList[tns:DemandDialInterfaceExists = 'true']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "../tns:IPv4Router/tns:LanAndDemandDialEnabled = 'true' or ../tns:IPv6Router/tns:LanAndDemandDialEnabled = 'true'  ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153276</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DemandDial_title"/>
                <mssmlbpa:problem mssml:locid = "DemandDial_problem"/>
                <mssmlbpa:impact mssml:locid = "DemandDial_impact"/>
                <mssmlbpa:resolution mssml:locid = "DemandDial_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "../tns:IPv4Router/tns:LanAndDemandDialEnabled = 'true' or ../tns:IPv6Router/tns:LanAndDemandDialEnabled = 'true'  ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153276</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DemandDial_title"/>
                <mssmlbpa:compliant mssml:locid = "DemandDial_compliant"/>
            </report>

        </rule>
    </pattern>




    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and (tns:IPv4Router/tns:LanAndDemandDialEnabled = 'true' or tns:IPv6Router/tns:LanAndDemandDialEnabled = 'true')]/tns:InterfaceList/tns:Interface[tns:IfType = 'ROUTER_IF_TYPE_FULL_ROUTER']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:security mssmlbpa:markupv2"
               test = "tns:EncryptionAllowed = 'true' ">
                <value-of select="tns:IfName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153277</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DemandDialEncrypt_title"/>
                <mssmlbpa:problem mssml:locid = "DemandDialEncrypt_problem"/>
                <mssmlbpa:impact mssml:locid = "DemandDialEncrypt_impact"/>
                <mssmlbpa:resolution mssml:locid = "DemandDialEncrypt_resolution"/>
            </assert>

        </rule>
    </pattern>



    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:InterfaceList/tns:VerifyDhcpRelayStatusV4">
            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'IfAddedWithDHCPRelayEnabled' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153280</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DhcpRelayServersInterfaceV4_title"/>
                <mssmlbpa:problem mssml:locid = "DhcpRelayServersInterfaceV4_problem"/>
                <mssmlbpa:impact mssml:locid = "DhcpRelayServersInterfaceV4_impact"/>
                <mssmlbpa:resolution mssml:locid = "DhcpRelayServersInterfaceV4_resolution"/>
            </assert>

            <report
                mssml:severity = "info"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = ". = 'IfAddedWithDHCPRelayEnabled' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153280</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DhcpRelayServersInterfaceV4_title"/>
                <mssmlbpa:compliant mssml:locid = "DhcpRelayServersInterfaceV4_compliant"/>
            </report>

        </rule>
    </pattern>


    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:InterfaceList/tns:VerifyDhcpRelayStatusV6">
            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'IfAddedWithDHCPRelayEnabled' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153282</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DhcpRelayServersInterfaceV6_title"/>
                <mssmlbpa:problem mssml:locid = "DhcpRelayServersInterfaceV6_problem"/>
                <mssmlbpa:impact mssml:locid = "DhcpRelayServersInterfaceV6_impact"/>
                <mssmlbpa:resolution mssml:locid = "DhcpRelayServersInterfaceV6_resolution"/>
            </assert>

            <report
                mssml:severity = "info"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = ".= 'IfAddedWithDHCPRelayEnabled' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153282</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DhcpRelayServersInterfaceV6_title"/>
                <mssmlbpa:compliant mssml:locid = "DhcpRelayServersInterfaceV6_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:DHCPServersAddedV4">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153278</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DhcpRelayServersV4_title"/>
                <mssmlbpa:problem mssml:locid = "DhcpRelayServersV4_problem"/>
                <mssmlbpa:impact mssml:locid = "DhcpRelayServersV4_impact"/>
                <mssmlbpa:resolution mssml:locid = "DhcpRelayServersV4_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153278</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DhcpRelayServersV4_title"/>
                <mssmlbpa:compliant mssml:locid = "DhcpRelayServersV4_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:DHCPServersAddedV6">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153279</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DhcpRelayServersV6_title"/>
                <mssmlbpa:problem mssml:locid = "DhcpRelayServersV6_problem"/>
                <mssmlbpa:impact mssml:locid = "DhcpRelayServersV6_impact"/>
                <mssmlbpa:resolution mssml:locid = "DhcpRelayServersV6_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153279</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DhcpRelayServersV6_title"/>
                <mssmlbpa:compliant mssml:locid = "DhcpRelayServersV6_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:ValidIKEv2Certificates">

            <report
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = ". = 'InvalidCert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153724</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IKEv2Certificate_title"/>
                <mssmlbpa:problem mssml:locid = "IKEv2Certificate_problem"/>
                <mssmlbpa:impact mssml:locid = "IKEv2Certificate_impact"/>
                <mssmlbpa:resolution mssml:locid = "IKEv2Certificate_resolution"/>
            </report>

            <report
                mssml:severity = "info"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = ". = 'ValidCert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153724</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IKEv2Certificate_title"/>
                <mssmlbpa:compliant mssml:locid = "IKEv2Certificate_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:ValidIKEv2Certificates">

            <report
                  mssml:severity = "warning"
                  mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                  test = ". = 'ValidOrInvalidCert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153273</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IKEv2CertificateForNAT_title"/>
                <mssmlbpa:problem mssml:locid = "IKEv2CertificateForNAT_problem"/>
                <mssmlbpa:impact mssml:locid = "IKEv2CertificateForNAT_impact"/>
                <mssmlbpa:resolution mssml:locid = "IKEv2CertificateForNAT_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and tns:ValidIKEv2Certificates = 'ValidCert']">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:IKEv2CertIkeIntermediate = 'NoValidIKECert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153283</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IKEv2CertificateIKEINTERMEDIATE_title"/>
                <mssmlbpa:problem mssml:locid = "IKEv2CertificateIKEINTERMEDIATE_problem"/>
                <mssmlbpa:impact mssml:locid = "IKEv2CertificateIKEINTERMEDIATE_impact"/>
                <mssmlbpa:resolution mssml:locid = "IKEv2CertificateIKEINTERMEDIATE_resolution"/>
            </report>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:IKEv2CertIkeIntermediate = 'OneValidIKECert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153283</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IKEv2CertificateIKEINTERMEDIATE_title"/>
                <mssmlbpa:compliant mssml:locid = "IKEv2CertificateIKEINTERMEDIATE_compliant"/>
            </report>

        </rule>
    </pattern>


    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:ValidSSTPCertificates">

            <report
                  mssml:severity = "error"
                  mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                  test = ". = 'InvalidCert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153725</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "SSTPCertificate_title"/>
                <mssmlbpa:problem mssml:locid = "SSTPCertificate_problem"/>
                <mssmlbpa:impact mssml:locid = "SSTPCertificate_impact"/>
                <mssmlbpa:resolution mssml:locid = "SSTPCertificate_resolution"/>
            </report>

            <report
                  mssml:severity = "info"
                  mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                  test = ". = 'ValidCert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153725</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "SSTPCertificate_title"/>
                <mssmlbpa:compliant mssml:locid = "SSTPCertificate_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:ValidSSTPCertificates">

            <report
                  mssml:severity = "warning"
                  mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                  test = ". = 'ValidOrInvalidCert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153275</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "SSTPCertificateForNAT_title"/>
                <mssmlbpa:problem mssml:locid = "SSTPCertificateForNAT_problem"/>
                <mssmlbpa:impact mssml:locid = "SSTPCertificateForNAT_impact"/>
                <mssmlbpa:resolution mssml:locid = "SSTPCertificateForNAT_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true' and tns:ValidSSTPCertificates != 'InvalidCert']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:SSTPDefaultCert = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153284</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "SSTPCertificateDefault_title"/>
                <mssmlbpa:problem mssml:locid = "SSTPCertificateDefault_problem"/>
                <mssmlbpa:impact mssml:locid = "SSTPCertificateDefault_impact"/>
                <mssmlbpa:resolution mssml:locid = "SSTPCertificateDefault_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:SSTPDefaultCert = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153284</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "SSTPCertificateDefault_title"/>
                <mssmlbpa:compliant mssml:locid = "SSTPCertificateDefault_compliant"/>
            </report>

        </rule>
    </pattern>


    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "count(tns:CertInvalidName) = 1 ">
                <value-of  select="tns:CertInvalidName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153285</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NATCertificate_title"/>
                <mssmlbpa:problem mssml:locid = "NATCertificate_problem"/>
                <mssmlbpa:impact mssml:locid = "NATCertificate_impact"/>
                <mssmlbpa:resolution mssml:locid = "NATCertificate_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:AuthenticationMethods">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153287</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "Authentication_title"/>
                <mssmlbpa:problem mssml:locid = "Authentication_problem"/>
                <mssmlbpa:impact mssml:locid = "Authentication_impact"/>
                <mssmlbpa:resolution mssml:locid = "Authentication_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153287</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "Authentication_title"/>
                <mssmlbpa:compliant mssml:locid = "Authentication_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RasAdapter">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153286</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RasAdapter_title"/>
                <mssmlbpa:problem mssml:locid = "RasAdapter_problem"/>
                <mssmlbpa:impact mssml:locid = "RasAdapter_impact"/>
                <mssmlbpa:resolution mssml:locid = "RasAdapter_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153286</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RasAdapter_title"/>
                <mssmlbpa:compliant mssml:locid = "RasAdapter_compliant"/>
            </report>
        </rule>
    </pattern>

    <!--Default gate way should be configured on external NIC if topology is Edge-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA[tns:Topology = 'Edge' ]/tns:InterfaceList/tns:ExternalInterface[tns:v4 = 'true' or tns:v6 = 'true']">
            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " (tns:v4 = 'true' and (count(tns:v4DefaultGateway) = 1) and (count(tns:v6DefaultGateway) = 1)) or 
                  (tns:v4 = 'false' and tns:v6 = 'true' and (count(tns:v6DefaultGateway) = 1))">
                <value-of  select="tns:Name" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244311</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ExtDefaultGateway_title"/>
                <mssmlbpa:problem mssml:locid = "ExtDefaultGateway_problem"/>
                <mssmlbpa:impact mssml:locid = "ExtDefaultGateway_impact"/>
                <mssmlbpa:resolution mssml:locid = "ExtDefaultGateway_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " (tns:v4 = 'true' and (count(tns:v4DefaultGateway) = 1) and (count(tns:v6DefaultGateway) = 1)) or 
                  (tns:v4 = 'false' and tns:v6 = 'true' and (count(tns:v6DefaultGateway) = 1))">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244311</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ExtDefaultGateway_title"/>
                <mssmlbpa:compliant mssml:locid = "ExtDefaultGateway_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--Default gate way must be configures on internal NIC if topology is != Edge-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA[tns:Topology != 'Edge' ]/tns:InterfaceList/tns:InternalInterface[tns:v4 = 'true' or tns:v6 = 'true']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " ( tns:v4 = 'true' and tns:v6 = 'false' and (count(tns:v4DefaultGateway) = 1) ) or 
		              ( tns:v4 = 'false' and tns:v6 = 'true' and (count(tns:v6DefaultGateway) = 1) ) or 
		              ( tns:v4 = 'true' and tns:v6 = 'true' and (count(tns:v4DefaultGateway) = 1) and (count(tns:v6DefaultGateway) = 1) )">
                <value-of  select="tns:Name" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244311</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IntDefaultGateway_title"/>
                <mssmlbpa:problem mssml:locid = "IntDefaultGateway_problem"/>
                <mssmlbpa:impact mssml:locid = "IntDefaultGateway_impact"/>
                <mssmlbpa:resolution mssml:locid = "IntDefaultGateway_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " ( tns:v4 = 'true' and tns:v6 = 'false' and (count(tns:v4DefaultGateway) = 1) ) or 
		              ( tns:v4 = 'false' and tns:v6 = 'true' and (count(tns:v6DefaultGateway) = 1) ) or 
		              ( tns:v4 = 'true' and tns:v6 = 'true' and (count(tns:v4DefaultGateway) = 1) and (count(tns:v6DefaultGateway) = 1) )">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244311</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IntDefaultGateway_title"/>
                <mssmlbpa:compliant mssml:locid = "IntDefaultGateway_compliant"/>
            </report>

        </rule>
    </pattern>



    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:InterfaceList/tns:InternalInterface/tns:MultipleNic">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244312</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MultipleInternalInterface_title"/>
                <mssmlbpa:problem mssml:locid = "MultipleInternalInterface_problem"/>
                <mssmlbpa:impact mssml:locid = "MultipleInternalInterface_impact"/>
                <mssmlbpa:resolution mssml:locid = "MultipleInternalInterface_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244312</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MultipleInternalInterface_title"/>
                <mssmlbpa:compliant mssml:locid = "MultipleInternalInterface_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:InterfaceList/tns:ExternalInterface/tns:MultipleNic">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244313</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MultipleExternalInterface_title"/>
                <mssmlbpa:problem mssml:locid = "MultipleExternalInterface_problem"/>
                <mssmlbpa:impact mssml:locid = "MultipleExternalInterface_impact"/>
                <mssmlbpa:resolution mssml:locid = "MultipleExternalInterface_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244313</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MultipleExternalInterface_title"/>
                <mssmlbpa:compliant mssml:locid = "MultipleExternalInterface_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--DA SHOULD NOT HAVE NATIVE IPV6 INTERNAL INTERFACE AND ISATAP NIC -->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:InterfaceList/tns:InternalInterface[tns:InterfaceConfigType = 'PureV6']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "../../tns:IsatapResolving = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244316</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NativeIPv6OnInternalInterface_title"/>
                <mssmlbpa:problem mssml:locid = "NativeIPv6OnInternalInterface_problem"/>
                <mssmlbpa:impact mssml:locid = "NativeIPv6OnInternalInterface_impact"/>
                <mssmlbpa:resolution mssml:locid = "NativeIPv6OnInternalInterface_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "../../tns:IsatapResolving = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244316</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NativeIPv6OnInternalInterface_title"/>
                <mssmlbpa:compliant mssml:locid = "NativeIPv6OnInternalInterface_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- IPV6 should be enabled on the interfaces-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:InterfaceList/tns:ExternalInterface/tns:v6checkbox">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true'">
                <value-of  select="../tns:Name" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244314</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ExternalInterfaceIPv6Checked_title"/>
                <mssmlbpa:problem mssml:locid = "ExternalInterfaceIPv6Checked_problem"/>
                <mssmlbpa:impact mssml:locid = "ExternalInterfaceIPv6Checked_impact"/>
                <mssmlbpa:resolution mssml:locid = "ExternalInterfaceIPv6Checked_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true'">
                <value-of  select="../tns:Name" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244314</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ExternalInterfaceIPv6Checked_title"/>
                <mssmlbpa:compliant mssml:locid = "ExternalInterfaceIPv6Checked_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:InterfaceList/tns:InternalInterface/tns:v6checkbox">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true'">
                <value-of  select="../tns:Name" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244315</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InternalInterfaceIPv6Checked_title"/>
                <mssmlbpa:problem mssml:locid = "InternalInterfaceIPv6Checked_problem"/>
                <mssmlbpa:impact mssml:locid = "InternalInterfaceIPv6Checked_impact"/>
                <mssmlbpa:resolution mssml:locid = "InternalInterfaceIPv6Checked_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true'">
                <value-of  select="../tns:Name" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244315</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InternalInterfaceIPv6Checked_title"/>
                <mssmlbpa:compliant mssml:locid = "InternalInterfaceIPv6Checked_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- Management Servers have IPv6 address outside corp prefix -->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:ManagementServers">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "count(tns:OutSideCorpPrefix) = 0 ">
                <value-of  select="tns:OutSideCorpPrefix/tns:ServerArray" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244324</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MgmtServersIPv6Invalid_title"/>
                <mssmlbpa:problem mssml:locid = "MgmtServersIPv6Invalid_problem"/>
                <mssmlbpa:impact mssml:locid = "MgmtServersIPv6Invalid_impact"/>
                <mssmlbpa:resolution mssml:locid = "MgmtServersIPv6Invalid_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = "count(tns:OutSideCorpPrefix) = 0 ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244324</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MgmtServersIPv6Invalid_title"/>
                <mssmlbpa:compliant mssml:locid = "MgmtServersIPv6Invalid_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:FirewallBlocksTeredo">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244317</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "FirewallBlocksToredo_title"/>
                <mssmlbpa:problem mssml:locid = "FirewallBlocksToredo_problem"/>
                <mssmlbpa:impact mssml:locid = "FirewallBlocksToredo_impact"/>
                <mssmlbpa:resolution mssml:locid = "FirewallBlocksToredo_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244317</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "FirewallBlocksToredo_title"/>
                <mssmlbpa:compliant mssml:locid = "FirewallBlocksToredo_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:FirewallON">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "FirewallON_title"/>
                <mssmlbpa:problem mssml:locid = "FirewallON_problem"/>
                <mssmlbpa:impact mssml:locid = "FirewallON_impact"/>
                <mssmlbpa:resolution mssml:locid = "FirewallON_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = ". = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "FirewallON_title"/>
                <mssmlbpa:compliant mssml:locid = "FirewallON_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--If two public consecutive IPv4 addresses are available, but Teredo is not configured, Administrator is informed of the availability of Teredo in the deployment. -->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:ToredoConfigured">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244319</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ToredoAvailable_title"/>
                <mssmlbpa:problem mssml:locid = "ToredoAvailable_problem"/>
                <mssmlbpa:impact mssml:locid = "ToredoAvailable_impact"/>
                <mssmlbpa:resolution mssml:locid = "ToredoAvailable_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244319</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ToredoAvailable_title"/>
                <mssmlbpa:compliant mssml:locid = "ToredoAvailable_compliant"/>
            </report>

        </rule>
    </pattern>


    <!-- CLIENT SECURITY GROUP (SG) LIST SHOULD NOT HAVE DOMAIN COMPUTERS IN DIRECTACCESS GPO WITHOUT WMI FILTER OF LAPTOP ONLY. -->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:SGDomainCompWithFilter">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244320</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "SGDomainCompWithFilter_title"/>
                <mssmlbpa:problem mssml:locid = "SGDomainCompWithFilter_problem"/>
                <mssmlbpa:impact mssml:locid = "SGDomainCompWithFilter_impact"/>
                <mssmlbpa:resolution mssml:locid = "SGDomainCompWithFilter_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244320</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "SGDomainCompWithFilter_title"/>
                <mssmlbpa:compliant mssml:locid = "SGDomainCompWithFilter_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--IF ISATAP IS REGISTRED WITH AT LEAST ONE DOMAIN THEN IT SHOULD BE REGISTERED WITH ALL THE DOMAINS.-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:IsatapResolveAll">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244321</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ISATAPResolution_title"/>
                <mssmlbpa:problem mssml:locid = "ISATAPResolution_problem"/>
                <mssmlbpa:impact mssml:locid = "ISATAPResolution_impact"/>
                <mssmlbpa:resolution mssml:locid = "ISATAPResolution_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244321</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ISATAPResolution_title"/>
                <mssmlbpa:compliant mssml:locid = "ISATAPResolution_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- DNS64 SHOULD BE CONFIGURED TO RETURN AAAA QUERIES IF ISATAP ADDRESSES ARE SEEN ON DAS INTERNAL INTERFACE-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA[tns:IsatapResolving = 'true']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:DNS64ReturnsAAAA = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244322</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DNS64ReturnsAAAA_title"/>
                <mssmlbpa:problem mssml:locid = "DNS64ReturnsAAAA_problem"/>
                <mssmlbpa:impact mssml:locid = "DNS64ReturnsAAAA_impact"/>
                <mssmlbpa:resolution mssml:locid = "DNS64ReturnsAAAA_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:DNS64ReturnsAAAA = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244322</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "DNS64ReturnsAAAA_title"/>
                <mssmlbpa:compliant mssml:locid = "DNS64ReturnsAAAA_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- THE MANAGEMENT SERVERS DO NOT HAVE IPV6 CAPABILITY; REMOTE CLIENT MANAGEMENT WILL NOT BE AVAILABLE.-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:ManagementServers">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " count(tns:IPv4Only) = 0 ">
                <value-of  select="tns:IPv4Only/tns:ServerArray" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244323</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv4OnlyMgmtServers_title"/>
                <mssmlbpa:problem mssml:locid = "IPv4OnlyMgmtServers_problem"/>
                <mssmlbpa:impact mssml:locid = "IPv4OnlyMgmtServers_impact"/>
                <mssmlbpa:resolution mssml:locid = "IPv4OnlyMgmtServers_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " count(tns:IPv4Only) = 0 ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244323</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPv4OnlyMgmtServers_title"/>
                <mssmlbpa:compliant mssml:locid = "IPv4OnlyMgmtServers_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- IPSEC CERTIFICATE ABOUT TO EXPIRE (WHEN DAS CONFIGURED TO USE PKI).-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:Certificates/tns:IpSecAboutToExpire">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244325</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPSecCertAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "IPSecCertAboutToExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "IPSecCertAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "IPSecCertAboutToExpire_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244325</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPSecCertAboutToExpire_title"/>
                <mssmlbpa:compliant mssml:locid = "IPSecCertAboutToExpire_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--IP-HTTPS Certificate about to expire.-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:Certificates/tns:SslAboutToExpire">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244326</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPHTTPCertAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "IPHTTPCertAboutToExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "IPHTTPCertAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "IPHTTPCertAboutToExpire_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244326</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "IPHTTPCertAboutToExpire_title"/>
                <mssmlbpa:compliant mssml:locid = "IPHTTPCertAboutToExpire_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--NLS Certificate about to expire.-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:Certificates/tns:NlsAboutToExpire">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244327</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NLSCertAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "NLSCertAboutToExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "NLSCertAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "NLSCertAboutToExpire_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244327</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NLSCertAboutToExpire_title"/>
                <mssmlbpa:compliant mssml:locid = "NLSCertAboutToExpire_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- NETWORK LOCATION SERVER SHOULD BE RUNNING ON A HIGH AVAILABILITY SERVER-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA[tns:NlsOnDAs = 'true']">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:IsMultiSite = 'true' or tns:NLB = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244328</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NLSOnHighAvailableServer_title"/>
                <mssmlbpa:problem mssml:locid = "NLSOnHighAvailableServer_problem"/>
                <mssmlbpa:impact mssml:locid = "NLSOnHighAvailableServer_impact"/>
                <mssmlbpa:resolution mssml:locid = "NLSOnHighAvailableServer_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:IsMultiSite = 'true' or tns:NLB = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244328</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NLSOnHighAvailableServer_title"/>
                <mssmlbpa:compliant mssml:locid = "NLSOnHighAvailableServer_compliant"/>
            </report>
        </rule>
    </pattern>


    <!-- ONLY THE DC CLOSEST TO THE ENTRY POINT MUST BE LISTED IN THE SERVER GPO AS SUCH.-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:MultiSite[../tns:IsMultiSite = 'true' ]">

            <assert
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:CloseDCUsed = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244329</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "CloseDCNotUsed_title"/>
                <mssmlbpa:problem mssml:locid = "CloseDCNotUsed_problem"/>
                <mssmlbpa:impact mssml:locid = "CloseDCNotUsed_impact"/>
                <mssmlbpa:resolution mssml:locid = "CloseDCNotUsed_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:CloseDCUsed = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244329</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "CloseDCNotUsed_title"/>
                <mssmlbpa:compliant mssml:locid = "CloseDCNotUsed_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- ACTIVE DIRECTORY SITE INITIALLY SPECIFIED IN THE ENTRY POINT CONFIGURATION IS NO LONGER VALID.-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:MultiSite[../tns:IsMultiSite = 'true' ]">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ADSiteValid = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244330</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ADSiteValid_title"/>
                <mssmlbpa:problem mssml:locid = "ADSiteValid_problem"/>
                <mssmlbpa:impact mssml:locid = "ADSiteValid_impact"/>
                <mssmlbpa:resolution mssml:locid = "ADSiteValid_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ADSiteValid = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244330</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ADSiteValid_title"/>
                <mssmlbpa:compliant mssml:locid = "ADSiteValid_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--THE CONNECT TO ADDRESS SHOULD NOT BE PART OF THE CORP SUFFIX SPECIFIED IN THE NRPT POLICIES.-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:NRPTPolicies/tns:ConnectToExempted">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245829</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ConnectToExceptionMissing_title"/>
                <mssmlbpa:problem mssml:locid = "ConnectToExceptionMissing_problem"/>
                <mssmlbpa:impact mssml:locid = "ConnectToExceptionMissing_impact"/>
                <mssmlbpa:resolution mssml:locid = "ConnectToExceptionMissing_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245829</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ConnectToExceptionMissing_title"/>
                <mssmlbpa:compliant mssml:locid = "ConnectToExceptionMissing_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--END-POINTS LISTED IN THE INFRASTRUCTURE TUNNEL POLICY ARE NOT UPDATED.-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:ChangeManagement/tns:MgmtServers">

            <assert
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245830</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "EPInInfraTPUpdated_title"/>
                <mssmlbpa:problem mssml:locid = "EPInInfraTPUpdated_problem"/>
                <mssmlbpa:impact mssml:locid = "EPInInfraTPUpdated_impact"/>
                <mssmlbpa:resolution mssml:locid = "EPInInfraTPUpdated_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245830</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "EPInInfraTPUpdated_title"/>
                <mssmlbpa:compliant mssml:locid = "EPInInfraTPUpdated_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--DIRECTACCESS SERVER'S EXTERNAL IP ADDRESS HAS BEEN CHANGED.-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:ChangeManagement/tns:ExternalInterface">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245831</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ExternalInterfaceChanged_title"/>
                <mssmlbpa:problem mssml:locid = "ExternalInterfaceChanged_problem"/>
                <mssmlbpa:impact mssml:locid = "ExternalInterfaceChanged_impact"/>
                <mssmlbpa:resolution mssml:locid = "ExternalInterfaceChanged_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245831</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "ExternalInterfaceChanged_title"/>
                <mssmlbpa:compliant mssml:locid = "ExternalInterfaceChanged_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--DIRECTACCESS SERVER'S INTERNAL IP ADDRESS HAS BEEN CHANGED.-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:ChangeManagement/tns:InternalInterface">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245832</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InternalInterfaceChanged_title"/>
                <mssmlbpa:problem mssml:locid = "InternalInterfaceChanged_problem"/>
                <mssmlbpa:impact mssml:locid = "InternalInterfaceChanged_impact"/>
                <mssmlbpa:resolution mssml:locid = "InternalInterfaceChanged_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245832</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InternalInterfaceChanged_title"/>
                <mssmlbpa:compliant mssml:locid = "InternalInterfaceChanged_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--THE NCSI PROBE IN THE CLIENT GPO Doesn't work.-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:NCSI">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:DNSProbeResolve = 'true' and tns:WebProbeReachable = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244331</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NCSIProbeNotWorking_title"/>
                <mssmlbpa:problem mssml:locid = "NCSIProbeNotWorking_problem"/>
                <mssmlbpa:impact mssml:locid = "NCSIProbeNotWorking_impact"/>
                <mssmlbpa:resolution mssml:locid = "NCSIProbeNotWorking_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:DNSProbeResolve = 'true' and tns:WebProbeReachable = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244331</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NCSIProbeNotWorking_title"/>
                <mssmlbpa:compliant mssml:locid = "NCSIProbeNotWorking_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--THE NCA RESOURCES IN THE CLIENT GPO ARE NOT REACHABLE .-->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:NCAResourceReachable">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244331</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NCAResourceNotReachable_title"/>
                <mssmlbpa:problem mssml:locid = "NCAResourceNotReachable_problem"/>
                <mssmlbpa:impact mssml:locid = "NCAResourceNotReachable_impact"/>
                <mssmlbpa:resolution mssml:locid = "NCAResourceNotReachable_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244331</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "NCAResourceNotReachable_title"/>
                <mssmlbpa:compliant mssml:locid = "NCAResourceNotReachable_compliant"/>
            </report>
        </rule>
    </pattern>
    <!--END-TO-END TRACING SHOULD NOT BE ACTIVATED FOR LONGER DURATIONS.-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:E2ETraceEnabledLong">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245826</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "E2ETraceEnabledLong_title"/>
                <mssmlbpa:problem mssml:locid = "E2ETraceEnabledLong_problem"/>
                <mssmlbpa:impact mssml:locid = "E2ETraceEnabledLong_impact"/>
                <mssmlbpa:resolution mssml:locid = "E2ETraceEnabledLong_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245826</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "E2ETraceEnabledLong_title"/>
                <mssmlbpa:compliant mssml:locid = "E2ETraceEnabledLong_compliant"/>
            </report>

        </rule>
    </pattern>

    <!--IN-BOX ACCOUNTING IS NOT SELECTED. REPORTING FUNCTIONALITY WILL NOT BE AVAILABLE.-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA/tns:InBoxAccounting">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245827</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InBoxAccounting_title"/>
                <mssmlbpa:problem mssml:locid = "InBoxAccounting_problem"/>
                <mssmlbpa:impact mssml:locid = "InBoxAccounting_impact"/>
                <mssmlbpa:resolution mssml:locid = "InBoxAccounting_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " . = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245827</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "InBoxAccounting_title"/>
                <mssmlbpa:compliant mssml:locid = "InBoxAccounting_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- Remote Access Server Health-->
    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:DA">

            <assert
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:IsServerHealthGood = 'true' ">
                <value-of  select="tns:ServerHealthIssue/tns:NameArray" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245828</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RemoteAccessServerHealth_title"/>
                <mssmlbpa:problem mssml:locid = "RemoteAccessServerHealth_problem"/>
                <mssmlbpa:impact mssml:locid = "RemoteAccessServerHealth_impact"/>
                <mssmlbpa:resolution mssml:locid = "RemoteAccessServerHealth_resolution"/>
            </assert>

            <report
               mssml:severity = "info"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:IsServerHealthGood = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=245828</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RemoteAccessServerHealth_title"/>
                <mssmlbpa:compliant mssml:locid = "RemoteAccessServerHealth_compliant"/>
            </report>

        </rule>
    </pattern>

    <!-- Web Application Proxy  -->

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:InvalidCerts/tns:Certificate">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:CertErrorType = 'Missing' ">
                <value-of  select="tns:ApplicationName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306637</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCertificateMissing_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCertificateMissing_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCertificateMissing_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCertificateMissing_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:InvalidCerts/tns:Certificate">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:CertErrorType = 'AboutToExpire' ">
                <value-of  select="tns:ApplicationName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306638</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCertificateWillExpire_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCertificateWillExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCertificateWillExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCertificateWillExpire_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:InvalidCerts/tns:Certificate">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:CertErrorType = 'Expired' ">
                <value-of  select="tns:ApplicationName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306639</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCertificateExpired_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCertificateExpired_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCertificateExpired_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCertificateExpired_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:InvalidCerts/tns:Certificate">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:CertErrorType = 'NotBefore' ">
                <value-of  select="tns:ApplicationName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306640</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCertificateNotBefore_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCertificateNotBefore_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCertificateNotBefore_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCertificateNotBefore_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:InvalidCerts/tns:Certificate">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:CertErrorType = 'NoPrivateKey' ">
                <value-of  select="tns:ApplicationName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306641</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCertificateNoPrivateKey_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCertificateNoPrivateKey_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCertificateNoPrivateKey_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCertificateNoPrivateKey_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:WebApplicationProxyInstalled = 'true' and tns:WebApplicationProxyEnabled = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306643</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPNotConfigured_title"/>
                <mssmlbpa:problem mssml:locid = "WAPNotConfigured_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPNotConfigured_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPNotConfigured_resolution"/>
            </report>

            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:WebApplicationProxyEnabled = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=306643</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPNotConfigured_title"/>
                <mssmlbpa:compliant mssml:locid = "WAPNotConfigured_compliant"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'UrlTranslationDis' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=309051</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPUrlTranslationDis_title"/>
                <mssmlbpa:problem mssml:locid = "WAPUrlTranslationDis_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPUrlTranslationDis_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPUrlTranslationDis_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'PollingIntervalHigh' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=309052</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPPollingIntervalHigh_title"/>
                <mssmlbpa:problem mssml:locid = "WAPPollingIntervalHigh_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPPollingIntervalHigh_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPPollingIntervalHigh_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'ServerNotInCluster' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=309053</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPServerNotInCluster_title"/>
                <mssmlbpa:problem mssml:locid = "WAPServerNotInCluster_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPServerNotInCluster_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPServerNotInCluster_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">

            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'DAWithWAPCluster' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=309054</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPDAWithWAPCluster_title"/>
                <mssmlbpa:problem mssml:locid = "WAPDAWithWAPCluster_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPDAWithWAPCluster_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPDAWithWAPCluster_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'NonDomainJoinedAndIWA' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306644</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPNonDomainJoinedAndIWA_title"/>
                <mssmlbpa:problem mssml:locid = "WAPNonDomainJoinedAndIWA_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPNonDomainJoinedAndIWA_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPNonDomainJoinedAndIWA_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">

            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'CantRetrieveConfPermanent' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306645</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCantRetrieveConfPermanent_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCantRetrieveConfPermanent_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCantRetrieveConfPermanent_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCantRetrieveConfPermanent_resolution"/>
            </report>

        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">
            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'CantRetrieveConfTemporary' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306647</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCantRetrieveConfTemporary_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCantRetrieveConfTemporary_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCantRetrieveConfTemporary_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCantRetrieveConfTemporary_resolution"/>
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">
            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'CantApplyConfCert' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306648</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCantApplyConfCert_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCantApplyConfCert_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCantApplyConfCert_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCantApplyConfCert_resolution"/>
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">
            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'CantApplyConfHttpSys' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306649</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPCantApplyConfHttpSys_title"/>
                <mssmlbpa:problem mssml:locid = "WAPCantApplyConfHttpSys_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPCantApplyConfHttpSys_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPCantApplyConfHttpSys_resolution"/>
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">
            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'IwaFailed' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306651</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPIwaFailed_title"/>
                <mssmlbpa:problem mssml:locid = "WAPIwaFailed_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPIwaFailed_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPIwaFailed_resolution"/>
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">
            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'ServiceNotAuto' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306652</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPServiceNotAuto_title"/>
                <mssmlbpa:problem mssml:locid = "WAPServiceNotAuto_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPServiceNotAuto_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPServiceNotAuto_resolution"/>
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">
            <report
               mssml:severity = "warning"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'ADFSServiceNotAuto' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306653</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPADFSServiceNotAuto_title"/>
                <mssmlbpa:problem mssml:locid = "WAPADFSServiceNotAuto_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPADFSServiceNotAuto_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPADFSServiceNotAuto_resolution"/>
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">
            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'ServiceStopped' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306654</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPServiceStopped_title"/>
                <mssmlbpa:problem mssml:locid = "WAPServiceStopped_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPServiceStopped_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPServiceStopped_resolution"/>
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context = "tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:WebApplicationProxy/tns:AdditionalErrors/tns:AdditionalError">
            <report
               mssml:severity = "error"
               mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:ErrorType = 'ADFSServiceStopped' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=306655</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "WAPADFSServiceStopped_title"/>
                <mssmlbpa:problem mssml:locid = "WAPADFSServiceStopped_problem"/>
                <mssmlbpa:impact mssml:locid = "WAPADFSServiceStopped_impact"/>
                <mssmlbpa:resolution mssml:locid = "WAPADFSServiceStopped_resolution"/>
            </report>
        </rule>
    </pattern>

    
    <!--RRAS Rules for V2-->
    
    <!--The setup must be a valid MT setup-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS">
            <assert
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IsInstallationValid = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328970</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRAS_ST_ValidSetup_title"/>
                <mssmlbpa:problem mssml:locid = "RRAS_ST_ValidSetup_problem"/>
                <mssmlbpa:impact mssml:locid = "RRAS_ST_ValidSetup_impact"/>
                <mssmlbpa:resolution mssml:locid = "RRAS_ST_ValidSetup_resolution"/>
            </assert>
        </rule>        
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS">
            <assert
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IsInstallationValid = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328971</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRAS_MT_ValidSetup_title"/>
                <mssmlbpa:problem mssml:locid = "RRAS_MT_ValidSetup_problem"/>
                <mssmlbpa:impact mssml:locid = "RRAS_MT_ValidSetup_impact"/>
                <mssmlbpa:resolution mssml:locid = "RRAS_MT_ValidSetup_resolution"/>
            </assert>
        </rule>
    </pattern>
    
    <!--For each routing domain compartment must exist on stack-->
    <pattern>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:DeletedCompartments = 'false' ">
                <value-of  select="tns:DeletedCompartmentNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=331357</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRAS_MT_CompartmentDeleted_title"/>
                <mssmlbpa:problem mssml:locid = "RRAS_MT_CompartmentDeleted_problem"/>
                <mssmlbpa:impact mssml:locid = "RRAS_MT_CompartmentDeleted_impact"/>
                <mssmlbpa:resolution mssml:locid = "RRAS_MT_CompartmentDeleted_resolution"/>
            </assert>
        </rule>
    </pattern>

    <!--AllCompartments must be enabled for RRAS-->
    <pattern>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert
                mssml:severity = "info"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:AllCompartmentsEnabled = 'true' ">
                <value-of  select="tns:DisabledCompartmentsName" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328972</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRAS_MT_AllCompartmentsEnabled_title"/>
                <mssmlbpa:problem mssml:locid = "RRAS_MT_AllCompartmentsEnabled_problem"/>
                <mssmlbpa:impact mssml:locid = "RRAS_MT_AllCompartmentsEnabled_impact"/>
                <mssmlbpa:resolution mssml:locid = "RRAS_MT_AllCompartmentsEnabled_resolution"/>
            </assert>
            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = " tns:AllCompartmentsEnabled = 'true' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328972</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "RRAS_MT_AllCompartmentsEnabled_title"/>
                <mssmlbpa:compliant mssml:locid = "RRAS_MT_AllCompartmentsEnabled_compliant"/>
            </report>
        </rule>
    </pattern>


    <!-- BPA Rules for BGP -->

    <!--The default route should not be advertised to peers-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:DefaultGatewayAdvertised = 'false' ">
                <value-of  select="tns:DefaultGatewayAdvertisedPeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329005</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_DefaultGatewayAdvertised_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_DefaultGatewayAdvertised_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_DefaultGatewayAdvertised_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_DefaultGatewayAdvertised_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:DefaultGatewayAdvertised = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329005</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_DefaultGatewayAdvertised_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_DefaultGatewayAdvertised_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:DefaultGatewayAdvertised = 'false' ">
                <value-of  select="tns:DefaultGatewayAdvertisedPeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329005</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_DefaultGatewayAdvertised_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_DefaultGatewayAdvertised_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_DefaultGatewayAdvertised_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_DefaultGatewayAdvertised_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--The default route should not be accepted from peers-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:DefaultGatewayAccepted = 'false' ">
                <value-of  select="tns:DefaultGatewatAcceptedPeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329006</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_DefaultGatewayAccepted_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_DefaultGatewayAccepted_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_DefaultGatewayAccepted_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_DefaultGatewayAccepted_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:DefaultGatewayAccepted = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329006</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_DefaultGatewayAccepted_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_DefaultGatewayAccepted_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:DefaultGatewayAccepted = 'false' ">
                <value-of  select="tns:DefaultGatewatAcceptedPeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329006</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_DefaultGatewayAccepted_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_DefaultGatewayAccepted_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_DefaultGatewayAccepted_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_DefaultGatewayAccepted_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Peer IP Address is assigned to a local network interface.-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PeerIpAssignedToLocalInterface = 'false' ">
                <value-of  select="tns:PeerIPAssignedToLocalInterfacePeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329007</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PeerIpAssignedToLocalInterface_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_PeerIpAssignedToLocalInterface_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_PeerIpAssignedToLocalInterface_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_PeerIpAssignedToLocalInterface_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PeerIpAssignedToLocalInterface = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329007</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PeerIpAssignedToLocalInterface_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_PeerIpAssignedToLocalInterface_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PeerIpAssignedToLocalInterface = 'false' ">
                <value-of  select="tns:PeerIPAssignedToLocalInterfacePeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329007</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PeerIpAssignedToLocalInterface_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_PeerIpAssignedToLocalInterface_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_PeerIpAssignedToLocalInterface_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_PeerIpAssignedToLocalInterface_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--If IPv6 Routing is enabled while peering over IPv4 Addresses, Local IPv6 Address must be configured on the BGP Router-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IPv6EnabledIPv4PeersNoLocalIPv6Address = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329008</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IPv6EnabledIPv4PeersNoLocalIPv6Address = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329008</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IPv6EnabledIPv4PeersNoLocalIPv6Address = 'false' ">
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329008</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_IPv6EnabledIPv4PeersNoLocalIPv6Address_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Custom Networks Not Reachable-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:CustomRoutesNotReachable = 'false' ">
                <value-of  select="tns:CustomRoutesNotReachableList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329009</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_CustomRoutesNotReachable_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_CustomRoutesNotReachable_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_CustomRoutesNotReachable_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_CustomRoutesNotReachable_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:CustomRoutesNotReachable = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329009</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_CustomRoutesNotReachable_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_CustomRoutesNotReachable_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:CustomRoutesNotReachable = 'false' ">
                <value-of  select="tns:CustomRoutesNotReachableList" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329009</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_CustomRoutesNotReachable_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_CustomRoutesNotReachable_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_CustomRoutesNotReachable_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_CustomRoutesNotReachable_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Same Prefix, Multiple Next-Hops-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:RoutesWithMultipleNextHops = 'false' ">
                <value-of  select="tns:RoutesWithMultipleNextHopsList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329010</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_RoutesWithMultipleNextHops_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_RoutesWithMultipleNextHops_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_RoutesWithMultipleNextHops_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_RoutesWithMultipleNextHops_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:RoutesWithMultipleNextHops = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329010</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_RoutesWithMultipleNextHops_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_RoutesWithMultipleNextHops_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:RoutesWithMultipleNextHops = 'false' ">
                <value-of  select="tns:RoutesWithMultipleNextHopsList" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329010</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_RoutesWithMultipleNextHops_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_RoutesWithMultipleNextHops_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_RoutesWithMultipleNextHops_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_RoutesWithMultipleNextHops_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Hold-Timer must not be set to zero-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:HoldTimeSecZero = 'false' ">
                <value-of  select="tns:HoldTimeSecZeroPeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329011</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_HoldTimeSecZero_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_HoldTimeSecZero_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_HoldTimeSecZero_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_HoldTimeSecZero_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:HoldTimeSecZero = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329011</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_HoldTimeSecZero_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_HoldTimeSecZero_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:HoldTimeSecZero = 'false' ">
                <value-of  select="tns:HoldTimeSecZeroPeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329011</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_HoldTimeSecZero_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_HoldTimeSecZero_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_HoldTimeSecZero_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_HoldTimeSecZero_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Hold-Timer must not be set to less than 20-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:HoldTimeSecLowValue = 'false' ">
                <value-of  select="tns:HoldTimeSecLowValuePeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329012</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_HoldTimeSecLowValue_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_HoldTimeSecLowValue_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_HoldTimeSecLowValue_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_HoldTimeSecLowValue_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:HoldTimeSecLowValue = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329012</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_HoldTimeSecLowValue_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_HoldTimeSecLowValue_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:HoldTimeSecLowValue = 'false' ">
                <value-of  select="tns:HoldTimeSecLowValuePeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329012</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_HoldTimeSecLowValue_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_HoldTimeSecLowValue_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_HoldTimeSecLowValue_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_HoldTimeSecLowValue_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--All ingress routes must not be rejected-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:AllIngressRoutesRejected = 'false' ">
                <value-of  select="tns:AllIngressRoutesRejectedPeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329013</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_AllIngressRoutesRejected_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_AllIngressRoutesRejected_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_AllIngressRoutesRejected_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_AllIngressRoutesRejected_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:AllIngressRoutesRejected = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329013</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_AllIngressRoutesRejected_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_AllIngressRoutesRejected_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:AllIngressRoutesRejected = 'false' ">
                <value-of  select="tns:AllIngressRoutesRejectedPeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329013</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_AllIngressRoutesRejected_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_AllIngressRoutesRejected_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_AllIngressRoutesRejected_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_AllIngressRoutesRejected_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--All egress routes must not be rejected-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:AllEgressRoutesRejected = 'false' ">
                <value-of  select="tns:AllEgressRoutesRejectedPeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329014</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_AllEgressRoutesRejected_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_AllEgressRoutesRejected_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_AllEgressRoutesRejected_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_AllEgressRoutesRejected_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:AllEgressRoutesRejected = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329014</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_AllEgressRoutesRejected_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_AllEgressRoutesRejected_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:AllEgressRoutesRejected = 'false' ">
                <value-of  select="tns:AllEgressRoutesRejectedPeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329014</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_AllEgressRoutesRejected_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_AllEgressRoutesRejected_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_AllEgressRoutesRejected_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_AllEgressRoutesRejected_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--BGP peers must not be in manual peering mode-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:ManualModePeers = 'false' ">
                <value-of  select="tns:ManualModePeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329015</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_ManualModePeers_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_ManualModePeers_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_ManualModePeers_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_ManualModePeers_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:ManualModePeers = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329015</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_ManualModePeers_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_ManualModePeers_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:ManualModePeers = 'false' ">
                <value-of  select="tns:ManualModePeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329015</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_ManualModePeers_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_ManualModePeers_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_ManualModePeers_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_ManualModePeers_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--No IPv4 Custom routes must be configured for IPv6 Peers-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IPv6PeersWithIPv4CustomRoutes = 'false' ">
                <value-of  select="tns:IPv6PeersWithIPv4CustomRoutesPeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329016</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IPv6PeersWithIPv4CustomRoutes = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329016</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IPv6PeersWithIPv4CustomRoutes = 'false' ">
                <value-of  select="tns:IPv6PeersWithIPv4CustomRoutesPeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329016</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_IPv6PeersWithIPv4CustomRoutes_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Idle Hold Timer must not be set to high value-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IdleHoldTimeSecHighValue = 'false' ">
                <value-of  select="tns:IdleHoldTimeSecHighValuePeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329017</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IdleHoldTimeSecHighValue_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_IdleHoldTimeSecHighValue_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_IdleHoldTimeSecHighValue_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_IdleHoldTimeSecHighValue_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IdleHoldTimeSecHighValue = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329017</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IdleHoldTimeSecHighValue_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_IdleHoldTimeSecHighValue_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:IdleHoldTimeSecHighValue = 'false' ">
                <value-of  select="tns:IdleHoldTimeSecHighValuePeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329017</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_IdleHoldTimeSecHighValue_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_IdleHoldTimeSecHighValue_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_IdleHoldTimeSecHighValue_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_IdleHoldTimeSecHighValue_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--MaxPrefixLimit must be set for all BGP peers-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PeersWithoutMaxPrefixLimit = 'false' ">
                <value-of  select="tns:PeersWithoutMaxPrefixLimitNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=331358</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PeersWithoutMaxPrefixLimit = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=331358</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PeersWithoutMaxPrefixLimit = 'false' ">
                <value-of  select="tns:PeersWithoutMaxPrefixLimitNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=331358</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_PeersWithoutMaxPrefixLimit_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Prefixes learned count in proximity of MaxPrefixLimit-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PrefixCountNearMaxLimit = 'false' ">
                <value-of  select="tns:PrefixCountNearMaxLimitPeerNames" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329018</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PrefixCountNearMaxLimit_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_PrefixCountNearMaxLimit_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_PrefixCountNearMaxLimit_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_PrefixCountNearMaxLimit_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PrefixCountNearMaxLimit = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329018</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PrefixCountNearMaxLimit_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_PrefixCountNearMaxLimit_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PrefixCountNearMaxLimit = 'false' ">
                <value-of  select="tns:PrefixCountNearMaxLimitPeerNames" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329018</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_PrefixCountNearMaxLimit_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_PrefixCountNearMaxLimit_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_PrefixCountNearMaxLimit_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_PrefixCountNearMaxLimit_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--VpnAddressPool must be in BGP custom routes-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true' and tns:VpnEnabled = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:VpnAddressPoolNotInCustomRoutes = 'false' ">
                <value-of  select="tns:VpnAddressPoolNotInCustomRoutesList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329025</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_problem"/>
                <mssmlbpa:impact mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:VpnAddressPoolNotInCustomRoutes = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329025</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_title"/>
                <mssmlbpa:compliant mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:RoutingProtocolsConfigured = 'true' and tns:VpnEnabled = 'true']/tns:RoutingProtocols[tns:BGPConfigured = 'true']/tns:BGP">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:VpnAddressPoolNotInCustomRoutes = 'false' ">
                <value-of  select="tns:VpnAddressPoolNotInCustomRoutesList" />
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329025</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_title"/>
                <mssmlbpa:problem mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_impact"/>
                <mssmlbpa:resolution mssml:locid = "BGP_VPN_VpnAddressPoolNotInCustomRoutes_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!-- Multi-Tenant VPN rules-->

    <!--Static address pool must be configured in MTVPN-->
    <pattern>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:VpnEnabled = 'true']/tns:VPN/tns:MTVPN">
            <assert
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:StaticAddressPoolConfigured = 'true' ">
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329001</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MTVPN_StaticAddressPoolConfigured_title"/>
                <mssmlbpa:problem mssml:locid = "MTVPN_StaticAddressPoolConfigured_problem"/>
                <mssmlbpa:impact mssml:locid = "MTVPN_StaticAddressPoolConfigured_impact"/>
                <mssmlbpa:resolution mssml:locid = "MTVPN_StaticAddressPoolConfigured_resolution"/>
            </assert>
        </rule>
    </pattern>

    <!--Static address pool must consist of only unicast IP addresses in MTVPN-->
    <pattern>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:VpnEnabled = 'true']/tns:VPN/tns:MTVPN[tns:StaticAddressPoolConfigured = 'true']">
            <assert
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:StaticAddressPoolIsUnicast = 'true'">
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329002</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MTVPN_StaticAddressPoolIsUnicast_title"/>
                <mssmlbpa:problem mssml:locid = "MTVPN_StaticAddressPoolIsUnicast_problem"/>
                <mssmlbpa:impact mssml:locid = "MTVPN_StaticAddressPoolIsUnicast_impact"/>
                <mssmlbpa:resolution mssml:locid = "MTVPN_StaticAddressPoolIsUnicast_resolution"/>
            </assert>
        </rule>
    </pattern>

    <!--TenantName must be configured in MTVPN-->
    <pattern>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:VpnEnabled = 'true']/tns:VPN/tns:MTVPN">
            <assert
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:TenantNameConfigured = 'true'">
                <value-of  select=" ../../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329003</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MTVPN_TenantNameConfigured_title"/>
                <mssmlbpa:problem mssml:locid = "MTVPN_TenantNameConfigured_problem"/>
                <mssmlbpa:impact mssml:locid = "MTVPN_TenantNameConfigured_impact"/>
                <mssmlbpa:resolution mssml:locid = "MTVPN_TenantNameConfigured_resolution"/>
            </assert>
        </rule>
    </pattern>

    <!--TODO, See the order of strings-->
    <!--TenantName must not be subset of another TenantName-->
    <pattern>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:VpnEnabled = 'true']/tns:VPN/tns:MTVPN[tns:TenantNameConfigured = 'true']">
            <assert
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:TenantNameSubsetOfAnotherRD = 'false'">
                <value-of  select=" ../../tns:Name " />
                <value-of select="tns:TenantNameSubsetOfAnotherRDList"/>
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329004</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "MTVPN_TenantNameSubsetOfAnotherRD_title"/>
                <mssmlbpa:problem mssml:locid = "MTVPN_TenantNameSubsetOfAnotherRD_problem"/>
                <mssmlbpa:impact mssml:locid = "MTVPN_TenantNameSubsetOfAnotherRD_impact"/>
                <mssmlbpa:resolution mssml:locid = "MTVPN_TenantNameSubsetOfAnotherRD_resolution"/>
            </assert>
        </rule>
    </pattern>

    <!--S2S rules in version 2-->
    <!--Inbound CA must be configured -->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true' and tns:CertAuthenticationEnabled = 'true']">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:IsInboundCAConfigured = 'true'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328978 </mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_IsInboundCAConfigured_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_IsInboundCAConfigured_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_IsInboundCAConfigured_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_IsInboundCAConfigured_resolution"/>
            </assert>
            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:IsInboundCAConfigured = 'true'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328978 </mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_IsInboundCAConfigured_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_IsInboundCAConfigured_compliant"/>
            </report>
        </rule>
    </pattern>

    <!--ServerCertHasNoRootCertificate has no root cert -->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert                                                            
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:ServerCertHasNoRootCertificate = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328980</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_ServerCertHasNoRootCertificate_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_ServerCertHasNoRootCertificate_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_ServerCertHasNoRootCertificate_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_ServerCertHasNoRootCertificate_resolution"/>
            </assert>
            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:ServerCertHasNoRootCertificate = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328980</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_ServerCertHasNoRootCertificate_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_ServerCertHasNoRootCertificate_compliant"/>
            </report>
        </rule>
    </pattern>
    
    <!--ServerRootCertificateAboutToExpire-->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert                                                          
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:ServerRootCertificateAboutToExpire = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328983</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_ServerRootCertificateAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_ServerRootCertificateAboutToExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_ServerRootCertificateAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_ServerRootCertificateAboutToExpire_resolution"/>
            </assert>
            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:ServerRootCertificateAboutToExpire = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328983</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_ServerRootCertificateAboutToExpire_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_ServerRootCertificateAboutToExpire_compliant"/>
            </report>
        </rule>
    </pattern>
    
    <!--RootCertificateToAcceptAboutToExpire-->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true'  and tns:CertAuthenticationEnabled = 'true']">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:RootCertificateToAcceptAboutToExpire = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328989</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_RootCertificateToAcceptAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_RootCertificateToAcceptAboutToExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_RootCertificateToAcceptAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_RootCertificateToAcceptAboutToExpire_resolution"/>
            </assert>
            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:RootCertificateToAcceptAboutToExpire = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328989</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_RootCertificateToAcceptAboutToExpire_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_RootCertificateToAcceptAboutToExpire_compliant"/>
            </report>
        </rule>
    </pattern>
    
     
    <!--ServerCertificateHasAtleastOneIPInCN-->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:ServerCertificateHasAtleastOneIPInCN = 'true'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328990</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_ServerCertificateHasAtleastOnePublicIPInCN_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_ServerCertificateHasAtleastOnePublicIPInCN_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_ServerCertificateHasAtleastOnePublicIPInCN_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_ServerCertificateHasAtleastOnePublicIPInCN_resolution"/>
            </assert>
            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:ServerCertificateHasAtleastOneIPInCN = 'true'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328990</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_ServerCertificateHasAtleastOnePublicIPInCN_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_ServerCertificateHasAtleastOnePublicIPInCN_compliant"/>
            </report>
        </rule>
    </pattern>

    <!--ServerCertificateAboutToExpire -->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:ServerCertificateAboutToExpire = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328982</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_ServerCertificateAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_ServerCertificateAboutToExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_ServerCertificateAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_ServerCertificateAboutToExpire_resolution"/>
            </assert>
            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:ServerCertificateAboutToExpire = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328982</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_ServerCertificateAboutToExpire_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_ServerCertificateAboutToExpire_compliant"/>
            </report>
        </rule>
    </pattern>
    
    
    <!--No two PSK bases interfaces must have same destination-->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert
                mssml:severity = "error"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = "tns:PSKBasedS2SInterfacesWithSameDestination = 'false'">
                <value-of select="tns:PSKBasedS2SInterfacesWithSameDestinationList"/>
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328995</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_PSKBasedS2SInterfacesWithSameDestination_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_PSKBasedS2SInterfacesWithSameDestination_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_PSKBasedS2SInterfacesWithSameDestination_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_PSKBasedS2SInterfacesWithSameDestination_resolution"/>
            </assert>
            <report
               mssml:severity = "info"
               mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
               test = "tns:PSKBasedS2SInterfacesWithSameDestination = 'false'">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328995</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_PSKBasedS2SInterfacesWithSameDestination_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_PSKBasedS2SInterfacesWithSameDestination_compliant"/>
            </report>
        </rule>
    </pattern>
    
    <!--S2SInterfaces certificates must not expire within next 7 days-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithCertificateAboutToExpire = 'false' ">
                <value-of  select="tns:S2SInterfacesWithCertificateAboutToExpireList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328986</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithCertificateAboutToExpire = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328986</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithCertificateAboutToExpire = 'false' ">
                <value-of  select="tns:S2SInterfacesWithCertificateAboutToExpireList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328986</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithCertificateAboutToExpire_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--S2SInterfaces must have a valid root certificate-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutRootCertificate = 'false' ">
                <value-of  select="tns:S2SInterfacesWithoutRootCertificateList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153257</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutRootCertificate_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithoutRootCertificate_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithoutRootCertificate_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithoutRootCertificate_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutRootCertificate = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153257</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutRootCertificate_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_InterfacesWithoutRootCertificate_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutRootCertificate = 'false' ">
                <value-of  select="tns:S2SInterfacesWithoutRootCertificateList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153257</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutRootCertificate_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithoutRootCertificate_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithoutRootCertificate_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithoutRootCertificate_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--S2SInterfaces root certificate must not expire within next 7 days-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithRootCertificateAboutToExpire = 'false' ">
                <value-of  select="tns:S2SInterfacesWithRootCertificateAboutToExpireList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153257</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithRootCertificateAboutToExpire = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153257</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithRootCertificateAboutToExpire = 'false' ">
                <value-of  select="tns:S2SInterfacesWithRootCertificateAboutToExpireList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?linkid=153257</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithRootCertificateAboutToExpire_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Eap bases S2S Interfaces must have a corresponding user name with dial-in permissions-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:EAPBasedS2SInterfacesWithInValidName = 'false' ">
                <value-of  select="tns:EAPBasedS2SInterfacesWithInvalidNameList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328991</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:EAPBasedS2SInterfacesWithInValidName = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328991</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:EAPBasedS2SInterfacesWithInValidName = 'false' ">
                <value-of  select="tns:EAPBasedS2SInterfacesWithInvalidNameList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328991</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_EAPBasedS2SInterfacesWithInValidName_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--Server should not have DefaultCapacityParams-->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:performance mssmlbpa:markupv2"
                test = " tns:DefaultCapacityParams = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328994</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_DefaultCapacityParams_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_DefaultCapacityParams_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_DefaultCapacityParams_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_DefaultCapacityParams_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:performance mssmlbpa:markupv2"
                test = " tns:DefaultRateLimitingParams = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328994</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_DefaultRateLimitingParams_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_DefaultCapacityParams_compliant"/>
            </report>
        </rule>
    </pattern>


    <!--PortLimitExceeded-->
    <pattern>
        <rule context="tns:RemoteAccess/tns:RRASSERVER/tns:RRAS[tns:IsInstallationValid = 'true']">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PortLimitExceeded = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329000</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_PortLimitExceeded_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_PortLimitExceeded_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_PortLimitExceeded_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_PortLimitExceeded_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PortLimitExceeded = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329000</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_PortLimitExceeded_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_PortLimitExceeded_compliant"/>
            </report>
        </rule>
    </pattern>


    <!--S2S interfaces must not have default rate limiting parameters-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:performance mssmlbpa:markupv2"
                test = " tns:DefaultRateLimitingParams = 'false' ">
                <value-of  select="tns:DefaultRateLimitingParamsList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328992</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_DefaultRateLimitingParams_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_DefaultRateLimitingParams_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_DefaultRateLimitingParams_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_DefaultRateLimitingParams_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:performance mssmlbpa:markupv2"
                test = " tns:DefaultRateLimitingParams = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328992</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_DefaultRateLimitingParams_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_DefaultRateLimitingParams_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:performance  mssmlbpa:markupv2"
                test = " tns:DefaultRateLimitingParams = 'false' ">
                <value-of  select="tns:DefaultRateLimitingParamsList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328992</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_DefaultRateLimitingParams_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_DefaultRateLimitingParams_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_DefaultRateLimitingParams_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_DefaultRateLimitingParams_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--S2S interfaces must not have valid (RX/TX limits must have considerable difference, else perf penality) rate limiting parameters-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:performance mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithInValidRateLimitingParams = 'false' ">
                <value-of  select="tns:S2SInterfacesWithInValidRateLimitingParamsList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328993</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:performance mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithInValidRateLimitingParams = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328993</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:performance mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithInValidRateLimitingParams = 'false' ">
                <value-of  select="tns:S2SInterfacesWithInValidRateLimitingParamsList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328993</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithInValidRateLimitingParams_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--PSKBased S2S interfaces must not have FQDN as destination-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PSKBasedS2SInterfacesWithInvalidDestination = 'false' ">
                <value-of  select="tns:PSKBasedS2SInterfacesWithInvalidDestinationList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328996</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PSKBasedS2SInterfacesWithInvalidDestination = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328996</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:PSKBasedS2SInterfacesWithInvalidDestination = 'false' ">
                <value-of  select="tns:PSKBasedS2SInterfacesWithInvalidDestinationList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328996</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_PSKBasedS2SInterfacesWithInvalidDestination_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--S2SInterfaces must have SourceIP defined if multiple public IP's are present-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesRequireSourceIpConfiguration = 'false' ">
                <value-of  select="tns:S2SInterfacesRequireSourceIpConfigurationList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328997</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesRequireSourceIpConfiguration = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328997</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesRequireSourceIpConfiguration = 'false' ">
                <value-of  select="tns:S2SInterfacesRequireSourceIpConfigurationList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328997</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesRequireSourceIpConfiguration_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--S2SInterfaces custom policies must be subset of global policies-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithCustomPolicyDiffFromGlobalPolicies = 'false' ">
                <value-of  select="tns:S2SInterfacesWithCustomPolicyDiffFromGlobalPoliciesList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328999</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithCustomPolicyDiffFromGlobalPolicies = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328999</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithCustomPolicyDiffFromGlobalPolicies = 'false' ">
                <value-of  select="tns:S2SInterfacesWithCustomPolicyDiffFromGlobalPoliciesList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=328999</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithCustomPolicyDiffFromGlobalPolicies_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

    <!--S2SInterfaces must have a triggering route-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutTriggeringRoute = 'false' ">
                <value-of  select="tns:S2SInterfacesWithoutTriggeringRouteList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329020</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutTriggeringRoute = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329020</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutTriggeringRoute = 'false' ">
                <value-of  select="tns:S2SInterfacesWithoutTriggeringRouteList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329020</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithoutTriggeringRoute_resolution_MT"/>
            </assert>
        </rule>
    </pattern>
    
    <!--S2SInterfaces must have host-triggering route if BGP is configured, the check for BGP configured must be done in script-->
    <pattern>
        <!--SingleTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'false']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutHostTriggeringRoute = 'false' ">
                <value-of  select="tns:S2SInterfacesWithoutHostTriggeringRouteList" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329021</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_problem"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_resolution"/>
            </assert>
            <report
                mssml:severity = "info"
                mssml:category ="mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutHostTriggeringRoute = 'false' ">
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329021</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_title"/>
                <mssmlbpa:compliant mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_compliant"/>
            </report>
        </rule>
        <!--MultiTenant-->
        <rule context="tns:RemoteAccess/tns:RRASSERVER[tns:MultiTenancyEnabled = 'true']/tns:RRAS[tns:IsInstallationValid = 'true']/tns:RoutingDomain[tns:Enabled = 'true' and tns:S2SEnabled = 'true' and tns:RoutingProtocolsConfigured = 'true']/tns:S2S">
            <assert
                mssml:severity = "warning"
                mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
                test = " tns:S2SInterfacesWithoutHostTriggeringRoute = 'false' ">
                <value-of  select="tns:S2SInterfacesWithoutHostTriggeringRouteList" />
                <value-of  select=" ../tns:Name " />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=329021</mssmlbpa:helpTopic>
                <mssmlbpa:title mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_title"/>
                <mssmlbpa:problem mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_problem_MT"/>
                <mssmlbpa:impact mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_impact"/>
                <mssmlbpa:resolution mssml:locid = "S2S_InterfacesWithoutHostTriggeringRoute_resolution_MT"/>
            </assert>
        </rule>
    </pattern>

  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:DownLevel">

      <assert
         mssml:severity = "warning"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "DownLevel_title"/>
        <mssmlbpa:problem mssml:locid = "DownLevel_problem"/>
        <mssmlbpa:impact mssml:locid = "DownLevel_impact"/>
        <mssmlbpa:resolution mssml:locid = "DownLevel_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "DownLevel_title"/>
        <mssmlbpa:compliant mssml:locid = "DownLevel_compliant"/>
      </report>

    </rule>
  </pattern>  
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:ForceTunnelAndKerProxy">

      <assert
         mssml:severity = "error"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'false' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "ForceTunnelAndKerProxy_title"/>
        <mssmlbpa:problem mssml:locid = "ForceTunnelAndKerProxy_problem"/>
        <mssmlbpa:impact mssml:locid = "ForceTunnelAndKerProxy_impact"/>
        <mssmlbpa:resolution mssml:locid = "ForceTunnelAndKerProxy_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'false' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "ForceTunnelAndKerProxy_title"/>
        <mssmlbpa:compliant mssml:locid = "ForceTunnelAndKerProxy_compliant"/>
      </report>

    </rule>
  </pattern>  
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:DCInstalled">

      <assert
         mssml:severity = "error"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'false' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "DCInstalled_title"/>
        <mssmlbpa:problem mssml:locid = "DCInstalled_problem"/>
        <mssmlbpa:impact mssml:locid = "DCInstalled_impact"/>
        <mssmlbpa:resolution mssml:locid = "DCInstalled_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'false' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "DCInstalled_title"/>
        <mssmlbpa:compliant mssml:locid = "DCInstalled_compliant"/>
      </report>

    </rule>
  </pattern>  
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsNetAdapterBindingOrderCorrect">

      <assert
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsNetAdapterBindingOrderCorrect_title"/>
        <mssmlbpa:problem mssml:locid = "IsNetAdapterBindingOrderCorrect_problem"/>
        <mssmlbpa:impact mssml:locid = "IsNetAdapterBindingOrderCorrect_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsNetAdapterBindingOrderCorrect_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsNetAdapterBindingOrderCorrect_title"/>
        <mssmlbpa:compliant mssml:locid = "IsNetAdapterBindingOrderCorrect_compliant"/>
      </report>

    </rule>
  </pattern>  
  
    <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsSanAndSubjectName">

      <assert
         mssml:severity = "warning"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsSanAndSubjectName_title"/>
        <mssmlbpa:problem mssml:locid = "IsSanAndSubjectName_problem"/>
        <mssmlbpa:impact mssml:locid = "IsSanAndSubjectName_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsSanAndSubjectName_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsSanAndSubjectName_title"/>
        <mssmlbpa:compliant mssml:locid = "IsSanAndSubjectName_compliant"/>
      </report>

    </rule>
  </pattern> 
  
    <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IPHTTPSHasPrivateKey">

      <assert
         mssml:severity = "warning"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
		<value-of  select="../tns:IPHTTPSCertName" />
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IPHTTPSHasPrivateKey_title"/>
        <mssmlbpa:problem mssml:locid = "IPHTTPSHasPrivateKey_problem"/>
        <mssmlbpa:impact mssml:locid = "IPHTTPSHasPrivateKey_impact"/>
        <mssmlbpa:resolution mssml:locid = "IPHTTPSHasPrivateKey_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
		<value-of  select="../tns:IPHTTPSCertName" />
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IPHTTPSHasPrivateKey_title"/>
        <mssmlbpa:compliant mssml:locid = "IPHTTPSHasPrivateKey_compliant"/>
      </report>

    </rule>
  </pattern> 
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsDAPolicyPresent">

      <assert
         mssml:severity = "error"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsDAPolicyPresent_title"/>
        <mssmlbpa:problem mssml:locid = "IsDAPolicyPresent_problem"/>
        <mssmlbpa:impact mssml:locid = "IsDAPolicyPresent_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsDAPolicyPresent_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsDAPolicyPresent_title"/>
        <mssmlbpa:compliant mssml:locid = "IsDAPolicyPresent_compliant"/>
      </report>

    </rule>
  </pattern> 
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsSupportEmailConfigured">

      <assert
         mssml:severity = "warning"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsSupportEmailConfigured_title"/>
        <mssmlbpa:problem mssml:locid = "IsSupportEmailConfigured_problem"/>
        <mssmlbpa:impact mssml:locid = "IsSupportEmailConfigured_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsSupportEmailConfigured_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsSupportEmailConfigured_title"/>
        <mssmlbpa:compliant mssml:locid = "IsSupportEmailConfigured_compliant"/>
      </report>

    </rule>
  </pattern> 
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsDefaultGWConfigProper">

      <assert
         mssml:severity = "warning"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsDefaultGWConfigProper_title"/>
        <mssmlbpa:problem mssml:locid = "IsDefaultGWConfigProper_problem"/>
        <mssmlbpa:impact mssml:locid = "IsDefaultGWConfigProper_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsDefaultGWConfigProper_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsDefaultGWConfigProper_title"/>
        <mssmlbpa:compliant mssml:locid = "IsDefaultGWConfigProper_compliant"/>
      </report>

    </rule>
  </pattern> 
      
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsInvalidNrptExpPresent">

      <assert
         mssml:severity = "warning"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'false' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsInvalidNrptExpPresent_title"/>
        <mssmlbpa:problem mssml:locid = "IsInvalidNrptExpPresent_problem"/>
        <mssmlbpa:impact mssml:locid = "IsInvalidNrptExpPresent_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsInvalidNrptExpPresent_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'false' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsInvalidNrptExpPresent_title"/>
        <mssmlbpa:compliant mssml:locid = "IsInvalidNrptExpPresent_compliant"/>
      </report>

    </rule>
  </pattern>
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsDNS64AcptIfaceConfigValid">

      <assert
         mssml:severity = "error"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsDNS64AcptIfaceConfigValid_title"/>
        <mssmlbpa:problem mssml:locid = "IsDNS64AcptIfaceConfigValid_problem"/>
        <mssmlbpa:impact mssml:locid = "IsDNS64AcptIfaceConfigValid_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsDNS64AcptIfaceConfigValid_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsDNS64AcptIfaceConfigValid_title"/>
        <mssmlbpa:compliant mssml:locid = "IsDNS64AcptIfaceConfigValid_compliant"/>
      </report>

    </rule>
  </pattern>
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsDNSAddrConfigValid">
      <assert
         mssml:severity = "error"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsDNSAddrConfigValid_title"/>
        <mssmlbpa:problem mssml:locid = "IsDNSAddrConfigValid_problem"/>
        <mssmlbpa:impact mssml:locid = "IsDNSAddrConfigValid_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsDNSAddrConfigValid_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsDNSAddrConfigValid_title"/>
        <mssmlbpa:compliant mssml:locid = "IsDNSAddrConfigValid_compliant"/>
      </report>

    </rule>
  </pattern>

  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsIpHttpsCdpReachable">
      <assert
         mssml:severity = "warning"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsIpHttpsCdpReachable_title"/>
        <mssmlbpa:problem mssml:locid = "IsIpHttpsCdpReachable_problem"/>
        <mssmlbpa:impact mssml:locid = "IsIpHttpsCdpReachable_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsIpHttpsCdpReachable_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsIpHttpsCdpReachable_title"/>
        <mssmlbpa:compliant mssml:locid = "IsIpHttpsCdpReachable_compliant"/>
      </report>

    </rule>
  </pattern>

  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsNlsCdpReachable">
      <assert
         mssml:severity = "error"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsNlsCdpReachable_title"/>
        <mssmlbpa:problem mssml:locid = "IsNlsCdpReachable_problem"/>
        <mssmlbpa:impact mssml:locid = "IsNlsCdpReachable_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsNlsCdpReachable_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsNlsCdpReachable_title"/>
        <mssmlbpa:compliant mssml:locid = "IsNlsCdpReachable_compliant"/>
      </report>

    </rule>
  </pattern>

  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsNonPingProbesConfigured">
      <assert
         mssml:severity = "warning"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsNonPingProbesConfigured_title"/>
        <mssmlbpa:problem mssml:locid = "IsNonPingProbesConfigured_problem"/>
        <mssmlbpa:impact mssml:locid = "IsNonPingProbesConfigured_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsNonPingProbesConfigured_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsNonPingProbesConfigured_title"/>
        <mssmlbpa:compliant mssml:locid = "IsNonPingProbesConfigured_compliant"/>
      </report>

    </rule>
  </pattern>
  
  <pattern>
    <rule context = "tns:RemoteAccess/tns:RRASSERVER/tns:DA/tns:IsIsatapDnsRecordsProper">
      <assert
         mssml:severity = "error"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsIsatapDnsRecordsProper_title"/>
        <mssmlbpa:problem mssml:locid = "IsIsatapDnsRecordsProper_problem"/>
        <mssmlbpa:impact mssml:locid = "IsIsatapDnsRecordsProper_impact"/>
        <mssmlbpa:resolution mssml:locid = "IsIsatapDnsRecordsProper_resolution"/>
      </assert>

      <report
         mssml:severity = "info"
         mssml:category = "mssmlbpa:configuration mssmlbpa:markupv2"
         test = ". = 'true' ">
        <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=244318</mssmlbpa:helpTopic>
        <mssmlbpa:title mssml:locid = "IsIsatapDnsRecordsProper_title"/>
        <mssmlbpa:compliant mssml:locid = "IsIsatapDnsRecordsProper_compliant"/>
      </report>

    </rule>
  </pattern>

</schema>