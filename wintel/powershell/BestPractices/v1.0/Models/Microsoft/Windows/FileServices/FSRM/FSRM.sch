<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:mssml="http://schemas.microsoft.com/sml/extensions/2007/03"
    xmlns:mssmlbpa="http://schemas.microsoft.com/sml/bpa/2008/02">

    <ns prefix="tns" uri="http://schemas.microsoft.com/bestpractices/models/FileServices/FSRM/2011/04" />

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMServiceStatusCheck"
                mssml:severity="error"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:ServiceStarted = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMServiceStatusCheck_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMServiceStatusCheck_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMServiceStatusCheck_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMServiceStatusCheck_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=166131</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMServiceStatusCheck"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:ServiceStarted = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMServiceStatusCheck_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMServiceStatusCheck_Compliant" />
            </report>
        </rule>
    </pattern>
       
    <pattern>
        <!-- Notice this rule does not assert but just report -->
        <rule context="/tns:FSRMComposite/tns:FSRM/tns:Cluster">
            <report
                mssmlbpa:helpID="FSRMServiceStatusCheck"
                mssml:severity="error"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:ServiceInstallationOnClusterConsistent = 'false'"
                >
                <mssmlbpa:title mssml:locid="FSRMServiceStatusCheckOnCluster_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMServiceStatusCheckOnCluster_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMServiceStatusCheckOnCluster_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMServiceStatusCheckOnCluster_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164456</mssmlbpa:helpTopic>                
            </report>
            <report
                mssmlbpa:helpID="FSRMServiceStatusCheck"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:ServiceInstallationOnClusterConsistent = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMServiceStatusCheckOnCluster_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMServiceStatusCheckOnCluster_Compliant" />
            </report>
        </rule>
    </pattern>    

    <pattern>
        <!-- Notice this rule does not assert but just report -->
        <rule context="/tns:FSRMComposite/tns:FSRM/tns:Cluster">
            <report
                mssmlbpa:helpID="FSRMServiceStatusCheck"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:ServiceInstallationOnClusterConsistent = 'NA'"
                >
                <value-of select='tns:NotReachableNodes' />
                <mssmlbpa:title mssml:locid="FSRMServiceStatusCheckOnCluster_NotReachableNode_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMServiceStatusCheckOnCluster_NotReachableNode_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMServiceStatusCheckOnCluster_NotReachableNode_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMServiceStatusCheckOnCluster_NotReachableNode_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=165063</mssmlbpa:helpTopic>                
            </report>
        </rule>
    </pattern>    

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMClassificationSchedulePresent"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:ClassificationSchedulePresent = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMClassificationSchedulePresent_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMClassificationSchedulePresent_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMClassificationSchedulePresent_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMClassificationSchedulePresent_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164457</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMClassificationSchedulePresent"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:ClassificationSchedulePresent = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMClassificationSchedulePresent_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMClassificationSchedulePresent_Compliant" />
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMPropertyDefinitionCount"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:PropertyDefinitionCount = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMPropertyDefinitionCount_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMPropertyDefinitionCount_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMPropertyDefinitionCount_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMPropertyDefinitionCount_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164458</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMPropertyDefinitionCount"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:PropertyDefinitionCount = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMPropertyDefinitionCount_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMPropertyDefinitionCount_Compliant" />
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMQuotaCount"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:QuotaCount = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMQuotaCount_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMQuotaCount_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMQuotaCount_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMQuotaCount_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164459</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMQuotaCount"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:QuotaCount = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMQuotaCount_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMQuotaCount_Compliant" />
            </report>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMFileScreenCount"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:FileScreenCount = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMFileScreenCount_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMFileScreenCount_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMFileScreenCount_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMFileScreenCount_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164460</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMFileScreenCount"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:FileScreenCount = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMFileScreenCount_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMFileScreenCount_Compliant" />
            </report>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMCacheEnabled"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:CacheEnabled = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMCacheEnabled_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMCacheEnabled_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMCacheEnabled_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMCacheEnabled_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164461</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMCacheEnabled"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:CacheEnabled = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMCacheEnabled_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMCacheEnabled_Compliant" />
            </report>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM/tns:OrphanedLogs">
            <assert
                mssmlbpa:helpID="FSRMNoOrphanedLogs"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:NoOrphanedLogs = 'true'"
                >
                <value-of select="tns:Logs" />
                <mssmlbpa:title mssml:locid="FSRMNoOrphanedLogs_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMNoOrphanedLogs_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMNoOrphanedLogs_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMNoOrphanedLogs_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164469</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMNoOrphanedLogs"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:NoOrphanedLogs = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMNoOrphanedLogs_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMNoOrphanedLogs_Compliant" />
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMFewReadOnlyFiles"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:FewReadOnlyFiles = 'true'"
                >
                <value-of select="tns:LatestLogFile" />
                <mssmlbpa:title mssml:locid="FSRMFewReadOnlyFiles_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMFewReadOnlyFiles_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMFewReadOnlyFiles_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMFewReadOnlyFiles_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164466</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMFewReadOnlyFiles"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:FewReadOnlyFiles = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMFewReadOnlyFiles_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMFewReadOnlyFiles_Compliant" />
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMCacheSizeAdequate"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:CacheSizeAdequate = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMCacheSizeAdequate_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMCacheSizeAdequate_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMCacheSizeAdequate_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMCacheSizeAdequate_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=164463</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMCacheSizeAdequate"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:CacheSizeAdequate = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMCacheSizeAdequate_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMCacheSizeAdequate_Compliant" />
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM/tns:V2Schedules">
            <assert
                mssmlbpa:helpID="FSRMV2Schedules"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:HasV1Schedules = 'false'"
                >
                <value-of select="tns:FMJs" />
                <value-of select="tns:Reports" />
                <value-of select="tns:Classification" />
                <mssmlbpa:title mssml:locid="FSRMV2Schedules_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMV2Schedules_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMV2Schedules_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMV2Schedules_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=266383</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMV2Schedules"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:HasV1Schedules = 'false'"
                >
                <mssmlbpa:title mssml:locid="FSRMV2Schedules_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMV2Schedules_Compliant" />
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMFirewall"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:Firewall = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMFirewall_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMFirewall_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMFirewall_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMFirewall_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=266382</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMFirewall"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:Firewall = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMFirewall_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMFirewall_Compliant" />
            </report>
        </rule>
    </pattern>

    <pattern>
        <rule context="/tns:FSRMComposite/tns:FSRM">
            <assert
                mssmlbpa:helpID="FSRMWinRm"
                mssml:severity="warning"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:WinRm = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMWinRm_Title"/>
                <mssmlbpa:problem mssml:locid="FSRMWinRm_Problem" />
                <mssmlbpa:impact mssml:locid="FSRMWinRm_Impact" />
                <mssmlbpa:resolution mssml:locid="FSRMWinRm_Resolution" />
                <mssmlbpa:helpTopic>http://go.microsoft.com/fwlink/?LinkId=266381</mssmlbpa:helpTopic>                
            </assert>
            <report
                mssmlbpa:helpID="FSRMWinRm"
                mssml:severity="info"
                mssml:category="mssmlbpa:configuration mssmlbpa:advisory mssmlbpa:markupv2"
                test="tns:WinRm = 'true'"
                >
                <mssmlbpa:title mssml:locid="FSRMWinRm_Title"/>
                <mssmlbpa:compliant mssml:locid="FSRMWinRm_Compliant" />
            </report>
        </rule>
    </pattern>


</schema>