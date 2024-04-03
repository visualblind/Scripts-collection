
<#
  DHCP Export Import Cmdlet Module
  This module contains cmdlet for Export-DhcpServer & Import-DhcpServer  
 #>

# .ExternalHelp DhcpServerMigration.psm1-help.xml
function Export-DhcpServer
{
<#
    Export-DhcpServer exports the input ScopeId/Prefix or the complete DhcpServer settings to given input file.
    The xml file is created as per the DhcpServerSchema XSD (%systemdrive%\Windows\System32\WindowsPowerShell\v1.0\Modules\DhcpServer\DhcpServerSchema.xml)
    
    Input Parameters:
        File        : Mandatory Parameter where Exported settings will be stored
        ScopeId     : v4ScopeId. If this parameter is a non-IPv4Address value, TE will be returned
                      If the ScopeId doesnt exist on target Dhcp Server, NTE will be returned        
        Prefix      : v6Prefix. If this parameter is a non-IPv6Address value, TE will be returned
                      If the Prefix doesnt exist on target Dhcp Server, NTE will be returned        
        Leases      : Switch parameter - if given, Leases for all the exported Scopes will also be exported
        ComputerName: Hostname or IPAddress of the target Dhcp Server which need to be exported. If not given, localHost is used        
        CimSession  : CimSession (of type Microsoft.Management.Infrastructure.CimSession) of the target Dhcp Server which need to be exported.    
#>    
#region Param declarations
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]    
    Param(        
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        ${File},

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.Net.IPAddress[]]
        ${ScopeId},
        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.Net.IPAddress[]]
        ${Prefix},       

        [Parameter()]
        [switch]
        ${Leases},

        [Parameter()]
        [switch]
        ${Force},

        [Parameter()]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("Cn")]
        [string]
        ${ComputerName},
        
        [Parameter()]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimSession]
        ${CimSession} #TODO Need to test
    )
#endregion
    
    Begin {
        try {
            WriteTraceMessage "Export-DhcpServer::BEGIN Entered"
            [string]$script:ExportFile          = ""
            [bool]$script:IsExport              = $true
            [bool]$script:ExportFileCreated     = $false
            [bool]$script:ExportFailed          = $false
            [int]$script:ExportSetting          = $CompleteDhcpServer
            [int]$script:ProcessEntryCount      = 0
            [string]$script:DhcpServerName      = ""
            $script:TargetMcVersion             = $null            
            $script:writer                      = $null
            
            WriteExportInputValue
            
            #If ComputerName is not given, get the local computerName 
            #else user given ComputerName in $script:DhcpServerName variable
            GetComputerName ${ComputerName}
                        
            $script:ExportFile = GetFullyQualifiedPath ${File}
            if (Test-Path -LiteralPath $script:ExportFile -PathType leaf) {
                if (${Force}) { #User has asked to delete the file if already present
                    #Dont delete the file if its ReadOnly or Hidden i.e. Dont use the 'Force' flag with 'Remote-Item'
                    Remove-Item -LiteralPath $script:ExportFile -ErrorAction Stop
                }
                else {#If input File already exists & Force is not given, throw TE
                    ThrowTEString ($_system_translations.ExportedFileExists -f $script:ExportFile) $EC_ResourceExists $EC_ResourceExists $script:ExportFile
                }
            } 
                        
            WriteTraceMessage ($_system_translations.Ver_Export_Start -f $script:DhcpServerName,$script:ExportFile)
            Write-Verbose ($_system_translations.Ver_Export_Start -f $script:DhcpServerName,$script:ExportFile)
        }
        catch { 
            WriteTraceMessage "Inside Export-DhcpServer BEGIN catch"
            $script:ExportFailed = $true
            WriteExportInputValue
            throw 
        }
        
        finally  {
            WriteTraceMessage "Inside Export-DhcpServer BEGIN finally"
            WriteExportInputValue
            if ($script:ExportFailed -and (NotNull $script:writer))     { $script:writer.Close(); $script:writer = $null }            
        }
    }        

    Process {
    
        $script:scopesToBeExported          = @()
        $script:prefixesToBeExported        = @()        
        
        try 
        {    
            WriteTraceMessage "Export-DhcpServer::PROCESS Entered"            
            WriteExportInputValue
                        
            if (!(ValidateExportParams)) { WriteTraceMessage "Nothing to Export .. exiting"; return }

            #Give the WhatIf/Confirm (ShouldProcess) message
            if (!(HandleExportShouldProcess)) { WriteTraceMessage "ShouldProcess returned false .. exiting"; return }
            
            WriteTraceMessage "ExportSetting is $script:ExportSetting [CompleteDhcpServer=0, SpecificV4AndV6Scopes=1, SpecificV4Scopes=2, SpecificV6Scopes=3"
            
            $script:ProcessEntryCount += 1
            
            #Create the XML if its the first call to Process function
            if ($script:ProcessEntryCount -eq 1) {
                #Create the XmlWriter, Xml Namespace and Version Info
                PrepareExportXml $script:ExportFile
            }
            
            #Export v4 Server and v4 scopes
            if ($SpecificV6Scopes -ne $script:ExportSetting) {
                ExportDhcpv4Server
            }
            
            #Export v6 Server and v6 prefixes
            if ($SpecificV4Scopes -ne $script:ExportSetting) {
                ExportDhcpv6Server
            }
            
            WriteTraceMessage ($_system_translations.Ver_Export_End -f $script:DhcpServerName)
            Write-Verbose ($_system_translations.Ver_Export_End -f $script:DhcpServerName)
        }
        
        catch { 
            WriteTraceMessage "Inside Export-DhcpServer PROCESS catch"
            $script:ExportFailed = $true            
            throw 
        }
        
        finally  {
            WriteTraceMessage "Inside Export-DhcpServer PROCESS finally"
            if ($script:ExportFailed -and (NotNull $script:writer))     { $script:writer.Close(); $script:writer = $null }            
        }
    }
    
    End {
        WriteTraceMessage "Entered Export END"
        WriteExportInputValue
        if (!$script:ExportFailed -and (NotNull $script:writer))  { $script:writer.Close() }        
    }
}

#region Export Util Functions

# Validates the input ScopeId and Prefix parameters
# Populates $script:ExportSetting, $script:scopesToBeExported and $script:prefixesToBeExported variables
#     These variables are used to fill the apppropriate sections of the export file.
function ValidateExportParams()
{
    $errNte     = @()
    $errTE        = $null
    
    #Set the level at which export need to happen
    if ((IsNull ${ScopeId}) -and (IsNull ${Prefix})) {
        $script:ExportSetting = $CompleteDhcpServer
    } elseif ((NotNull ${ScopeId}) -and (NotNull ${Prefix})) {
        $script:ExportSetting = $SpecificV4AndV6Scopes    
    } elseif (NotNull ${ScopeId}) {
        $script:ExportSetting = $SpecificV4Scopes    
    } elseif (NotNull ${Prefix}) {
        $script:ExportSetting = $SpecificV6Scopes
    }
                
    if (${ScopeId} -ne $null) #User has given ScopeId(s) to be to exported - If they dont exist return NTE
    {    
        foreach ($scopeId in ${ScopeId})
        {
            if ($scopeId.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
                ThrowTEString ($_system_translations.InvalidIPv4ScopeAddress -f $scopeId) $EC_InvalidArgument $EC_InvalidArgument $scopeId
            }
            else {                
                $outObj = ExecuteCmdlet -CmdletName "Get-DhcpServerv4Scope" -MandatoryParams @{"ScopeId"=$scopeId} -Nte ([ref]$errNte)            
                if ($null -ne $errNte -and $errNte.Count -gt 0){ 
                    PostNteObject($errNte)
                    continue
                }                
                if (NotNull $outObj) { $script:scopesToBeExported += $outObj }
            }
        }
    }    
        
    if (${Prefix} -ne $null) #User has given Prefix(es) to be to exported - If they dont exist return NTE
    {    
        foreach ($prefix in ${Prefix})
        {
            if ($prefix.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetworkV6) {
                ThrowTEString ($_system_translations.InvalidIPv6ScopeAddress -f $prefix) $EC_InvalidArgument $EC_InvalidArgument $prefix
            }
            else {                
                $outObj = ExecuteCmdlet -CmdletName "Get-DhcpServerv6Scope" -MandatoryParams @{"Prefix"=$prefix} -Nte ([ref]$errNte)
                if ($null -ne $errNte -and $errNte.count -gt 0){
                    PostNteObject($errNte)
                    continue
                }
                if (NotNull $outObj) { $script:prefixesToBeExported += $outObj }
            }
        }
    }
    
    #If Complete Server need to be Exported, get all the v4 and v6 scopes
    if ($script:ExportSetting -eq $CompleteDhcpServer) {
        $outObj = ExecuteCmdlet -CmdletName "Get-DhcpServerv4Scope" -Nte ([ref]$errNte) #Not catching TE here - if it happens let the Export fail
        PostNteObject($errNte)
        if (NotNull $outObj) { $script:scopesToBeExported += $outObj }        
        
        $outObj = ExecuteCmdlet -CmdletName "Get-DhcpServerv6Scope" -Nte ([ref]$errNte) #Not catching TE here - if it happens let the Export fail
        PostNteObject($errNte)
        if (NotNull $outObj) { $script:prefixesToBeExported += $outObj }        
    }
    
    #Check if there is something to be exported
    $needToExport = $true
    if ($script:ExportSetting -eq $SpecificV4AndV6Scopes) {
        if (!$script:scopesToBeExported.Count -and !$script:prefixesToBeExported.Count){ #if both v4 and v6 dont exist, need to exit w/o any export
                $needToExport = $false;
            }
        elseif (($script:scopesToBeExported.Count -gt 0) -and !$script:prefixesToBeExported.Count) { #if only v4 exists and no v6 exists, need to export only v4 server and scope
            $script:ExportSetting = $SpecificV4Scopes
        }
        elseif (($script:prefixesToBeExported.Count -gt 0) -and !$script:scopesToBeExported.Count) { #if only v6 exists and no v4 exists, need to export only v6 server and scope
            $script:ExportSetting = $SpecificV6Scopes
        }
    }
    elseif ($script:ExportSetting -eq $SpecificV4Scopes) {
        if (!$script:scopesToBeExported.Count) {
                $needToExport = $false;
            }
    }
    elseif ($script:ExportSetting -eq $SpecificV6Scopes) {
        if (!$script:prefixesToBeExported.Count) {
                $needToExport = $false;
            }
    }
            
    return $needToExport
}

#Handles the ShouldProcess for Export-DhcpServer
function HandleExportShouldProcess
{    
    if ($script:ExportSetting -eq $CompleteDhcpServer) {
        if (${Leases}) { $shouldProcesMsg = ($_system_translations.Msg_Export_DhcpServer_2 -f $script:DhcpServerName, $script:ExportFile) }
        else { $shouldProcesMsg = ($_system_translations.Msg_Export_DhcpServer_4 -f $script:DhcpServerName, $script:ExportFile) }
    } else {
        [string]$listOfScopes = ""
        $firstPass = $true;
        if (NotNull $script:scopesToBeExported) {            
            foreach ($scope in $script:scopesToBeExported) {
                if (!$firstPass) { $listOfScopes += ", " + $scope.ScopeId.ToString() }
                else { $listOfScopes = $scope.ScopeId.ToString(); $firstPass = $false }
            }                    
        }
        
        if (NotNull $script:prefixesToBeExported) {            
            foreach ($prefix in $script:prefixesToBeExported) {
                if (!$firstPass) { $listOfScopes += ", " + $prefix.Prefix.ToString() }
                else { $listOfScopes += $prefix.Prefix.ToString(); $firstPass = $false }                
            }
        }        
        if (${Leases}) { $shouldProcesMsg = ($_system_translations.Msg_Export_DhcpServer_1 -f $listOfScopes,$script:DhcpServerName, $script:ExportFile) }
        else { $shouldProcesMsg = ($_system_translations.Msg_Export_DhcpServer_3 -f $listOfScopes,$script:DhcpServerName, $script:ExportFile) }
    }
    
    return ($PSCmdlet.ShouldProcess($shouldProcesMsg, $null, $null))
}

#Handles the ShouldProcess and ShouldContinue for Import-DhcpServer
function HandleImportShouldProcessAndShouldContinue
{    
    if ($script:ImportSetting -eq $CompleteDhcpServer) {
        if (${Leases}) { 
            $shouldProcesMsg    = ($_system_translations.Msg_Import_DhcpServer_2 -f $script:ImportFile,$script:DhcpServerName,"") 
            $shouldContinueMsg  = ($_system_translations.Msg_Import_DhcpServer_2 -f $script:ImportFile,$script:DhcpServerName,$_system_translations.ShoudContinueConfirmation) 
        }
        else { 
            $shouldProcesMsg    = ($_system_translations.Msg_Import_DhcpServer_4 -f $script:ImportFile,$script:DhcpServerName,"")
            $shouldContinueMsg  = ($_system_translations.Msg_Import_DhcpServer_4 -f $script:ImportFile,$script:DhcpServerName,$_system_translations.ShoudContinueConfirmation)
        }
    } else {
        [string]$listOfScopes = ""
        $firstPass = $true;
        if (NotNull $script:scopesToBeImported) {            
            foreach ($scope in $script:scopesToBeImported) {
                if (!$firstPass) { $listOfScopes += ", " + $scope }
                else { $listOfScopes = $scope; $firstPass = $false }
            }                    
        }
        
        if (NotNull $script:prefixesToBeImported) {            
            foreach ($prefix in $script:prefixesToBeImported) {
                if (!$firstPass) { $listOfScopes += ", " + $prefix }
                else { $listOfScopes += $prefix; $firstPass = $false }                
            }
        }        
        if (${Leases}) { 
            $shouldProcesMsg    = ($_system_translations.Msg_Import_DhcpServer_1 -f $script:ImportFile,$script:DhcpServerName,$listOfScopes,"")
            $shouldContinueMsg  = ($_system_translations.Msg_Import_DhcpServer_1 -f $script:ImportFile,$script:DhcpServerName,$listOfScopes,$_system_translations.ShoudContinueConfirmation)
        }
        else { 
            $shouldProcesMsg    = ($_system_translations.Msg_Import_DhcpServer_3 -f $script:ImportFile,$script:DhcpServerName,$listOfScopes,"") 
            $shouldContinueMsg  = ($_system_translations.Msg_Import_DhcpServer_3 -f $script:ImportFile,$script:DhcpServerName,$listOfScopes,$_system_translations.ShoudContinueConfirmation) 
        }
    }
    
    $result = $PSCmdlet.ShouldProcess($shouldProcesMsg, $null, $null);
    if ($result -and (!${Force})) {
        $result = $PSCmdlet.ShouldContinue($shouldContinueMsg, $_system_translations.ShoudContinueCaption);
    }
    return $result;    
}

# Creates the XmlWriter object ($script:writer)
# Initializes the Root Node and writes version information to Xml file
function PrepareExportXml([string] $file)
{
    try    {
        InitializeXmlWriter $file
        $script:writer.WriteStartElement($XmlRootNode, $DhcpSchemaName);
        $outObj = ExecuteCmdlet -CmdletName Get-DhcpServerVersion        
        $script:writer.WriteElementString($MajorVersionElement, "", $outObj.MajorVersion);
        $script:writer.WriteElementString($MinorVersionElement, "", $outObj.MinorVersion);        
        $script:writer.Flush()
        $script:TargetMcVersion     = $outObj
        $script:ExportFileCreated   = $true
    }
    catch {
        WriteTraceMessage "PrepareExportXml failed"
        throw
    }    
}

# Creates the XmlWriter object ($script:writer)
function InitializeXmlWriter([string] $file)
{
    try    {    
        WriteTraceMessage "File to be exported: $file"
                
        $xmlSettings = new-object System.Xml.XmlWriterSettings
        $xmlSettings.Indent = $true;
        $xmlSettings.CheckCharacters = $false;
        
        $script:writer = [Xml.XmlWriter]::Create($file, $xmlSettings)        
    }
    catch {
        WriteTraceMessage "InitializeXmlWriter threw exception"
        throw
    }
}

function GetClassHashTable($class, $mandatory, $optional, [bool]$IsV4)
{
    $mandatory[$ClassPropertiesMandatory[0]]     = $class.Name
    $mandatory[$ClassPropertiesMandatory[1]]     = $class.Type
    $mandatory[$ClassPropertiesMandatory[2]]     = $class.Data
    if (NotNull $class.Description) { $optional[$ClassPropertiesOptional[0]] = $class.Description }
    if (!($IsV4)) { $optional[$ClassPropertiesOptional[1]] = $class.VendorId }
}

function ExportDhcpClassElement($class, [bool]$IsV4)
{
    $mandatory  = @{}
    $optional   = @{}
    GetClassHashTable $class $mandatory $optional $IsV4
    GenericXmlWriter $mandatory $ClassPropertiesMandatory $optional $ClassPropertiesOptional    
}

function ExportDhcpClasses([bool]$IsV4)
{
    $errNte     = $null
    $errTE      = $null
    $classes    = @()
    
    Write-Verbose $_system_translations.Ver_Export_Classes
    
    if ($IsV4) { $cmdlet = "Get-DhcpServerv4Class" } else { $cmdlet = "Get-DhcpServerv6Class" }
    $temp = ExecuteCmdlet -CmdletName $cmdlet -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    if (NotNull $temp) { $classes += $temp }
    WriteTraceMessage "Total number of classes: $($classes.Count)"
    
    $script:writer.WriteStartElement($ClassesElement);
    foreach($class in $classes){
        $script:writer.WriteStartElement($ClassElement);
        ExportDhcpClassElement $class $IsV4    
        $script:writer.WriteEndElement(); #Class node
    }
    
    $script:writer.WriteEndElement(); #Classes node
    $script:writer.Flush();    
}

function GetOptValueHashTable($optValue, $mandatory, $optional, [bool]$IsV4)
{
    $mandatory[$OptValuePropertiesMandatory[0]]     = $optValue.OptionId

    if (NotNull $optValue.Value) { $optional[$OptValuePropertiesOptional[0]] = $optValue.Value }
    if (NotNull $optValue.VendorClass) { $optional[$OptValuePropertiesOptional[1]] = $optValue.VendorClass }
    if (NotNull $optValue.UserClass)   { $optional[$OptValuePropertiesOptional[2]] = $optValue.UserClass   }
}

function ExportDhcpOptValueElement($optValue, [bool]$IsV4)
{
    $mandatory  = @{}
    $optional   = @{}
    GetOptValueHashTable $optValue $mandatory $optional $IsV4
    GenericXmlWriter $mandatory $OptValuePropertiesMandatory $optional $OptValuePropertiesOptional    
}

function ExportDhcpOptionValues ([bool]$IsV4, [string]$ScopeId=$null, [string]$ReservedIP=$null, [string]$PolicyName=$null)
{    
    $errNte             = @()
    $errTE              = $null
    [Array]$optValues   = @()
    if ($IsV4) { $scope = "ScopeId" } else { $scope = "Prefix" }
    
    if ((IsNullOrEmptyString $ScopeId) -and (IsNullOrEmptyString $ReservedIP) -and (IsNullOrEmptyString $PolicyName)) { 
        Write-Verbose $_system_translations.Ver_Export_Server_OptValue; 
        $optionalParam = $null
    }
    elseif (!(IsNullOrEmptyString $ScopeId) -and (IsNullOrEmptyString $PolicyName)) { 
        Write-Verbose ($_system_translations.Ver_Export_Scope_OptValue -f $ScopeId); 
        $optionalParam = @{$scope=$ScopeId } 
    }
    elseif (!(IsNullOrEmptyString $ScopeId) -and !(IsNullOrEmptyString $PolicyName)) { 
        Write-Verbose ($_system_translations.Ver_Export_Scope_Pol_OptValue -f $PolicyName,$ScopeId); 
        $optionalParam = @{$scope=$ScopeId; "PolicyName"=$PolicyName} 
    }    
    elseif (!(IsNullOrEmptyString $ReservedIP)) { 
        Write-Verbose ($_system_translations.Ver_Export_Rsvation_OptValue -f $ReservedIP); 
        $optionalParam = @{"ReservedIP"=$ReservedIP}
    }
    elseif ((IsNullOrEmptyString $ScopeId) -and !(IsNullOrEmptyString $PolicyName)) { 
        Write-Verbose ($_system_translations.Ver_Export_Server_Pol_OptValue -f $PolicyName); 
        $optionalParam = @{"PolicyName"=$PolicyName} 
    }    
    
    if ($IsV4) { $cmdlet = "Get-DhcpServerv4OptionValue -All -Brief" } else { $cmdlet = "Get-DhcpServerv6OptionValue -All -Brief" }
    $temp = ExecuteCmdlet -CmdletName $cmdlet -OptionalParams $optionalParam -Nte ([ref]$errNte) -TE ([ref]$errTE)
    
    PostNteObject $errTE; PostNteObject $errNte
    if (NotNull $temp) { $optValues += $temp; $optValues = $optValues | sort -Property OptionId,UserClass }
    WriteTraceMessage "Total number of OptValues: $($optValues.Count)"
    
    if ($optValues.Count -gt 0) {
        $script:writer.WriteStartElement($OptValuesElement);
        foreach($optValue in $optValues){
            $script:writer.WriteStartElement($OptValueElement);
            ExportDhcpOptValueElement $optValue $IsV4    
            $script:writer.WriteEndElement(); #OptionValue End node
        }
        
        $script:writer.WriteEndElement(); #OptionValues End node
        $script:writer.Flush();    
    }
}

function ExportDhcpv6StatelessStore([string]$Prefix="")
{
    $errNte                     = @()
    $errTE                      = $null
    [HashTable]$optionalParam   = $null
        
    if (IsNullOrEmptyString $Prefix) { $optionalParam = $null }
    elseif (!(IsNullOrEmptyString $Prefix)) { $optionalParam = @{"Prefix"=$Prefix } }
    
    $stateLessStore = ExecuteCmdlet -CmdletName Get-DhcpServerv6StatelessStore -OptionalParams $optionalParam -Nte ([ref]$errNte) -TE ([ref]$errTE)    
    PostNteObject $errTE; PostNteObject $errNte
            
    if (NotNull $stateLessStore) {
        $script:writer.WriteStartElement($StatelessElement);
        $script:writer.WriteElementString($StatelessEnabledElement, $stateLessStore.Enabled.ToString().ToLower());
        $script:writer.WriteElementString($StatelessPurgeIntervalElement, $stateLessStore.PurgeInterval.ToString());
        $script:writer.WriteEndElement(); #Stateless element End node
        $script:writer.Flush();    
    }
}

function ExportIPRanges($IPRanges, $StartElement)
{
    if ($IPRanges.Count -gt 0) {        
        $script:writer.WriteStartElement($StartElement);
        foreach ($ipRange in $IPRanges) {
            $script:writer.WriteStartElement($IPRangeElement);
            $script:writer.WriteElementString($StartIPRangeElement, $ipRange.StartRange);
            $script:writer.WriteElementString($EndIPRangeElement, $ipRange.EndRange);
            $script:writer.WriteEndElement(); #IPRange End node
        }        
        $script:writer.WriteEndElement(); #IPRanges End node
    }
}

function GetPolicyHashTable($Policy, [HashTable]$mandatory, [HashTable]$optional)
{
    $mandatory[$PolicyPropertiesMandatory[0]]     = $Policy.Name
    $mandatory[$PolicyPropertiesMandatory[1]]     = $Policy.ProcessingOrder
    $mandatory[$PolicyPropertiesMandatory[2]]     = $Policy.Enabled.ToString().ToLower()
    $mandatory[$PolicyPropertiesMandatory[3]]     = $Policy.Condition
    
    if (NotNull $Policy.Description)  { $optional[$PolicyPropertiesOptional[0]] = $Policy.Description }
    if (NotNull $Policy.VendorClass)  { $optional[$PolicyPropertiesOptional[1]] = $Policy.VendorClass }
    if (NotNull $Policy.UserClass)    { $optional[$PolicyPropertiesOptional[2]] = $Policy.UserClass }
    if (NotNull $Policy.MacAddress)   { $optional[$PolicyPropertiesOptional[3]] = $Policy.MacAddress }
    if (NotNull $Policy.ClientId)     { $optional[$PolicyPropertiesOptional[4]] = $Policy.ClientId }
    if (NotNull $Policy.RelayAgent)   { $optional[$PolicyPropertiesOptional[5]] = $Policy.RelayAgent }
    if (NotNull $Policy.CircuitId)    { $optional[$PolicyPropertiesOptional[6]] = $Policy.CircuitId }
    if (NotNull $Policy.RemoteId)     { $optional[$PolicyPropertiesOptional[7]] = $Policy.RemoteId }
    if (NotNull $Policy.SubscriberId) { $optional[$PolicyPropertiesOptional[8]] = $Policy.SubscriberId }    
    if (NotNull $Policy.Fqdn)         { $optional[$PolicyPropertiesOptional[9]] = $Policy.Fqdn }    
}

function ExportDhcpPolicyElement($Policy)
{
    [HashTable]$mandatory   = @{}
    [HashTable]$optional    = @{}
    $policyIPRanges         = @()
    $errTE = $null; $errNte = @()
    
    if ($Policy.ScopeId.ToString() -ne "0.0.0.0") { 
        $policyScopeId = $Policy.ScopeId.ToString() 
        $optionalParam = @{"ScopeId" = $Policy.ScopeId }
        
    } else {
        $policyScopeId = "" 
        $optionalParam = $null
    }
    
    GetPolicyHashTable $Policy $mandatory $optional

    $temp = ExecuteCmdlet -CmdletName "Get-DhcpServerV4DnsSetting -PolicyName `"$($Policy.Name)`"" -OptionalParams $optionalParam -Nte ([ref]$errNte) -TE ([ref]$errTE)    
    PostNteObject $errTE; PostNteObject $errNte    
    if (NotNull $temp.DnsSuffix) { $optional[$PolicyPropertiesOptional[10]] = $temp.DnsSuffix }  
    
    GenericXmlWriter $mandatory $PolicyPropertiesMandatory $optional $PolicyPropertiesOptional    
    
    
    #Export Policy IPRange if its at scope level
    if (!(IsNullOrEmptyString  $policyScopeId)) {
        $temp = ExecuteCmdlet -CmdletName "Get-DhcpServerv4PolicyIPRange -Name `"$($Policy.Name)`" -ScopeId $($Policy.ScopeId)" -Nte ([ref]$errNte) -TE ([ref]$errTE)
        PostNteObject($errTE); PostNteObject($errNte)
        if (NotNull $temp) { $policyIPRanges += $temp }
        ExportIPRanges $policyIPRanges $IPRangesElement
    }
        
    ExportDhcpOptionValues $true $policyScopeId "" $Policy.Name
}

function ExportDhcpv4Policies([string]$ScopeId="")
{    
    $errNte                         = $null
    $errTE                          = $null
    [Array]$policies                = @()    
    [string]$verboseExportMessage   = ""
    [HashTable]$optionalParam       = $null    

    if (IsNullOrEmptyString $ScopeId) { $verboseExportMessage = $_system_translations.Ver_Export_Server_Policy; $optionalParam = $null }
    elseif (!(IsNullOrEmptyString $ScopeId)) { $verboseExportMessage = ($_system_translations.Ver_Export_Scope_Policy -f $ScopeId); $optionalParam = @{"ScopeId" = $ScopeId } } 
        
    WriteTraceMessage $verboseExportMessage
    Write-Verbose $verboseExportMessage    
        
    $temp = ExecuteCmdlet -CmdletName Get-DhcpServerv4Policy -OptionalParams $optionalParam -Nte ([ref]$errNte) -TE ([ref]$errTE)    
    PostNteObject $errTE; PostNteObject $errNte
    if (NotNull $temp) { $policies += $temp; $policies = $policies | sort -Property ProcessingOrder }
    WriteTraceMessage "Total number of Policies: $($policies.Count)"
    
    if ($policies.Count -gt 0) {
        $script:writer.WriteStartElement($PoliciesElement);
        foreach($policy in $policies){
            $script:writer.WriteStartElement($PolicyElement);
            ExportDhcpPolicyElement $policy
            $script:writer.WriteEndElement(); #Policy End node
        }
        
        $script:writer.WriteEndElement(); #Policies End node
        $script:writer.Flush();    
    }
}

function GetReservationHashTable([bool]$IsV4, $Reservation, [HashTable]$mandatory, [HashTable]$optional)
{
    $mandatory[$ReservationPropertiesMandatory[0]]     = $Reservation.Name
    $mandatory[$ReservationPropertiesMandatory[1]]     = $Reservation.IPAddress    
    
    if ($IsV4) {
        $optional[$ReservationPropertiesOptional[0]] = $Reservation.ClientId
        $optional[$ReservationPropertiesOptional[1]] = $Reservation.Type
    }
    else {
        $optional[$ReservationPropertiesOptional[2]] = $Reservation.ClientDuid
        $optional[$ReservationPropertiesOptional[3]] = $Reservation.IAID
    }
    
    if (NotNull $Reservation.Description)  { $optional[$ReservationPropertiesOptional[4]] = $Reservation.Description }    
}

function ExportDhcpReservationElement([bool]$IsV4, $Reservation)
{
    [HashTable]$mandatory   = @{}
    [HashTable]$optional    = @{}
    $errTE = $null; $errNte = @()
    
    GetReservationHashTable $IsV4 $Reservation $mandatory $optional
    GenericXmlWriter $mandatory $ReservationPropertiesMandatory $optional $ReservationPropertiesOptional    
    
    #Export Reservation level option values
    ExportDhcpOptionValues $IsV4 "" $Reservation.IPAddress.ToString()
}

function ExportDhcpReservations([bool] $IsV4, [string] $ScopeId)
{
    $errNte                         = $null
    $errTE                          = $null
    [Array]$reservations            = @()    
                
    WriteTraceMessage ($_system_translations.Ver_Export_Scope_Rsvation -f $ScopeId)
    Write-Verbose ($_system_translations.Ver_Export_Scope_Rsvation -f $ScopeId)
    
    if ($IsV4) { $cmdlet = "Get-DhcpServerv4Reservation -ScopeId $ScopeId" }
    else { $cmdlet = "Get-DhcpServerv6Reservation -Prefix $ScopeId" }
        
    $temp = ExecuteCmdlet -CmdletName $cmdlet -Nte ([ref]$errNte) -TE ([ref]$errTE)    
    PostNteObject $errTE; PostNteObject $errNte
    if (NotNull $temp) { $reservations += $temp }
    WriteTraceMessage "Total number of Reservations: $($reservations.Count)"
    
    if ($reservations.Count -gt 0) {
        $script:writer.WriteStartElement($ReservationsElement);
        foreach($reservation in $reservations){
            $script:writer.WriteStartElement($ReservationElement);
            ExportDhcpReservationElement $IsV4 $reservation
            $script:writer.WriteEndElement(); #Reservation End node
        }
        
        $script:writer.WriteEndElement(); #Reservations End node
        $script:writer.Flush();    
    }
}

function GetLeaseHashTable($Lease, [HashTable]$mandatory, [HashTable]$optional)
{
    $mandatory[$LeasePropertiesMandatory[0]]     = $Lease.IPAddress
    $mandatory[$LeasePropertiesMandatory[1]]     = $Lease.ScopeId
    $mandatory[$LeasePropertiesMandatory[2]]     = $Lease.ClientId
    $mandatory[$LeasePropertiesMandatory[3]]     = $Lease.AddressState
    $mandatory[$LeasePropertiesMandatory[4]]     = $Lease.ClientType    
    $mandatory[$LeasePropertiesMandatory[5]]     = $Lease.NapCapable.ToString().ToLower()
    
    if (NotNull $Lease.DnsRR)                     { $optional[$LeasePropertiesOptional[0]] = $Lease.DnsRR }
    if (NotNull $Lease.DnsRegistration)        { $optional[$LeasePropertiesOptional[1]] = $Lease.DnsRegistration }
    if (NotNull $Lease.LeaseExpiryTime)      { $optional[$LeasePropertiesOptional[2]] = $Lease.LeaseExpiryTime.ToUniversalTime().ToString("u") } #'u' format uses InvariantCulture and represents a UTC based time
    if (NotNull $Lease.ProbationEnds)          { $optional[$LeasePropertiesOptional[3]] = $Lease.ProbationEnds.ToUniversalTime().ToString("u") }    
    if (NotNull $Lease.NapStatus)                { $optional[$LeasePropertiesOptional[4]] = $Lease.NapStatus }
    if (NotNull $Lease.HostName)                { $optional[$LeasePropertiesOptional[5]] = $Lease.HostName }
    if (NotNull $Lease.PolicyName)              { $optional[$LeasePropertiesOptional[6]] = $Lease.PolicyName }
    if (NotNull $Lease.Description)              { $optional[$LeasePropertiesOptional[7]] = $Lease.Description }
}

function ExportDhcpv4LeaseElement()
{
    process {
    
        $script:writer.WriteStartElement($LeaseElement);
        
        [HashTable]$mandatory   = @{}
        [HashTable]$optional    = @{}
                
        GetLeaseHashTable $_ $mandatory $optional
        GenericXmlWriter $mandatory $LeasePropertiesMandatory $optional $LeasePropertiesOptional
        
        $script:writer.WriteEndElement(); #Lease End node
    }
}

function ExportDhcpv4Leases([string] $ScopeId)
{
    $errNte                 = $null
    $errTE                  = $null
                
    WriteTraceMessage ($_system_translations.Ver_Export_Scope_Lease -f $ScopeId)
    Write-Verbose ($_system_translations.Ver_Export_Scope_Lease -f $ScopeId)
        
    $script:writer.WriteStartElement($LeasesElement);
    
    $cmdlet = ExecuteCmdlet -CmdletName "Get-DhcpServerv4Lease -ScopeId $ScopeId -AllLeases" -Nte ([ref]$errNte) -TE ([ref]$errTE) -DontRun
    $pipelineCmdlet = "$cmdlet | ExportDhcpv4LeaseElement"
    WriteTraceMessage "Running Cmdlet: $pipelineCmdlet"
    try { Invoke-Expression  $pipelineCmdlet}    
    catch { PostNteObject $_ }
        
    $script:writer.WriteEndElement(); #Leases End node
    $script:writer.Flush();
}

function Getv4ScopeHashTable($scopeToExport, [HashTable]$mandatory, [HashTable]$optional)
{
    $mandatory[$Scopev4PropertiesMandatory[0]]         = $scopeToExport.ScopeId
    $mandatory[$Scopev4PropertiesMandatory[1]]         = $scopeToExport.Name
    $mandatory[$Scopev4PropertiesMandatory[2]]         = $scopeToExport.SubnetMask
    $mandatory[$Scopev4PropertiesMandatory[3]]         = $scopeToExport.StartRange
    $mandatory[$Scopev4PropertiesMandatory[4]]         = $scopeToExport.EndRange
    $mandatory[$Scopev4PropertiesMandatory[5]]         = $scopeToExport.LeaseDuration.ToString()
    $mandatory[$Scopev4PropertiesMandatory[6]]         = $scopeToExport.State
    $mandatory[$Scopev4PropertiesMandatory[7]]         = $scopeToExport.Type
    $mandatory[$Scopev4PropertiesMandatory[8]]         = $scopeToExport.MaxBootpClients
    $mandatory[$Scopev4PropertiesMandatory[9]]         = $scopeToExport.NapEnable.ToString().ToLower()

    if (NotNull $scopeToExport.Delay)                   { $optional[$Scopev4PropertiesOptional[0]] = $scopeToExport.Delay }    
    if (NotNull $scopeToExport.NapProfile)              { $optional[$Scopev4PropertiesOptional[1]] = $scopeToExport.NapProfile }
    if (NotNull $scopeToExport.Description)             { $optional[$Scopev4PropertiesOptional[2]] = $scopeToExport.Description }
    if (NotNull $scopeToExport.ActivatePolicies)        { $optional[$Scopev4PropertiesOptional[3]] = $scopeToExport.ActivatePolicies.ToString().ToLower() }
    if (NotNull $scopeToExport.SuperScopeName)          { $optional[$Scopev4PropertiesOptional[4]] = $scopeToExport.SuperScopeName }
}

function ExportDhcpv4Scope($scopeToExport)
{
    [HashTable]$mandatory   = @{}
    [HashTable]$optional    = @{}
    $errNte                 = @()
    $errTE                  = $null
    $exIPRanges             = @()
    
    Getv4ScopeHashTable $scopeToExport $mandatory $optional
    GenericXmlWriter $mandatory $Scopev4PropertiesMandatory $optional $Scopev4PropertiesOptional    
    
    #Export Scope IPRange
    $temp = ExecuteCmdlet -CmdletName "Get-DhcpServerv4ExclusionRange -ScopeId $($scopeToExport.ScopeId)" -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject($errTE); PostNteObject($errNte)
    if (NotNull $temp) { $exIPRanges += $temp }
    if ($exIPRanges.Count -gt 0) { Write-Verbose ($_system_translations.Ver_Export_Scope_ExRanges -f $($scopeToExport.ScopeId.ToString())) }    
    ExportIPRanges $exIPRanges $ExclusionRangesElement
    
    if (IsWindows8OrHigher($script:TargetMcVersion)) {
        #Export v4Scope Policies
        ExportDhcpv4Policies $scopeToExport.ScopeId.ToString()
    }
    
    #Export v4Scope OptionValues
    ExportDhcpOptionValues $true $scopeToExport.ScopeId.ToString()
    
    #Export v4Scope Reservation
    ExportDhcpReservations $true $scopeToExport.ScopeId.ToString()
    
    #Export v4Scope Leases if Lease switch paramter is given
    if (${Leases}) {
        ExportDhcpv4Leases $scopeToExport.ScopeId.ToString()
    }
}

function ExportDhcpv4Scopes()
{    
    $errNte                 = $null
    $errTE                  = $null
    [Array]$policies        = @()    

    WriteTraceMessage "Started exporting v4Scopes"
    
    if ($script:ProcessEntryCount -eq 1) { #Write Scopes Start Node only when the Process function is called for the first time
        $script:writer.WriteStartElement($ScopesElement); #Scopes Start Element        
    }
    
    foreach ($scopeToExport in $script:scopesToBeExported) {
        
        WriteTraceMessage ($_system_translations.Ver_Export_Scope -f $scopeToExport.ScopeId.ToString(),$script:DhcpServerName)
        Write-Verbose ($_system_translations.Ver_Export_Scope -f $scopeToExport.ScopeId.ToString(), $script:DhcpServerName)
        
        $script:writer.WriteStartElement($ScopeElement);    #Scope Start node
        ExportDhcpv4Scope $scopeToExport
        $script:writer.WriteEndElement();                     #Scope End node        
        $script:writer.Flush();    
    }
    
    if (($script:ExportSetting -eq $CompleteDhcpServer) -or ($script:ExportSetting -eq $SpecificV4AndV6Scopes)) {        
        $script:writer.WriteEndElement(); #Scopes End node
    }
}
 
function GetFilterHashTable($Filter, [HashTable]$mandatory, [HashTable]$optional)
{
    $mandatory[$FilterPropertiesMandatory[0]]     = $Filter.List
    $mandatory[$FilterPropertiesMandatory[1]]     = $Filter.MacAddress    
    
    if (NotNull $Filter.Description)  { $optional[$FilterPropertiesOptional[0]] = $Filter.Description }    
}

function ExportDhcpFilterElement($Filter)
{
    [HashTable]$mandatory   = @{}
    [HashTable]$optional    = @{}
    GetFilterHashTable $Filter $mandatory $optional
    GenericXmlWriter $mandatory $FilterPropertiesMandatory $optional $FilterPropertiesOptional        
}

function ExportDhcpv4Filters()
{    
    $errNte         = @()
    $errTE          = $null
    $filters        = @()
    
    WriteTraceMessage $_system_translations.Ver_Export_Server_Filter
    Write-Verbose $_system_translations.Ver_Export_Server_Filter    
        
    $filterList = ExecuteCmdlet -CmdletName Get-DhcpServerv4FilterList -Nte ([ref]$errNte) -TE ([ref]$errTE)    
    if (NotNull $errTE) { $allow = $false; $deny = $false } else { $allow = $filterList.Allow; $deny = $filterList.Deny }
    PostNteObject $errTE; PostNteObject $errNte
    
    $script:writer.WriteStartElement($FiltersElement);
    $script:writer.WriteElementString($FilterListAllowElement, $allow.ToString().ToLower());
    $script:writer.WriteElementString($FilterListDenyElement,  $deny.ToString().ToLower());
        
    $temp = ExecuteCmdlet -CmdletName Get-DhcpServerv4Filter -Nte ([ref]$errNte) -TE ([ref]$errTE)    
    PostNteObject $errTE; PostNteObject $errNte
    if (NotNull $temp) { $filters += $temp}
    
    if ($filters.Count -gt 0) {
        foreach($filter in $filters){
            $script:writer.WriteStartElement($FilterElement);
            ExportDhcpFilterElement $filter
            $script:writer.WriteEndElement(); #Filter End node
        }        
    }
        
    $script:writer.WriteEndElement(); #Filters End node
    $script:writer.Flush();    
}


function GetOptDefHashTable($optDef, $mandatory, $optional)
{
    $mandatory[$OptDefPropertiesMandatory[0]]     = $optDef.Name
    $mandatory[$OptDefPropertiesMandatory[1]]     = $optDef.OptionId
    $mandatory[$OptDefPropertiesMandatory[2]]     = $optDef.Type
    $mandatory[$OptDefPropertiesMandatory[3]]     = $optDef.MultiValued.ToString().ToLower()    
        
    if ((NotNull $optDef.DefaultValue) -and $optDef.DefaultValue.Count -gt 0)    { $optional[$OptDefPropertiesOptional[0]] = $optDef.DefaultValue }    
    if (NotNull $optDef.Description)                                             { $optional[$OptDefPropertiesOptional[1]] = $optDef.Description  }        
    if (NotNull $optDef.VendorClass)                                             { $optional[$OptDefPropertiesOptional[2]] = $optDef.VendorClass  }            
}

function ExportDhcpOptDefElement($optDef)
{
    $mandatory  = @{}
    $optional   = @{}
    GetOptDefHashTable $optDef $mandatory $optional
    GenericXmlWriter $mandatory $OptDefPropertiesMandatory $optional $OptDefPropertiesOptional
}

function GetAllOptionDefinitions([bool] $IsV4)
{
    $errNte = @(); $errTE = $null   
   
    [Array]$allOptDefs = @()
    if ($IsV4) { $cmdlet = "Get-DhcpServerv4OptionDefinition -All" } else { $cmdlet = "Get-DhcpServerv6OptionDefinition -All" }
    $temp = ExecuteCmdlet -CmdletName $cmdlet -Nte ([ref]$errNte) -Te ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    if (NotNull $temp) { $allOptDefs += $temp }
    
    return $allOptDefs
}

function ExportDhcpOptionDefinitions([bool]$IsV4)
{
    $errNte = $null
    $errTE     = $null
    [Array]$optDefs = @()
    Write-Verbose $_system_translations.Ver_Export_OptDef
    
    $optDefs = GetAllOptionDefinitions $IsV4
    
    if ((NotNull $optDefs) -and ($optDefs.Count -gt 0)) {
        WriteTraceMessage "Total number of OptDefinition: $($optDefs.Count)"
        
        $script:writer.WriteStartElement($OptDefsElement);
        foreach($optDef in $optDefs){        
            $script:writer.WriteStartElement($OptDefElement);
            ExportDhcpOptDefElement $optDef
            $script:writer.WriteEndElement(); #OptDef node        
        }
        
        $script:writer.WriteEndElement(); #OptDefs node
        $script:writer.Flush();
    }
}

function ExportDhcpServerv4Setting()
{
    #Dhcpv4 Server Settings
    $outObj = ExecuteCmdlet -CmdletName Get-DhcpServerSetting
    $script:writer.WriteElementString($ConflictDetAttemptsElement,      $outObj.ConflictDetectionAttempts.ToString());
    $script:writer.WriteElementString($NapEnabledElement,               $outObj.NapEnabled.ToString().ToLower()); #ToString converts into 'True' while xsd:boolean takes 'true'
    $script:writer.WriteElementString($NpsUnreachableActionElement,     $outObj.NpsUnreachableAction.ToString());
    if (NotNull $outObj.ActivatePolicies) {
        $script:writer.WriteElementString($ActivatePoliciesElement,     $outObj.ActivatePolicies.ToString().ToLower());
    }
}

#Exports the DHCPv4 Server
function ExportDhcpv4Server()
{
    if ($script:ProcessEntryCount -eq 1) { #Write Server level entries only when the Process function is called for the first time
        
        #Write IPv4 Start element
        $script:writer.WriteStartElement($IPv4Element, "");
        #Write v4ServerSettings
        ExportDhcpServerv4Setting
            
        #Dhcpv4 Server Classes
        ExportDhcpClasses $true
        
        #Dhcpv4 Server OptionDefinition
        ExportDhcpOptionDefinitions $true
        
        if (IsWindows8OrHigher($script:TargetMcVersion)) {
            #Dhcpv4 Server Policies (only available for Windows8 and above)
            ExportDhcpv4Policies
        }
        
        #Dhcpv4 Server OptionValue
        ExportDhcpOptionValues $true "" "" ""
        
        if (IsWindows2008R2OrHigher($script:TargetMcVersion)) {
            #Dhcpv4 Server Filters (only available for Windows2K8-R2 and above)
            ExportDhcpv4Filters
        }
    }
    
    #Dhcpv4 Server Scopes
    if ((NotNull $script:scopesToBeExported) -and ($script:scopesToBeExported.Count -gt 0)) {            
        ExportDhcpv4Scopes
    }
    
    if (($script:ExportSetting -eq $CompleteDhcpServer) -or ($script:ExportSetting -eq $SpecificV4AndV6Scopes)) {
        $script:writer.WriteEndElement(); #IPv4 End node
    }    
    $script:writer.Flush()                        
}

function Getv6LeaseHashTable($Lease, [HashTable]$mandatory, [HashTable]$optional)
{
    $mandatory[$Leasev6PropertiesMandatory[0]]     = $Lease.IPAddress
    $mandatory[$Leasev6PropertiesMandatory[1]]     = $Lease.ClientDuid
    $mandatory[$Leasev6PropertiesMandatory[2]]     = $Lease.IAID
    $mandatory[$Leasev6PropertiesMandatory[3]]     = $Lease.AddressType    
    
    if (NotNull $Lease.HostName)                    { $optional[$Leasev6PropertiesOptional[0]] = $Lease.HostName }
    if (NotNull $Lease.LeaseExpiryTime)        { $optional[$Leasev6PropertiesOptional[1]] = $Lease.LeaseExpiryTime.ToUniversalTime().ToString("u") }  #'u' format uses InvariantCulture and represents a UTC based time
    if (NotNull $Lease.Description)                 { $optional[$Leasev6PropertiesOptional[2]] = $Lease.Description }
}

function ExportDhcpv6LeaseElement()
{
    process {
    
        $script:writer.WriteStartElement($LeaseElement);
        
        [HashTable]$mandatory   = @{}
        [HashTable]$optional    = @{}
        
        Getv6LeaseHashTable $_ $mandatory $optional
        GenericXmlWriter $mandatory $Leasev6PropertiesMandatory $optional $Leasev6PropertiesOptional
        
        $script:writer.WriteEndElement(); #Lease End node
    }
}

function ExportDhcpv6Leases([string] $Prefix)
{
    $errNte             = $null
    $errTE              = $null    
                
    WriteTraceMessage ($_system_translations.Ver_Export_Scope_Lease -f $Prefix)
    Write-Verbose ($_system_translations.Ver_Export_Scope_Lease -f $Prefix)
    
    $script:writer.WriteStartElement($LeasesElement);
    
    $cmdlet = ExecuteCmdlet -CmdletName "Get-DhcpServerv6Lease -Prefix $Prefix" -Nte ([ref]$errNte) -TE ([ref]$errTE) -DontRun
    $pipelineCmdlet = "$cmdlet | ExportDhcpv6LeaseElement"
    WriteTraceMessage "Running Cmdlet: $pipelineCmdlet"
    try { Invoke-Expression  $pipelineCmdlet}    
    catch { PostNteObject $_ }                
    
    $script:writer.WriteEndElement(); #Leases End node        
    $script:writer.Flush();
}

function Getv6ScopeHashTable($prefixToExport, [HashTable]$mandatory, [HashTable]$optional)
{
    $mandatory[$Scopev6PropertiesMandatory[0]]         = $prefixToExport.Prefix
    $mandatory[$Scopev6PropertiesMandatory[1]]         = $prefixToExport.Name
    $mandatory[$Scopev6PropertiesMandatory[2]]         = $prefixToExport.Preference
    $mandatory[$Scopev6PropertiesMandatory[3]]         = $prefixToExport.State    
    
    if (NotNull $prefixToExport.PreferredLifeTime)      { $optional[$Scopev6PropertiesOptional[0]] = $prefixToExport.PreferredLifeTime.ToString() } #'u' format uses InvariantCulture and represents a UTC based time }
    if (NotNull $prefixToExport.ValidLifeTime)          { $optional[$Scopev6PropertiesOptional[1]] = $prefixToExport.ValidLifeTime.ToString() }
    if (NotNull $prefixToExport.T1)                     { $optional[$Scopev6PropertiesOptional[2]] = $prefixToExport.T1.ToString() } 
    if (NotNull $prefixToExport.T2)                     { $optional[$Scopev6PropertiesOptional[3]] = $prefixToExport.T2.ToString() } 
    if (NotNull $prefixToExport.Description)            { $optional[$Scopev6PropertiesOptional[4]] = $prefixToExport.Description }    
}
 
function ExportDhcpv6Scope($prefixToExport)
{
    [HashTable]$mandatory   = @{}
    [HashTable]$optional    = @{}
    $errNte                 = @()
    $errTE                  = $null
    $exIPRanges             = @()
            
    #Export v6Scope properties
    Getv6ScopeHashTable $prefixToExport $mandatory $optional
    GenericXmlWriter $mandatory $Scopev6PropertiesMandatory $optional $Scopev6PropertiesOptional    
            
    #Export Scope ExRange
    $temp = ExecuteCmdlet -CmdletName "Get-DhcpServerv6ExclusionRange -Prefix $($prefixToExport.Prefix)" -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject($errTE); PostNteObject($errNte)
    if (NotNull $temp) { $exIPRanges += $temp }
    if ($exIPRanges.Count -gt 0) { Write-Verbose ($_system_translations.Ver_Export_Scope_ExRanges -f $($prefixToExport.Prefix.ToString())) }
    ExportIPRanges $exIPRanges $ExclusionRangesElement
    
    #Export v6Scope OptionValues
    ExportDhcpOptionValues $false $prefixToExport.Prefix.ToString()
    
    #Export v6Scope Reservation
    ExportDhcpReservations $false $prefixToExport.Prefix.ToString()

    if (IsWindows8OrHigher($script:TargetMcVersion)) {
        #Dhcpv6 Stateless Store
        ExportDhcpv6StatelessStore $prefixToExport.Prefix.ToString()
    }
            
    #Export v6Scope Leases if Lease switch paramter is given
    if (${Leases}) {
        ExportDhcpv6Leases $prefixToExport.Prefix.ToString()    
    }
}

function ExportDhcpv6Scopes()
{    
    $errNte     = $null
    $errTE      = $null    

    WriteTraceMessage "Started exporting v6Scopes"
    
    if ($script:ProcessEntryCount -eq 1) { #Write Scopes Start Node only when the Process function is called for the first time
        $script:writer.WriteStartElement($ScopesElement); #Scopes Start Element        
    }
    
    foreach ($prefixToExport in $script:prefixesToBeExported) {
        
        WriteTraceMessage ($_system_translations.Ver_Export_Scope -f $prefixToExport.Prefix.ToString(),$script:DhcpServerName)
        Write-Verbose ($_system_translations.Ver_Export_Scope -f $prefixToExport.Prefix.ToString(), $script:DhcpServerName)
        
        $script:writer.WriteStartElement($ScopeElement);    #Scope Start node
        ExportDhcpv6Scope $prefixToExport
        $script:writer.WriteEndElement();                     #Scope End node        
        $script:writer.Flush();    
    }
    
    if (($script:ExportSetting -eq $CompleteDhcpServer) -or ($script:ExportSetting -eq $SpecificV4AndV6Scopes)) {        
        $script:writer.WriteEndElement(); #Scopes End node
    }
}

function ExportDhcpv6Server()
{
    if ($script:ProcessEntryCount -eq 1) { #Write Server level node only when the Process function is called for the first time
        
        $script:writer.WriteStartElement($IPv6Element, "");
                
        #Dhcpv6 Server Classes
        ExportDhcpClasses $false
        
        #Dhcpv6 Server OptionDefinition
        ExportDhcpOptionDefinitions $false
        
        #Dhcpv6 Server OptionValue
        ExportDhcpOptionValues $false "" "" ""
        
        if (IsWindows8OrHigher($script:TargetMcVersion)) {
            #Dhcpv6 Stateless Store
            ExportDhcpv6StatelessStore
        }
    }
    
    #Dhcpv6 Server Scopes
    if ((NotNull $script:prefixesToBeExported) -and ($script:prefixesToBeExported.Count -gt 0)) {            
        ExportDhcpv6Scopes
    }
    
    if (($script:ExportSetting -eq $CompleteDhcpServer) -or ($script:ExportSetting -eq $SpecificV4AndV6Scopes)) {
        $script:writer.WriteEndElement(); #IPv6 End node
    }        
    $script:writer.Flush()                        
}

#endregion

# .ExternalHelp DhcpServerMigration.psm1-help.xml
function Import-DhcpServer
{
<#
    Import-DhcpServer imports the input ScopeId/Prefix or the complete DhcpServer settings from the given input file.
    The xml file must be as per the DhcpServerSchema XSD (%systemdrive%\Windows\System32\WindowsPowerShell\v1.0\Modules\DhcpServer\DhcpServerSchema.xml)
    
    Input Parameters:
        File            : Mandatory Parameter from where settings to be imported are read
        ScopeId         : v4ScopeId. If this parameter is a non-IPv4Address value, TE will be returned
                            If the ScopeId doesnt exist in import xml file, NTE will be returned
        Prefix          : v6Prefix. If this parameter is a non-IPv6Address value, TE will be returned
                          If the Prefix doesnt exist in import xml file, NTE will be returned        
        ScopeOverwrite  : Switch parameter - if given and scope to be imported already exists on target machine, its overwritten else not overwritten
        Force           : Switch parameter - if given the default confirmation (ShouldContinue) is not asked
        Leases          : Switch parameter - if given, Leases for all the Scopes to be imported are also imported
        ComputerName    : Hostname or IPAddress of the target Dhcp Server on which settings need to be imported. If not given, localHost is used
        CimSession      : CimSession (of type Microsoft.Management.Infrastructure.CimSession) of the target Dhcp Server on which settings need to be imported.
#>
#region ParamDeclaration
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]    
    Param(        
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        ${File},

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        ${BackupPath},

        [Parameter()]
        [System.Net.IPAddress[]]
        ${ScopeId},
        
        [Parameter()]
        [System.Net.IPAddress[]]
        ${Prefix},

        [Parameter()]
        [switch]
        ${ScopeOverwrite},
        
        [Parameter()]
        [switch]
        ${Leases},

        [Parameter()]
        [switch]
        ${ServerConfigOnly},

        [Parameter()]
        [switch]
        ${Force},
       
        [Parameter()]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("Cn")]
        [string]
        ${ComputerName},
        
        [Parameter()]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimSession]
        ${CimSession}
    )
#endregion

    Begin {        
    }
        
    Process 
    {    
        [int]$script:ImportSetting          = $CompleteDhcpServer
        [string]$script:ImprotFile          = ""        
        [bool]$script:IsExport              = $false
        [string]$script:DhcpServerName      = ""
        [bool]$BackupTaken                  = $false
        $script:scopesToBeImported          = @()
        $script:prefixesToBeImported        = @()        
        $script:reader                      = $null
        $script:TargetMcVersion             = $null        
                
        try {    

            WriteTraceMessage "Import-DhcpServer::Process Entered"
            
            #If ComputerName is not given, get the local computerName 
            #else user given ComputerName in $script:DhcpServerName variable
            GetComputerName ${ComputerName}

            # If ${ServerConfigOnly} parameter is given and ScopeId and/or Prefix is given, return error
            if (${ServerConfigOnly} -and (!(IsNull ${ScopeId}) -or !(IsNull ${Prefix})))
            {
                ThrowTEString $_system_translations.ErrServerConfigGivenWithScopePrefix $EC_InvalidArgument $EC_InvalidArgument
            }

            # If both ${ServerConfigOnly} and ${Lease} parameters are given, return error
            if (${ServerConfigOnly} -and ${Leases})
            {
                ThrowTEString $_system_translations.ErrServerConfigGivenWithLeases $EC_InvalidArgument $EC_InvalidArgument
            }

            # If both ${ServerConfigOnly} and ${ScopeOverwrite} parameters are given, return error
            if (${ServerConfigOnly} -and ${ScopeOverwrite})
            {
                ThrowTEString $_system_translations.ErrServerConfigGivenWithScopeOverwrite $EC_InvalidArgument $EC_InvalidArgument
            }
            
            #Validate if input ScopeId/Prefix is in correct format
            #Returns the ImportSetting Mode [$CompleteDhcpServer=0, $SpecificV4AndV6Scopes=1, $SpecificV4Scopes=2, $SpecificV6Scopes=3]
            $script:ImportSetting = ValidateImportParams

            ValidateXml $script:ImportFile
            
            #Give the default confirmation (ShouldContinue) and WhatIf/Confirm (ShouldProcess) message
            if (!(HandleImportShouldProcessAndShouldContinue)) { WriteTraceMessage "ShouldProcess(SC) returned FALSE -- existing"; return }

            #Initializes the XmlSetting, XSD Validating setting and $script:reader
            InitializeXmlReader $script:ImportFile
            
            #Take the Dhcp Backup before import starts
            WriteTraceMessage "Taking DhcpServer Backup @ ${BackupPath} ..."
            ExecuteCmdlet -CmdletName Backup-DhcpServer -MandatoryParams @{"Path"=${BackupPath}} #TE if thrown will be thrown back
            WriteTraceMessage "DhcpServer Backup taken @ ${BackupPath}"

            Write-Verbose ($_system_translations.Ver_Import_Backup -f ${BackupPath}, $script:DhcpServerName)
            $BackupTaken = $true;
            
            #Imports the Dhcp Server
            ImportDhcpServerFromFile
                        
            WriteTraceMessage ($_system_translations.Ver_Import_End -f $script:DhcpServerName)
            Write-Verbose ($_system_translations.Ver_Import_End -f $script:DhcpServerName)
        }        
        
        catch { 
            #Give the Restore warning if backup has been taken
            if ($BackupTaken) {
                Write-Warning ($_system_translations.War_RestoreDhcpDatabase -f ${BackupPath})
            }
            throw            
        }
        
        finally  {
            WriteTraceMessage "Inside Finally"
            if ($null -ne $script:reader){ WriteTraceMessage "Closing the reader"; $script:reader.Close() }
        }
    }
    
    End {
    }
    
}

#region Import Util Functions

# Validates the input ScopeId and Prefix parameters
# Populates $script:scopesToBeImported and $script:prefixesToBeImported variables 
# Returns the ImportSetting level
function ValidateImportParams()
{
    $errNte    = @()
    $errTE    = $null
    
    #Get OS version of the target machine and check if its Win8 or higher
    $outObj = ExecuteCmdlet -CmdletName "Get-DhcpServerVersion"
    if (!(IsWindows8OrHigher($outObj))) {
        ThrowTEString ($_system_translations.ImportedVersionMismatch -f $outObj.MajorVersion,$outObj.MinorVersion) $EC_InvalidOperation $EC_InvalidOperation
    }
        
    $script:TargetMcVersion = $outObj
    
    #If input File doesnt exists - return TE
    $script:ImportFile = GetFullyQualifiedPath ${File}
    if (!(Test-Path -LiteralPath $script:ImportFile -PathType leaf))    {        
        ThrowTEString($_system_translations.ImportFileDoesNotExist -f $script:ImportFile) $EC_ResourceUnavailable $EC_ResourceUnavailable $script:ImportFile
    }
        
    if (${ScopeId} -ne $null) #User has given ScopeId(s) to be to imported
    {    
        foreach ($scopeId in ${ScopeId})
        {
            if ($scopeId.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
                ThrowTEString ($_system_translations.InvalidIPv4ScopeAddress -f $scopeId) $EC_InvalidArgument $EC_InvalidArgument $scopeId
            }            
            $script:scopesToBeImported += $scopeId.ToString()
        }
    }
    else #Import all the Scopes in the file
    {             
        $script:scopesToBeImported = @()
    }
        
    if (${Prefix} -ne $null) #User has given Prefix(es) to be to imported
    {    
        foreach ($prefix in ${Prefix})
        {
            if ($prefix.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetworkV6) {
                ThrowTEString ($_system_translations.InvalidIPv6ScopeAddress -f $prefix) $EC_InvalidArgument $EC_InvalidArgument $prefix
            }
            $script:prefixesToBeImported += $prefix.ToString()
        }
    }
    else #Import all the Prefixes
    {     
        $script:prefixesToBeImported = @()
    }                        
                    
    if (!$script:prefixesToBeImported.Count -and !$script:scopesToBeImported.Count) {
        return $CompleteDhcpServer
    }
    elseif ($script:prefixesToBeImported.Count -and $script:scopesToBeImported.Count) {
        return $SpecificV4AndV6Scopes
    }
    elseif ($script:prefixesToBeImported.Count -and !$script:scopesToBeImported.Count) {
        return $SpecificV6Scopes
    }
    elseif (!$script:prefixesToBeImported.Count -and $script:scopesToBeImported.Count) {
        return $SpecificV4Scopes
    }
}

function ValidateXml([string] $file)
{
    $xmlReader = $null
    try
    {           
        $sc                                         = New-Object System.Xml.Schema.XmlSchemaSet     # Create the XmlSchemaSet class.        
        $sc.Add($DhcpSchemaName, $DhcpSchemaFile)   > $null                                         # Add the schema to the collection.    
        $xmlSettings                                = new-object System.Xml.XmlReaderSettings
        $xmlSettings.IgnoreComments                 = $true;
        $xmlSettings.IgnoreProcessingInstructions   = $true;
        $xmlSettings.IgnoreWhitespace               = $true;
        $xmlSettings.ValidationType                 = [System.Xml.ValidationType]::Schema;
        $xmlSettings.Schemas                        = $sc;
        $xmlSettings.CheckCharacters                = $false;
        
        $xmlReader = [Xml.XmlReader]::Create($file, $xmlSettings)

        $xmlReader.MoveToContent()     > $null                                # Current node is now root node (DHCPServer)
        $xmlReader.Read()                    > $null                                # Move to MajorVersion element
        $xmlReader.ReadToNextSibling("MajorVersion") > $null          # Since there is no MajorVersion sibling at this level, it will move to end element of parent node (DHCPServer) of current node
        while ($xmlReader.Read() > $null ) { }                                # This makes sure if there are more than 1 root element, it gives error
    }
    catch
    {
        WriteTraceMessage "ValidateXml failed $_"
        ThrowTEString ($_system_translations.ErrXmlValidationFailed-f $file, $DhcpSchemaFile, $_.ToString())
    }
    finally
    {
        if ($null -ne $xmlReader) { $xmlReader.Close() }
    }
}

# Initialzes XmlSetting and XmlSchemaSet (to $DhcpSchemaFile schema file)
# Initializes the XmlReader ($script:reader)
function InitializeXmlReader([string] $file)
{
    try
    {           
        $xmlSettings                                = new-object System.Xml.XmlReaderSettings
        $xmlSettings.IgnoreComments                 = $true;
        $xmlSettings.IgnoreProcessingInstructions   = $true;
        $xmlSettings.IgnoreWhitespace               = $true;
        $xmlSettings.ValidationType                 = [System.Xml.ValidationType]::None;
        $xmlSettings.CheckCharacters                = $false;
        
        $script:reader = [Xml.XmlReader]::Create($file, $xmlSettings)
    }
    catch
    {
        WriteTraceMessage "InitializeXmlReader failed $_"
        throw
    }
}

# Reads the version info from Xml file
# Validate Xml version info is equal or greater than target machine version
function ReadAndVerifyVersionInfo()
{
    #reader is at present on the MajorVersion element
    $majorVer = $script:reader.ReadElementContentAsInt()
    $minorVer = $script:reader.ReadElementContentAsInt()    
    WriteTraceMessage "MajorVersion: $majorVer MinorVersion: $minorVer"
    
    #Allow Windows Server 2012 R2 and Windows Server 2012 compatibility
    if (($script:TargetMcVersion.MajorVersion -eq $Win8MajorVersion) -and ($script:TargetMcVersion.MajorVersion -eq $majorVer) -and ($script:TargetMcVersion.MinorVersion -eq $Win8MinorVersion) -and ($minorVer -eq $Win9MinorVersion))
    {
        return
    }
    
    if (($script:TargetMcVersion.MajorVersion -lt $majorVer) -or (($script:TargetMcVersion.MajorVersion -eq $majorVer) -and ($script:TargetMcVersion.MinorVersion -lt $minorVer)))
    {
        ThrowTEString ($_system_translations.ImportedFileVersionMismatch -f $script:TargetMcVersion.MajorVersion,$script:TargetMcVersion.MinorVersion,$majorVer,$minorVer) $EC_InvalidOperation $EC_InvalidOperation
    }    
    
    #reader is now positioned at element after Minor version
}

function ReadAndApplyServerSetting
{
    [hashtable] $mandatory = @{}
    $errNte        = @(); $errTE        = $null


    #reader is at present on the ConflictDetectionAttempts element
    $conflictDetAttempts    = $script:reader.ReadElementContentAsInt();     $mandatory.Add($ConflictDetAttemptsElement, $conflictDetAttempts)
    $napEnabled             = $script:reader.ReadElementContentAsBoolean(); $mandatory.Add($NapEnabledElement, $napEnabled)    
    $npsUnreachableAction   = $script:reader.ReadElementContentAsString();  $mandatory.Add($NpsUnreachableActionElement, $npsUnreachableAction)

    if ($script:reader.IsStartElement($ActivatePoliciesElement)) {
        $activatePolicies   = $script:reader.ReadElementContentAsBoolean()
        $mandatory.Add($ActivatePoliciesElement, $activatePolicies)
    }
    
    WriteTraceMessage "$mandatory"
    
    $temp = ExecuteCmdlet -CmdletName Set-DhcpServerSetting -MandatoryParams $mandatory -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    
    #reader is now positioned at the element next to last server setting element (which is ActivatePolicies or NpsUnreachableAction)
}

#While entring node is startElement 'Class' / While leaving Node is EndElement 'Class'
function ReadAndApplyClass([bool]$IsV4, [Array]$allClasses)
{
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}
    $script:reader.Read()  > $null #current node is 'Class' move it to next node
    GenericXmlReader $mandatory $ClassPropertiesMandatory $optional $ClassPropertiesOptional
    #$mandatory | ft; $optional | ft
    
    #Check if the Class in XML is present on target machine
    foreach ($class in $allClasses) {
        if ($class.Data -ceq $mandatory["Data"]) {
            #WriteTraceMessage "Class $($mandatory["Name"]) is found conflicting - wont be imported"
            Write-Verbose ($_system_translations.Ver_Import_ClassAlreadyExist -f $mandatory["Name"],$mandatory["Type"],$script:DhcpServerName)
            return
        }        
    }
    if ($IsV4) { $cmdlet = "Add-DhcpServerv4Class" } else { $cmdlet = "Add-DhcpServerv6Class" }
    WriteTraceMessage "Class $($mandatory["Name"]) is NOT found conflicting - WILL BE IMPORTED"
    $temp = ExecuteCmdlet -CmdletName $cmdlet -MandatoryParams $mandatory -OptionalParams $optional -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
}

#While entring node is startElement 'Classes' / While leaving Node is EndElement 'Classes'
function ReadAndApplyClasses([bool] $IsV4)
{    
    WriteTraceMessage "Started reading Classes node"
    Write-Verbose $_system_translations.Ver_Import_Classes
    
    [Array]$allClasses = @()
    $errNte    = @(); $errTE = $null
    #Get all the classes
    if ($IsV4) { $cmdlet = "Get-DhcpServerv4Class" } else { $cmdlet = "Get-DhcpServerv6Class" }
    
    $temp = ExecuteCmdlet -CmdletName $cmdlet -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    if (NotNull $temp) { $allClasses += $temp }
    
    while ($script:reader.Read()) {
        if ($script:reader.IsStartElement($ClassElement)) {
            ReadAndApplyClass $IsV4 $allClasses
        }
        else { break }
    }    
}

#While entring node is startElement 'OptionDefinition' / While leaving Node is EndElement 'OptionDefinition'
function ReadAndApplyOptDefintion([bool]$IsV4, [Array]$allOptDefs)
{
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}
    $script:reader.Read()  > $null #current node is 'OptionDefinition' move it to next node
    GenericXmlReader $mandatory $OptDefPropertiesMandatory $optional $OptDefPropertiesOptional
    #$mandatory | ft; $optional | ft
    
    #Check if the OptDef in XML is present on target machine - Dont Import if its already present
    foreach ($optDef in $allOptDefs) {
        if (($optDef.OptionId.ToString() -eq $mandatory["OptionId"]) -and ($optDef.VendorClass -eq $optional["VendorClass"])) {
            #WriteTraceMessage "OptDef $($mandatory["Name"]) with Id=$($mandatory["OptionId"]) is found conflicting - wont be imported"
            Write-Verbose ($_system_translations.Ver_Import_OptDefAlreadyExist -f $mandatory["Name"],$script:DhcpServerName)
            return
        }        
    }

    #Update the bool field from true/1 or false/0 to $true or $false
    if (("true" -eq $mandatory["MultiValued"]) -or ("1" -eq $mandatory["MultiValued"])) { $switchParam = @{"MultiValued"=$true} } else { $switchParam = @{"MultiValued"=$false} }
    $mandatory.Remove("MultiValued")
    
    if ($IsV4) { $cmdlet = "Add-DhcpServerv4OptionDefinition" } else { $cmdlet = "Add-DhcpServerv6OptionDefinition" }
    WriteTraceMessage "OptDef $($mandatory["Name"]) with Id=$($mandatory["OptionId"]) is NOT found conflicting - WILL BE IMPORTED"    
    
    $temp = ExecuteCmdlet -CmdletName $cmdlet -MandatoryParams $mandatory -OptionalParams $optional -SwitchParams $switchParam -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
}

#While entring node is startElement 'OptionDefinitions' / While leaving Node is EndElement 'OptionDefinitions'
function ReadAndApplyOptionDefintions([bool] $IsV4)
{    
    WriteTraceMessage "Started reading OptionDefinitions node"
    Write-Verbose $_system_translations.Ver_Import_OptDef
    
    [Array]$allOptDefs = GetAllOptionDefinitions $IsV4
        
    while ($script:reader.Read()) {
        if ($script:reader.IsStartElement($OptDefElement)) {
            ReadAndApplyOptDefintion $IsV4 $allOptDefs
        }
        else { break }
    }    
}

#While entring node is startElement 'OptionValue' / While leaving Node is EndElement 'OptionValue'
function ReadAndApplyOptValue([bool]$IsV4, [HashTable]$levelToSetParams)
{
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}
    $script:reader.Read()  > $null #current node is 'OptionValue' move it to next node
    GenericXmlReader $mandatory $OptValuePropertiesMandatory $optional $OptValuePropertiesOptional

    if (!$optional.Contains("Value")) {

        $optId = $mandatory["OptionId"] ; $warnMesg = ""
        if ($IsV4) { $scopeTag = "ScopeId" } else { $scopeTag = "Prefix" }
       
        if (IsNull $levelToSetParams) {
            $warnMesg = ($_system_translations.War_ImportOptValueServerLevelWithoutValue -f $optId,$script:DhcpServerName)
        }
        elseif ($levelToSetParams.Contains("PolicyName") -and $levelToSetParams.Contains($scopeTag)) {
            $warnMesg = ($_system_translations.War_ImportOptValueScopePolicyLevelWithoutValue -f $optId,$levelToSetParams["PolicyName"],$levelToSetParams[$scopeTag],$script:DhcpServerName)
        }
        elseif ($levelToSetParams.Contains("PolicyName")) {
            $warnMesg = ($_system_translations.War_ImportOptValueServerPolicyLevelWithoutValue -f $optId,$levelToSetParams["PolicyName"],$script:DhcpServerName)
        }
        elseif ($levelToSetParams.Contains("$scopeTag")) {
            $warnMesg = ($_system_translations.War_ImportOptValueScopeLevelWithoutValue -f $optId,$levelToSetParams[$scopeTag],$script:DhcpServerName)
        }
        elseif ($levelToSetParams.Contains("ReservedIP")) {
            $warnMesg = ($_system_translations.War_ImportOptValueReservationLevelWithoutValue -f $optId,$levelToSetParams["ReservedIP"],$script:DhcpServerName)
        }

        Write-Warning $warnMesg
        return
    }
    
    if (NotNull $levelToSetParams) { $optional += $levelToSetParams }
    if ($IsV4) { $cmdlet = "Set-DhcpServerv4OptionValue" } else { $cmdlet = "Set-DhcpServerv6OptionValue" }
    
    $temp = ExecuteCmdlet -CmdletName $cmdlet -MandatoryParams $mandatory -OptionalParams $optional -SwitchParams @{"Force"=$true} -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
}


# All the OptValues on the target machine will be deleted if DeleteExisting is True
# If While entring the function, the StartElement is 'OptionValues'' then all the OptionValue elements under it would be imported AND while leaving the function, the node is EndElement 'OptionValues'
# Else Xml is not processed
function ReadAndApplyOptionValues([bool] $IsV4, [string] $ScopeId="", [string]$ReservedIP="", [string]$PolicyName="", [bool]$DeleteExisting=$true)
{    
    [string]$verboseDelMessage      = ""; 
    [string]$verboseImportMessage   = ""
    [HashTable]$optionalParam       = $null
    
    if ($IsV4) { $scope = "ScopeId" } else { $scope = "Prefix" }

    if ((IsNullOrEmptyString $ScopeId) -and (IsNullOrEmptyString $ReservedIP) -and (IsNullOrEmptyString $PolicyName)) { 
        $verboseDelMessage          = $_system_translations.Ver_Import_Server_OptVal_Del
        $verboseImportMessage       = $_system_translations.Ver_Import_Server_OptVal
        $optionalParam              = $null
    }    
    if ((IsNullOrEmptyString $ScopeId) -and (IsNullOrEmptyString $ReservedIP) -and (!(IsNullOrEmptyString $PolicyName))) {         
        $verboseImportMessage       = ($_system_translations.Ver_Import_Server_Pol_OptVal -f $PolicyName) 
        $optionalParam              = @{ "PolicyName"=$PolicyName }
    }    
    elseif (!(IsNullOrEmptyString $ScopeId) -and (IsNullOrEmptyString $PolicyName)) {
        $verboseDelMessage          = ($_system_translations.Ver_Import_Scope_OptVal_Del -f $ScopeId)
        $verboseImportMessage       = ($_system_translations.Ver_Import_Scope_OptVal -f $ScopeId)
        $optionalParam              = @{$scope = $ScopeId } 
    }
    elseif (!(IsNullOrEmptyString $ReservedIP)) { 
        $verboseDelMessage          = ($_system_translations.Ver_Import_Rsvation_OptVal_Del -f $ReservedIP); 
        $verboseImportMessage       = ($_system_translations.Ver_Import_Rsvation_OptVal -f $ReservedIP)
        $optionalParam              = @{"ReservedIP" = $ReservedIP }
    }
    elseif (!(IsNullOrEmptyString $ScopeId) -and (!(IsNullOrEmptyString $PolicyName))) {         
        $verboseImportMessage       = ($_system_translations.Ver_Import_Scope__PolOptVal -f $PolicyName,$ScopeId)
        $optionalParam              = @{$scope = $ScopeId; "PolicyName"=$PolicyName } 
    }
    
    #WriteTraceMessage $verboseImportMessage
    
    if ($DeleteExisting) {
    
        if (IsNullOrEmptyString $PolicyName) {    
            Write-Verbose $verboseDelMessage            
            #Get & Delete all the existing OptionValues for v4Server/Scope/Reservation on targetServer
            if ($IsV4)    { $cmdletGet = "Get-DhcpServerv4OptionValue -All -Brief"; $cmdletDel = "Remove-DhcpServerv4OptionValue" }
            else          { $cmdletGet = "Get-DhcpServerv6OptionValue -All -Brief"; $cmdletDel = "Remove-DhcpServerv6OptionValue" }
            $GetOptValueCmdlet         = ExecuteCmdlet -CmdletName $cmdletGet -OptionalParams $optionalParam -DontRun
            $RemoveOptValueCmdlet      = ExecuteCmdlet -CmdletName $cmdletDel -OptionalParams $optionalParam -DontRun

            $pipelineCmdlet = "$GetOptValueCmdlet | $RemoveOptValueCmdlet"
            WriteTraceMessage "Running Cmdlet: $pipelineCmdlet"
            try { Invoke-Expression  $pipelineCmdlet} 
            catch { PostNteObject $_ } #All NTEs will be given back to user - while TE will be posted as NTE
        }
    }

    if ($script:reader.IsStartElement($OptValuesElement)) {             #If OptionValues start element is present, import all the OptionValue elements under it
        Write-Verbose $verboseImportMessage                
        while ($script:reader.Read()) {                                             #Reader is at present on OptionValues start element - move it to OptoinValue start element
            if ($script:reader.IsStartElement($OptValueElement)) {
                ReadAndApplyOptValue $IsV4 $optionalParam
            }
            else { break }
        }

        $script:reader.Read() > $null                                               #Move to element after OptionValues End element  
    }
}
 
#While entring node is startElement 'Reservation' / While leaving Node is EndElement 'Reservation'
function ReadAndApplyReservation([bool] $IsV4, [string]$ScopeId)
{
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}
    $script:reader.Read()  > $null             #current node is 'Reservation' move it to next node
    
    if ($IsV4) { $cmdlet = "Add-DhcpServerv4Reservation -ScopeId $ScopeId" } else { $cmdlet = "Add-DhcpServerv6Reservation -Prefix $ScopeId" }
    
    GenericXmlReader $mandatory $ReservationPropertiesMandatory $optional $ReservationPropertiesOptional    
    #$mandatory | ft; $optional | ft    
            
    $temp = ExecuteCmdlet -CmdletName $cmdlet -MandatoryParams $mandatory -OptionalParams $optional -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    
    #If Add reservation fails, no need to process further on this reservation
    if ((NotNull $errTE) -or ($errNte.Count -gt 0)) { 
        WriteTraceMessage "ReadAndApplyReservation: Add Reservation for IP $($mandatory["IPAddress"]) failed -- exiting the function" $true
        return
    }
        
    #If there is a OptionValues Node, import all v4 OptValues for this reservation
    ReadAndApplyOptionValues $IsV4 "" $mandatory["IPAddress"] "" $false
}


#While entring node is startElement 'Reservations' / While leaving Node is EndElement 'Reservations'

# All the Reservations on the target machine will be deleted if DeleteExisting is True
# If While entring the function, the StartElement is 'Reservations' then all the Reservation elements under it would be imported AND while leaving the function, the node is EndElement 'Reservations'
# Else Xml is not processed
function ReadAndApplyReservations([bool]$IsV4, [string] $ScopeId, [bool]$DeleteExisting=$true)
{        
    [string]$verboseDelMessage      = ""
    [string]$verboseImportMessage   = ""
    [HashTable]$optionalParam       = $null
    $errNte                         = @()
    $errTE                          = $null
        
    if ($DeleteExisting) {
    
        #WriteTraceMessage ($_system_translations.Ver_Import_Scope_Rsvation_Del -f $scopeId)    
        Write-Verbose ($_system_translations.Ver_Import_Scope_Rsvation_Del -f $scopeId)    
        
        if ($IsV4) { $cmdlet = "Remove-DhcpServerv4Reservation -Scope $ScopeId" }
        else { $cmdlet = "Remove-DhcpServerv6Reservation -Prefix $ScopeId" }
        
        #Delete all the existing Reservations for the Scope
        ExecuteCmdlet -CmdletName $cmdlet -Nte ([ref]$errNte) -TE ([ref]$errTE)
        PostNteObject($errTE); PostNteObject($errNte)
    }

    if ($script:reader.IsStartElement($ReservationsElement)) {                  #If Reservations start element is present, import all the Reservation elements under it  
        Write-Verbose ($_system_translations.Ver_Import_Scope_Rsvation -f $scopeId)
        while ($script:reader.Read()) {                                                     #Reader is at present on Reservations start element - move it to Reservation start element
            if ($script:reader.IsStartElement($ReservationElement)) {
                ReadAndApplyReservation $IsV4 $ScopeId
            }
            else { break }
        }

        $script:reader.Read() > $null                                                       #Move to element after Reservations End element
    }
}

#While entring node is startElement 'Policy' / While leaving Node is EndElement 'Policy'
function ReadAndApplyPolicy([HashTable]$levelToSetParams, $skipProcessingOrder)
{
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}
    $script:reader.Read()  > $null #current node is 'Policy' move it to next node
    $DnsSuffix     = $null;
    $RetVal        = $true;
    GenericXmlReader $mandatory $PolicyPropertiesMandatory $optional $PolicyPropertiesOptional
    #$mandatory | ft; $optional | ft    
    
    $DnsSuffix=$optional[$PolicyPropertiesOptional[10]];
    $optional.Remove($PolicyPropertiesOptional[10]);
    
    $scopeId = ""
    if (NotNull $levelToSetParams) { $optional += $levelToSetParams; $scopeId = $levelToSetParams["ScopeId"] }
        
    #Update the Enabled bool field from true/1 or false/0 to $true or $false
    if (("true" -eq $mandatory["Enabled"]) -or ("1" -eq $mandatory["Enabled"])) { $mandatory["Enabled"]=$true } else { $mandatory["Enabled"] = $false }

    if ($true -eq $skipProcessingOrder)
    {
        $mandatory.Remove("ProcessingOrder");
    }
    
    $temp = ExecuteCmdlet -CmdletName Add-DhcpServerv4Policy -MandatoryParams $mandatory -OptionalParams $optional -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    
    #If Add Policy fails, no need to process further on this Policy
    if ((NotNull $errTE) -or ($errNte.Count -gt 0)) { 
        WriteTraceMessage "ReadAndApplyPolicy: Add Policy for $($mandatory["Name"]) failed -- existing the function" $true
        $RetVal = $false;
    }
    
    if (NotNull $DnsSuffix) {
        if (IsNullOrEmptyString $ScopeId) { 
            $optionalScopeParam              = $null
        }    
        elseif (!(IsNullOrEmptyString $ScopeId)) { 
            $optionalScopeParam              = @{"ScopeId" = $ScopeId } 
        }  
        
        $temp = ExecuteCmdlet -CmdletName "Set-DhcpServerV4DnsSetting -PolicyName `"$($mandatory["Name"])`" -DnsSuffix `"$($DnsSuffix)`" " -OptionalParams $optionalScopeParam -Nte ([ref]$errNte) -TE ([ref]$errTE)    
   
        PostNteObject $errTE; PostNteObject $errNte
        
        #If Add Policy fails, no need to process further on this Policy
        if ((NotNull $errTE) -or ($errNte.Count -gt 0)) { 
            WriteTraceMessage "ReadAndApplyPolicy: Setting DNSSuffix for $($mandatory["Name"]) failed" $true
        }
    }
    
    if ((NotNull $levelToSetParams) -and ($script:reader.IsStartElement($IPRangesElement))) {        
        while ($script:reader.Read()) {                             #Reader is at present on IPRanges start element - move it to IPRange start element
            if ($script:reader.IsStartElement($IPRangeElement))
            {
                $script:reader.Read()  > $null                        #Move element to StartRange element
                $startRange = $script:reader.ReadElementString($StartIPRangeElement);
                $endRange    = $script:reader.ReadElementString($EndIPRangeElement);
                $temp = ExecuteCmdlet -CmdletName "Add-DhcpServerv4PolicyIPRange -Name `"$($mandatory["Name"])`" -ScopeId $scopeId -StartRange $startRange -EndRange $endRange" -Nte ([ref]$errNte) -TE ([ref]$errTE)
                PostNteObject $errTE; PostNteObject $errNte
            }
            else { break }
        }        
        $script:reader.Read()  > $null     #Move element to IPRanges end element
    }    
    
    #If current node is at OptionValues, import all the OptValues for this Policy    
    ReadAndApplyOptionValues $true $scopeId "" $mandatory["Name"] $false    
    return $RetVal;
}

# All the Policies on the target machine will be deleted if DeleteExisting is True
# If While entring the function, the StartElement is 'Policies' then all the Policy elements under it would be imported AND while leaving the function, the node is EndElement 'Policies'
# Else Xml is not processed
function ReadAndApplyPolicies([string] $ScopeId="", [bool]$DeleteExisting=$true)
{    
    [string]$verboseDelMessage      = ""
    [string]$verboseImportMessage   = ""
    [HashTable]$optionalParam       = $null
    [string[]]$polNames             = @()
    $errNte                         = @()
    $errTE                          = $null
    $policies                       = @()    
    $skipProcessingOrder            = $false;
    $addPolicySuccess               = $false;

    if (IsNullOrEmptyString $ScopeId) { 
        $verboseDelMessage          = $_system_translations.Ver_Import_Server_Policy_Del; 
        $verboseImportMessage       = $_system_translations.Ver_Import_Server_Policy; 
        $optionalParam              = $null
    }    
    elseif (!(IsNullOrEmptyString $ScopeId)) { 
        $verboseDelMessage          = ($_system_translations.Ver_Import_Scope_Policy_Del -f $ScopeId); 
        $verboseImportMessage       = ($_system_translations.Ver_Import_Scope_Policy -f $ScopeId); 
        $optionalParam              = @{"ScopeId" = $ScopeId } 
    }    
    
    #WriteTraceMessage $verboseImportMessage
    
    if ($DeleteExisting) {

        Write-Verbose $verboseDelMessage            
        #Get & Delete all the existing Policies for v4Server/Scope on targetServer    
        $temp = ExecuteCmdlet -CmdletName Get-DhcpServerv4Policy -OptionalParams $optionalParam -Nte ([ref]$errNte) -TE ([ref]$errTE)
        if (NotNull $temp) { $policies += $temp }
        PostNteObject $errTE; PostNteObject $errNte
        
        foreach ($policy in $policies) { $polNames += $policy.Name }
        if ($polNames.Count -gt 0) {
            ExecuteCmdlet -CmdletName Remove-DhcpServerv4Policy -MandatoryParams @{"Name"=$polNames} -OptionalParams $optionalParam -Nte ([ref]$errNte) -TE ([ref]$errTE)
            PostNteObject $errTE; PostNteObject $errNte
        }        
    }

    if ($script:reader.IsStartElement($PoliciesElement)) {              #If Policies start element is present, import all the Policy elements under it
        Write-Verbose $verboseImportMessage                
        while ($script:reader.Read()) {                                         #Reader is at present on Policies start element - move it to Policy start element
            if ($script:reader.IsStartElement($PolicyElement)) {
                $addPolicySuccess = ReadAndApplyPolicy $optionalParam $skipProcessingOrder
                if ($false -eq $addPolicySuccess)
                {
                    $skipProcessingOrder = $true;
                }
            }
            else { break }
        }    

        $script:reader.Read()  > $null                                          #Move element to after Policies end element
    }
}

#While entring node is startElement 'Lease' / While leaving Node is EndElement 'Lease'
function ReadAndApplyv4Lease([string]$ScopeId)
{
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}
    $script:reader.Read()  > $null                 #current node is 'Lease' move it to next node
    GenericXmlReader $mandatory $LeasePropertiesMandatory $optional $LeasePropertiesOptional
    #$mandatory | ft; $optional | ft    

    if ($mandatory["AddressState"] -eq "InactiveReservation") {
        WriteTraceMessage ("ReadAndApplyv4Lease: Lease {0} is an InactiveReservation - skipping .." -f $mandatory["IPAddress"])
        return
    }
            
    #Update the NapCapable bool field from true/1 or false/0 to $true or $false
    if (("true" -eq $mandatory["NapCapable"]) -or ("1" -eq $mandatory["NapCapable"])) { $mandatory["NapCapable"]=$true } else { $mandatory["NapCapable"] = $false }       

    #For downlevel systems A is not supported so change it to AandPTR
    if (("A" -eq $optional["DnsRR"]) -and (($script:TargetMcVersion.MajorVersion -lt $Win8MajorVersion) -or (($script:TargetMcVersion.MajorVersion -eq $Win8MajorVersion) -and ($script:TargetMcVersion.MinorVersion -lt $Win9MinorVersion))))
    {
        $optional["DnsRR"] = "AandPTR";
    }
    
    $temp = ExecuteCmdlet -CmdletName Add-DhcpServerv4Lease -MandatoryParams $mandatory -OptionalParams $optional -Nte ([ref]$errNte) -TE ([ref]$errTE)

    #If leases addition fails with 20014 (Client Already Exist) error, ignore the error
    if ((NotNull $errTE) -and ($errTE.Exception -is [Microsoft.Management.Infrastructure.CimException]) -and ($errTE.Exception.ErrorData.error_Code -eq 20014)) { return }
    if ((NotNull $errNte) -and ($errNte.Count -gt 0) -and ($errNte[0].Exception.ErrorData.error_Code -eq 20014)) { return }
    
    PostNteObject $errTE; PostNteObject $errNte    
}

#While entring node is startElement 'Leases' / While leaving Node is EndElement 'Leases'
function ReadAndApplyv4Leases([string] $ScopeId="")
{            
    WriteTraceMessage ($_system_translations.Ver_Import_Scope_Leases -f $ScopeId)
    Write-Verbose ($_system_translations.Ver_Import_Scope_Leases -f $ScopeId)    
        
    while ($script:reader.Read()) { #Reader is at present on Leases start element - move it to Lease start element
        
        if ($script:reader.IsStartElement($LeaseElement)) {
            ReadAndApplyv4Lease $ScopeId
        }
        else { break }
    }    
}


# All the ExclusionRanges on the target machine will be deleted if DeleteExisting is True
# If While entring the function, the StartElement is 'ExclusionRanges' then all the ExclusionRange elements under it would be imported AND while leaving the function, the node is EndElement 'ExclusionRanges'
# Else Xml is not processed
function ReadAndApplyExclusionRanges([bool]$IsV4, [string]$ScopeId, [bool]$DeleteExisting=$true)
{
    $errNte     = @(); $errTE = $null
    $localEV    = @()
    
    if ($DeleteExisting) {
        
        #Delete All the existing Exclusion range for the scope        
        Write-Verbose ($_system_translations.Ver_Import_Scope_ExRange_Del -f $ScopeId)

        #Get & Delete all the existing ExclusionRanges for this scope
        if ($IsV4) {
            $GetExRangeCmdlet       = ExecuteCmdlet -CmdletName "Get-DhcpServerv4ExclusionRange -ScopeId $ScopeId" -Nte ([ref]$errNte) -DontRun
            $RemoveExRangeCmdlet    = ExecuteCmdlet -CmdletName "Remove-DhcpServerv4ExclusionRange -ScopeId $ScopeId" -Nte ([ref]$errNte) -DontRun
        }
        else {
            $GetExRangeCmdlet       = ExecuteCmdlet -CmdletName "Get-DhcpServerv6ExclusionRange -Prefix $ScopeId" -Nte ([ref]$errNte) -DontRun
            $RemoveExRangeCmdlet    = ExecuteCmdlet -CmdletName "Remove-DhcpServerv6ExclusionRange -Prefix $ScopeId" -Nte ([ref]$errNte) -DontRun
        }
        
        $pipelineCmdlet = "$GetExRangeCmdlet | $RemoveExRangeCmdlet"
        WriteTraceMessage "Running Cmdlet: $pipelineCmdlet"
        try { Invoke-Expression  $pipelineCmdlet }
        catch { PostNteObject $_ } #catch the TE & post it as NTE
        PostNteObject($localEV)
    }

    if ($script:reader.IsStartElement($ExclusionRangesElement)) {  #If ExclusionRanges start element is present, import all the ExclusionRange elements under it
    
        Write-Verbose ($_system_translations.Ver_Import_Scope_ExRange -f $ScopeId)        
        while ($script:reader.Read()) {                             #Reader is at present on ExclusionRanges start element - move it to IPRange start element
            if ($script:reader.IsStartElement($IPRangeElement))
            {
                $script:reader.Read()    > $null                      #Move to StartRange element
                $startRange = $script:reader.ReadElementString($StartIPRangeElement);
                $endRange    = $script:reader.ReadElementString($EndIPRangeElement);
                if ($IsV4) {
                    $temp = ExecuteCmdlet -CmdletName "Add-DhcpServerv4ExclusionRange -ScopeId $ScopeId -StartRange $startRange -EndRange $endRange" -Nte ([ref]$errNte) -TE ([ref]$errTE)
                }
                else {
                    $temp = ExecuteCmdlet -CmdletName "Add-DhcpServerv6ExclusionRange -Prefix $ScopeId -StartRange $startRange -EndRange $endRange" -Nte ([ref]$errNte) -TE ([ref]$errTE)
                }
                PostNteObject $errTE; PostNteObject $errNte
            }
            else { break }
        }

        $script:reader.Read()            > $null                    #Move to node next to ExclusionRanges end element
    }
}

#Checks if $CurrentScopeId and $CurrentSubnetMask is exact match of any element in $Existingv4Scopes
#If yes, return $true else $false
function IsConflictingv4Scope([string]$CurrentScopeId, [string] $CurrentSubnetMask)
{
    foreach ($scope in $script:Existingv4Scopes) {
        if (($CurrentScopeId -eq $scope.ScopeId.ToString()) -and ($CurrentSubnetMask -eq $scope.SubnetMask.ToString())) {
            return $true
        }
    }
    return $false
}

#Checks if $CurrentScopeId is exact match of any element in $Existingv6Scopes
#If yes, return $true else $false
function IsConflictingv6Scope([string]$CurrentScopeId)
{
    foreach ($scope in $script:Existingv6Scopes) {
        if ($CurrentScopeId -eq $scope.Prefix.ToString()) {
            return $true
        }
    }
    return $false
}

#While entring reader is at startElement 'Scope' [<Scope>]and while leaving reader is at EndElement 'Scope' [</Scope>]
function ReadAndApplyv4Scope()
{
    WriteTraceMessage "Entered ReadAndApplyv4Scope"
    
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}

    $script:reader.Read()  > $null #current node is 'Scope' move it to next node
    GenericXmlReader $mandatory $Scopev4PropertiesMandatory $optional $Scopev4PropertiesOptional
    #Reader is now at 'Superscope' node
    
    $currentScopeId = $mandatory["ScopeId"]
    $script:ImportFilev4Scopes += $currentScopeId
        
    WriteTraceMessage "Current ImportFile v4Scope is $currentScopeId"
    
    #If !CompleteServerImport AND ImportFileScope is not part of inputScope List, skip to end Scope </Scope> element & return
    #If ImportFileScope exists on destination
        #if ScopeOverwrite and lease is given, delete the scope and then Add it
        #if ScopeOverwrite is given, update the scope        
        #If ScopeOverwrite is not given, skip to next <Scope> element
        #Delete and add all the sub-elements of the scope
    #If ImportFileScope does not exist on destination
        #Add the scope and all it sub-element
    
    if ($script:ImportSetting -ne $CompleteDhcpServer) {
        #One of more v4scopes given to be imported
        #Check if ImportFile current v4scope is part of input v4scope list
        #If not, skip to end scope element for current scope
        if ($script:scopesToBeImported -notcontains $currentScopeId) {
            $script:reader.ReadToNextSibling($ScopeElement) > $null     #Since there is no <Scope> sibling at this level, it will move to end element of parent node of current node
            WriteTraceMessage ("Current ImportFile scope $currentScopeId not part of input scope List. Skipping to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
            return;
        }
    }

    $toAdd = $false; $toUpdate = $false; $toDeleteScopeSubElement = $false;
    if (IsConflictingv4Scope $currentScopeId $mandatory["SubnetMask"])    
    {
        #Conflicting v4 Scope is present
        if (${ScopeOverwrite} -and ${Leases}) { #Both ScopeOverwrite and Leases are given - delete & add the scope
            Write-Verbose ($_system_translations.Ver_Import_Scope_Exists_3 -f $currentScopeId,$script:DhcpServerName)
            #Remove the v4 scope on the target machine
            ExecuteCmdlet -CmdletName "Remove-DhcpServerv4Scope -ScopeId $currentScopeId -Force" -Nte ([ref]$errNte) -TE ([ref]$errTE)
            PostNteObject $errTE; PostNteObject $errNte
            $toAdd = $true
        }
        elseif (${ScopeOverwrite}) {            #Only ScopeOverwrite is given
            $toUpdate = $true            
            $toDeleteScopeSubElement = $true            #Need to delete all the scope subelement other than leases
            Write-Verbose ($_system_translations.Ver_Import_Scope_Exists_1 -f $currentScopeId,$script:DhcpServerName)
        }        
        else {                                     #ScopeOverwrite is not given
            #Move to scope end element [</Scope>]
            Write-Warning ($_system_translations.War_Import_Scope_Exists_2 -f $currentScopeId,$script:DhcpServerName)
            $script:reader.ReadToNextSibling($ScopeElement) > $null #Since there is no <Scope> sibling at this level, it will move to end element of parent node of current node
            WriteTraceMessage ("Current ImportFile v4scope $currentScopeId already present on destination. Skipping to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
            return;
        }
    }
    else 
    {
        #No conflicting scope found - Add the scope
        $toAdd = $true
    }
    
    WriteTraceMessage ($_system_translations.Ver_Import_Scope -f $currentScopeId, $script:DhcpServerName)
    Write-Verbose ($_system_translations.Ver_Import_Scope -f $currentScopeId, $script:DhcpServerName)
    
    $switchParam = $null    
    if ($toUpdate) { #Update the current ImportFile v4Scope on the target machine        
        #Update the NapEnable bool field from true/1 or false/0 to $true or $false
        if (("true" -eq $mandatory["NapEnable"]) -or ("1" -eq $mandatory["NapEnable"])) { $mandatory["NapEnable"]=$true } else { $mandatory["NapEnable"]=$false }

        if ($optional.Contains("ActivatePolicies")) {
            if (("true" -eq $optional["ActivatePolicies"]) -or ("1" -eq $optional["ActivatePolicies"])) { $optional["ActivatePolicies"]=$true } else { $optional["ActivatePolicies"]=$false }
        }
        
        $cmdlet = "Set-DhcpServerv4Scope"
        #Remove the SubnetMask mandatory field since Set-Scope doesnt take it
        $mandatory.Remove("SubnetMask")
        WriteTraceMessage "Updating (SET) the Scope"
    }
    elseif ($toAdd) { #Add the current ImportFile v4Scope on the target machine
        #Update the NapEnable bool field from true/1 or false/0 to $true or $false and add this as switch parameter 
        if (("true" -eq $mandatory["NapEnable"]) -or ("1" -eq $mandatory["NapEnable"])) { $switchParam = @{"NapEnable"=$true} } else { $switchParam = @{"NapEnable"=$false} }
        $mandatory.Remove("NapEnable")
                
        #Remove the ScopeId mandatory field since Add-Scope doesnt take it
        $mandatory.Remove("ScopeId")
        
        if ($optional.Contains("ActivatePolicies")) {
            if (("true" -eq $optional["ActivatePolicies"]) -or ("1" -eq $optional["ActivatePolicies"])) { $optional["ActivatePolicies"]=$true } else { $optional["ActivatePolicies"]=$false }
        }
        
        $cmdlet = "Add-DhcpServerv4Scope"
        WriteTraceMessage "Adding the v4 Scope"
    }       
    
    #Add/Set the current ImportFile Scope
    $temp = ExecuteCmdlet -CmdletName $cmdlet -MandatoryParams $mandatory -OptionalParams $optional -SwitchParams $switchParam -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    
    #If Add scope fails, no need to process further
    if ($toAdd -and (NotNull $errTE)) { 
        WriteTraceMessage "ReadAndApplyv4Scope: Add v4Scope failed -- existing the function" $true
        $script:reader.ReadToNextSibling($ScopeElement) > $null     #Since there is no <Scope> sibling at this level, it will move to end element of parent node of current node
        WriteTraceMessage ("ReadAndApplyv4Scope: Add v4Scope failed - Skipping to end of scope - {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
        return 
    }    

    ImportDhcpv4ScopeSubElements $currentScopeId $toDeleteScopeSubElement
}

function ImportDhcpv4ScopeSubElements([string]$ScopeId, [bool]$ToDeleteScopeSubElement=$true)
{
    WriteTraceMessage ("ImportDhcpv4ScopeSubElement: ScopeId= {0}, DeleteSubElement= {1}" -f $ScopeId,$ToDeleteScopeSubElement)
        
    ReadAndApplyExclusionRanges $true $ScopeId $ToDeleteScopeSubElement
            
    #If there is a Policies Node, import all v4 Policies for this scope
    ReadAndApplyPolicies $ScopeId $ToDeleteScopeSubElement   
        
    #If there is a OptionValues Node, import all v4 OptValues for this scope
    ReadAndApplyOptionValues $true $ScopeId "" "" $ToDeleteScopeSubElement
        
    #If there is a Reservations Node, import all v4 Reservation for this scope
    ReadAndApplyReservations $true $ScopeId $ToDeleteScopeSubElement
             
    #If there is a Leases Node and Leases switch parameter is given, import all v4 Leases for this scope
    if ($script:reader.IsStartElement($LeasesElement)) {
        if (!($script:reader.IsEmptyElement)) {
            if (${Leases}) {
                ReadAndApplyv4Leases $ScopeId
                $script:reader.Read() > $null                       #Move to element after Leases End element            
            }
            else {
                $script:reader.Skip()                               #Move to element after Leases End element
                WriteTraceMessage ("Skipping v4 Leases to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
            }
        }
        else {                                                      #Empty element - move to element after empty Leases node
            WriteTraceMessage "Empty Leases element ..."
            $script:reader.Read() > $null
        }
    }
}

#Get all existing v4 or v6 scopes on destination machine
function GetAllScopes([bool]$IsV4)
{
    $errNte = @(); $errTE = $null
    [Array]$allScopes = @()
    
    if ($IsV4) { $cmdlet = "Get-DhcpServerv4Scope" } else { $cmdlet = "Get-DhcpServerv6Scope" }
    $temp = ExecuteCmdlet -CmdletName $cmdlet -Nte ([ref]$errNte) -Te ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    if (NotNull $temp) { $allScopes += $temp }
    
    return $allScopes
}

#While entring node is startElement 'Scopes' / While leaving Node is EndElement 'Scopes'
function ReadAndApplyv4Scopes()
{        
    WriteTraceMessage "Entered ReadAndApplyv4Scopes"
    WriteTraceMessage "Input v4 Scopes: $script:scopesToBeImported"
    
    #Get all the existings v4 scopes on the destination machine
    $script:Existingv4Scopes = GetAllScopes $true
    
    WriteTraceMessage "Existing v4 scopes on destination are:"
    if ($global:TraceMessage) { $script:Existingv4Scopes }
    
    while ($script:reader.Read()) { #Reader is at present on Scopes start element - move it to Scope start element
        if ($script:reader.IsStartElement($ScopeElement)) {
            ReadAndApplyv4Scope
        }
        else { break }
    }    
}


#While entring node is startElement 'Filter' / While leaving Node is EndElement 'Filter'
function ReadAndApplyFilter()
{
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}
    $script:reader.Read()  > $null #current node is 'Filter' move it to next node
    GenericXmlReader $mandatory $FilterPropertiesMandatory $optional $FilterPropertiesOptional
    #$mandatory | ft; $optional | ft    
            
    $temp = ExecuteCmdlet -CmdletName Add-DhcpServerv4Filter -MandatoryParams $mandatory -OptionalParams $optional -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte    
}

# All the Filters on the target machine will be deleted
# If While entring the function, the StartElement is 'Filters' then all the Filters elements under it would be imported AND while leaving the function, the node is EndElement 'Filters'
function ReadAndApplyFilters()
{    
    $errNte     = @()
    $localEV    = @()
    $errTE      = $null
    
    WriteTraceMessage $_system_translations.Ver_Import_Server_Filter
        
    Write-Verbose $_system_translations.Ver_Import_Server_Filter_Del            
    #Get & Delete all the existing Filters for v4Server on targetServer    
    $GetFilterCmdlet        = ExecuteCmdlet -CmdletName Get-DhcpServerv4Filter -Nte ([ref]$errNte) -DontRun
    $RemoveFilterCmdlet     = ExecuteCmdlet -CmdletName Remove-DhcpServerv4Filter -Nte ([ref]$errNte) -DontRun
    
    $pipelineCmdlet = "$GetFilterCmdlet | $RemoveFilterCmdlet"
    WriteTraceMessage "Running Cmdlet: $pipelineCmdlet"
    try { Invoke-Expression  $pipelineCmdlet }
    catch { PostNteObject $_ } #catch the TE & post it as NTE
    PostNteObject($localEV)

    if ($script:reader.IsStartElement($FiltersElement)) {                       #If Filters start element is present, import all the Filter elements under it
        Write-Verbose $_system_translations.Ver_Import_Server_Filter            
        $script:reader.Read()          > $null                                          #Reader is at present on Filters start element - move it to next (Allow) start element
        [bool]$allowFilterList         = $script:reader.ReadElementContentAsBoolean()    #Read Allow element
        [bool]$denyFilterList         = $script:reader.ReadElementContentAsBoolean()    #Read Deny element
        
        $temp = ExecuteCmdlet -CmdletName Set-DhcpServerv4FilterList -OptionalParams @{"Allow"=$allowFilterList;"Deny"=$denyFilterList} -Nte ([ref]$errNte) -TE ([ref]$errTE)
        PostNteObject($errTE); PostNteObject($errNte)
        
        while ($script:reader.IsStartElement($FilterElement)) #If there are filter elements - import them
        {
            ReadAndApplyFilter
            $script:reader.Read()     > $null                                            #reader is at present at Filter end element - move it to next node
        }    

        $script:reader.Read() > $null                                                   #Move to element after Filters End element
    }
}


#While entring node is startElement 'StatelessStore' / While leaving Node is EndElement 'StatelessStore'
function ReadAndApplyStatelessStore([string]$Prefix="")
{    
    [HashTable]$optionalParam       = $null
    $errNte                         = @()
    $errTE                          = $null

    if (IsNullOrEmptyString $Prefix) { WriteTraceMessage "Importing Server level Stateless"; $optionalParam = $null } 
    elseif (!(IsNullOrEmptyString $Prefix)) { WriteTraceMessage ("Importing scope={0} level Stateless" -f $Prefix); $optionalParam = @{"Prefix" = $Prefix} }
    
    $script:reader.Read()           > $null             #Move reader to 'Enabled' node
    [bool]$enabled                  = $script:reader.ReadElementContentAsBoolean()    
    $purgeInterval                  = $script:reader.ReadElementString("PurgeInterval");
    $mandatory = @{ "Enabled"=$enabled; "PurgeInterval"=$purgeInterval }
    
    [TimeSpan]$timeSpan = $purgeInterval
    if ($timeSpan.TotalSeconds -ne 0) {     #If PurgeInterval is 0, dont set it since its an error
        $temp = ExecuteCmdlet -CmdletName Set-DhcpServerv6StatelessStore -MandatoryParams $mandatory -OptionalParams $optionalParam -Nte ([ref]$errNte) -TE ([ref]$errTE)
        PostNteObject($errTE); PostNteObject($errNte)
    }
}


#While entring node is startElement 'IPv4' / While leaving Node is EndElement 'IPv4'
function ImportDhcpv4Server()
{
    # ReadAndApplyClasses, ReadAndApplyOptionDefintions, ReadAndApplyv4Scopes will always be called
    # ReadAndApplyServerSetting, ReadAndApplyOptionValues, ReadAndApplyPolicies, ReadAndApplyFilters will be called only for CompleteServer Import

    WriteTraceMessage "Entered ImportDhcpv4Server"
    
    $script:reader.Read() > $null  #Move to element after IPv4 element
    
    # Import the server setting only if import Mode is CompleteDhcpServer
    if ($script:ImportSetting -eq $CompleteDhcpServer) {
        ReadAndApplyServerSetting            
        #Current Node will be element after ActivatePolicies
    }
    else {    
        $script:reader.ReadToFollowing($NpsUnreachableActionElement) > $null    # Move to NpsUnreachableActionElement start node    
        $script:reader.Skip()                                                                               # Move to element after NpsUnreachableActionElement end node
        if ($script:reader.IsStartElement($ActivatePoliciesElement)) {                    # ActivatePoliciesElement is an optional element, if it is present, move past it
            $script:reader.Skip()                                                                           # Move to element after ActivatePolicies end node
        }
        WriteTraceMessage ("Skipping v4ServerSetting to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
    }

    #If there is a Classes Node, import all v4 Classes
    if ($script:reader.IsStartElement($ClassesElement)) {              
        ReadAndApplyClasses $true
        $script:reader.Read() > $null  #Move to element after Classes End element
    }        
    
    #If there is a OptionDefinitions Node, import all v4 OptDefs
    if ($script:reader.IsStartElement($OptDefsElement)) {            
        ReadAndApplyOptionDefintions $true        
        $script:reader.Read() > $null  #Move to element after OptionDefinition End element
    }
    
    #If there is a Policies Node and CompleteDhcpServer is getting imported, import all Policies @ v4Server Level
    if ($script:ImportSetting -eq $CompleteDhcpServer) {
        ReadAndApplyPolicies
    }
    else { 
        if ($script:reader.IsStartElement($PoliciesElement)) {
            $script:reader.Skip()              #Move to element after Policies End element
            WriteTraceMessage ("Skipping v4 Policies to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
        }
    }
    
    #If there is a OptionValues Node and CompleteDhcpServer is getting imported, import all v4 OptValues @ v4Server Level
    if ($script:ImportSetting -eq $CompleteDhcpServer) {
        ReadAndApplyOptionValues $true
    }
    else { 
        if ($script:reader.IsStartElement($OptValuesElement)) {
            $script:reader.Skip()             #Move to element after OptionValues End element
            WriteTraceMessage ("Skipping v4 OptionValues to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
        }
    }         
            
    #If there is a Filters Node and CompleteDhcpServer is getting imported, import all Filters @ v4Server Level
    if ($script:ImportSetting -eq $CompleteDhcpServer) {
        ReadAndApplyFilters
    }
    else { 
        if ($script:reader.IsStartElement($FiltersElement)) {
            $script:reader.Skip()              #Move to element after Filters End element
            WriteTraceMessage ("Skipping v4 Filters to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
        }
    }
   
    #If there is a Scopes Node, import all (or particular) v4 Scopes
    if ($script:reader.IsStartElement($ScopesElement)) {
        if (!${ServerConfigOnly}) {             # Import Scope Nodes if ServerConfigOnly is not given
            ReadAndApplyv4Scopes
            $script:reader.Read() > $null  #Move to element after Scopes End element
        }
        else {
            $script:reader.Skip()             #Move to element after Scopes End element
            WriteTraceMessage ("ServerConfigOnly parameter was provided: Skipped v4 Scopes node to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true  
        }
    }
}

#While entring node is startElement 'Lease' / While leaving Node is EndElement 'Lease'
function ReadAndApplyv6Lease([string]$Prefix)
{
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional      = @{}
    $script:reader.Read()  > $null                 #current node is 'Lease' move it to next node
    GenericXmlReader $mandatory $Leasev6PropertiesMandatory $optional $Leasev6PropertiesOptional
    #$mandatory | ft; $optional | ft
        
    $temp = ExecuteCmdlet -CmdletName Add-DhcpServerv6Lease -MandatoryParams $mandatory -OptionalParams $optional -Nte ([ref]$errNte) -TE ([ref]$errTE)
    
    #If error returned is 'Client already exist (20014)', dont post the error since for reservation, the client lease already exist and adding it will give 20014 error    
    if ((NotNull $errTE) -and ($errTE.Exception -is [Microsoft.Management.Infrastructure.CimException]) -and ($errTE.Exception.ErrorData.error_Code -eq 20014)) { return }
    if ((NotNull $errNte) -and ($errNte.Count -gt 0) -and ($errNte[0].Exception.ErrorData.error_Code -eq 20014)) { return }
    
    PostNteObject $errTE
    PostNteObject $errNte
}


#While entring node is startElement 'Leases' / While leaving Node is EndElement 'Leases'
function ReadAndApplyv6Leases([string] $Prefix="")
{            
    WriteTraceMessage ($_system_translations.Ver_Import_Scope_Leases -f $Prefix)
    Write-Verbose ($_system_translations.Ver_Import_Scope_Leases -f $Prefix)    
        
    while ($script:reader.Read()) { #Reader is at present on Leases start element - move it to Lease start element
        if ($script:reader.IsStartElement($LeaseElement)) {
            ReadAndApplyv6Lease $Prefix
        }
        else { break }
    }    
}

#While entring node is startElement 'Scope' / While leaving Node is EndElement 'Scope'
function ReadAndApplyv6Scope()
{
    WriteTraceMessage "Entered ReadAndApplyv6Scope"
    
    $errNte        = @(); $errTE        = $null
    $mandatory     = @{}; $optional     = @{}
    
    $script:reader.Read()  > $null #current node is 'Scope' move it to next node
    GenericXmlReader $mandatory $Scopev6PropertiesMandatory $optional $Scopev6PropertiesOptional
    #$mandatory | ft; $optional | ft    
    
    $currentScopeId = $mandatory["Prefix"]
    $script:ImportFilev6Scopes += $currentScopeId
    
    WriteTraceMessage "Current ImportFile v6Scope is $currentScopeId"
    
    #If !CompleteServerImport AND ImportFileScope is not part of inputScope List, skip to end Scope </Scope> element & return
    #If ImportFileScope exists on destination
        #if ScopeOverwrite and lease is given, delete the scope and then Add it
        #if ScopeOverwrite is given, update the scope        
        #If ScopeOverwrite is not given, skip to next <Scope> element
        #Delete and add all the sub-elements of the scope
    #If ImportFileScope does not exist on destination
        #Add the scope and all it sub-element
    
    if ($script:ImportSetting -ne $CompleteDhcpServer) {
        #One of more v6scopes given to be imported
        #Check if ImportFile current v6scope is part of input v6scope list
        #If not, skip to end scope element for current scope
        if ($script:prefixesToBeImported -notcontains $currentScopeId) {
            $script:reader.ReadToNextSibling($ScopeElement) > $null     #Since there is no <Scope> sibling at this level, it will move to end element of parent node of current node
            WriteTraceMessage ("Current ImportFile scope $currentScopeId not part of input scope List. Skipping to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
            return;
        }
    }
    
    $toAdd = $false; $toUpdate = $false; $toDeleteScopeSubElement = $false
    if (IsConflictingv6Scope $currentScopeId)    
    {
        #Conflicting v6 Scope is present
        if (${ScopeOverwrite} -and ${Leases}) { #Both ScopeOverwrite and Leases are given, delete and then add the scope
            Write-Verbose ($_system_translations.Ver_Import_Scope_Exists_3 -f $currentScopeId,$script:DhcpServerName)
            #Remove the v6 scope on the target machine
            ExecuteCmdlet -CmdletName "Remove-DhcpServerv6Scope -Prefix $currentScopeId -Force" -Nte ([ref]$errNte) -TE ([ref]$errTE)
            PostNteObject $errTE; PostNteObject $errNte
            $toAdd = $true
        }
        elseif (${ScopeOverwrite}) {            #Only ScopeOverwrite is given
            $toUpdate = $true            
            $toDeleteScopeSubElement = $true
            Write-Verbose ($_system_translations.Ver_Import_Scope_Exists_1 -f $currentScopeId,$script:DhcpServerName)
        }        
        else {                                     #ScopeOverwrite is not given
            #Move to scope end element [</Scope>]
            Write-Warning ($_system_translations.War_Import_Scope_Exists_2 -f $currentScopeId,$script:DhcpServerName)
            $script:reader.ReadToNextSibling($ScopeElement) > $null #Since there is no <Scope> sibling at this level, it will move to end element of parent node of current node
            WriteTraceMessage ("Current ImportFile v6scope $currentScopeId already present on destination. Skipping to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
            return;
        }
    }
    else 
    {
        #No conflicting scope found - Add the scope
        $toAdd = $true
    }
        
    WriteTraceMessage ($_system_translations.Ver_Import_Scope -f $currentScopeId, $script:DhcpServerName)
    Write-Verbose ($_system_translations.Ver_Import_Scope -f $currentScopeId, $script:DhcpServerName)
        
    if ($toUpdate) { #Update the current ImportFile v6Scope on the target machine        
        $cmdlet = "Set-DhcpServerv6Scope"        
        WriteTraceMessage "Updating (SET) the Scope"
    }
    elseif ($toAdd) { #Add the current ImportFile v6Scope on the target machine        
        $cmdlet = "Add-DhcpServerv6Scope"
        WriteTraceMessage "Adding the v6 Scope"
    }
    
    #Add/Set the current ImportFile Scope
    $temp = ExecuteCmdlet -CmdletName $cmdlet -MandatoryParams $mandatory -OptionalParams $optional -Nte ([ref]$errNte) -TE ([ref]$errTE)
    PostNteObject $errTE; PostNteObject $errNte
    
    #If Add scope fails, no need to process further
    if ($toAdd -and ((NotNull $errTE) -or ($errNte.Count -gt 0))) { 
        WriteTraceMessage "ReadAndApplyv6Scope: Add v6Scope failed -- existing the function" $true
        return 
    }    
    
    ImportDhcpv6ScopeSubElements $currentScopeId $toDeleteScopeSubElement
}

function ImportDhcpv6ScopeSubElements([string] $Prefix, [bool] $ToDeleteScopeSubElement=$true)
{    
    WriteTraceMessage ("ImportDhcpv6ScopeSubElement: Prefix= {0}, DeleteSubElement= {1}" -f $ScopeId,$ToDeleteScopeSubElement)
    
    #If there is a ExclusionRanges Node, import all v6 ExclusionRanges for this scope    
    ReadAndApplyExclusionRanges $false $Prefix $ToDeleteScopeSubElement
    
    #If there is a OptionValues Node, import all v6 OptValues for this scope
    ReadAndApplyOptionValues $false $Prefix $ToDeleteScopeSubElement
         
    #If there is a Reservations Node, import all v6 Reservation for this scope
    ReadAndApplyReservations $false $Prefix $ToDeleteScopeSubElement
                
    #If there is a Stateless Node, import the Stateless config for this scope
    if ($script:reader.IsStartElement($StatelessElement)) {            
        ReadAndApplyStatelessStore $Prefix
        $script:reader.Read() > $null                       #Move to element after Stateless End element
    }
         
    #If there is a Leases Node and Leases switch parameter is given, import all v6 Leases for this scope
    if ($script:reader.IsStartElement($LeasesElement)) {
        if (!($script:reader.IsEmptyElement)) {
            if (${Leases}) {
                ReadAndApplyv6Leases $Prefix
                $script:reader.Read() > $null                          #Move to element after Leases End element
            }
            else {
                $script:reader.Skip()                                 #Move to element after Leases End element
                WriteTraceMessage ("Skipping v6 Leases to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
            }
        }
        else {
            WriteTraceMessage "Empty Leases element ..."
            $script:reader.Read() > $null                          #Empty element - move to element after Leases empty element
        }
    }
}

#While entring node is startElement 'Scopes' / While leaving Node is EndElement 'Scopes'
function ReadAndApplyv6Scopes()
{    
    WriteTraceMessage "Entered ReadAndApplyv6Scopes"    
    WriteTraceMessage "Input v6 Scopes: $script:prefixesToBeImported"
    
    #Get all the existings v6 scopes on the destination machine
    $script:Existingv6Scopes = GetAllScopes $false
    
    WriteTraceMessage "Existing v6 scopes on destination are:"
    if ($global:TraceMessage) { $script:Existingv6Scopes }
            
    while ($script:reader.Read()) { #Reader is at present on Scopes start element - move it to Scope start element
        if ($script:reader.IsStartElement($ScopeElement)) {
            ReadAndApplyv6Scope
        }
        else { break }
    }    
}


#While entring node is startElement 'IPv6' / While leaving Node is EndElement 'IPv6'
function ImportDhcpv6Server()
{
    # ReadAndApplyClasses, ReadAndApplyOptionDefintions, ReadAndApplyv6Scopes will always be called
    # ReadAndApplyOptionValues, ReadAndApplyStatelessStore will be called only for CompleteServer Import
    
    WriteTraceMessage "Entered ImportDhcpv6Server"
    
    $script:reader.Read() > $null  #Move to element after IPv6 element    
    
    #If there is a Classes Node, import all v6 Classes
    if ($script:reader.IsStartElement($ClassesElement)) {            
        ReadAndApplyClasses $false
        $script:reader.Read() > $null  #Move to element after Classes End element
    }        
    
    #If there is a OptionDefinitions Node, import all v6 OptDefs
    if ($script:reader.IsStartElement($OptDefsElement)) {            
        ReadAndApplyOptionDefintions $false
        $script:reader.Read() > $null  #Move to element after OptionDefinition End element
    }
        
    #If there is a OptionValues Node and CompleteDhcpServer is getting imported, import all v6 OptValues @ v6Server Level
    if ($script:ImportSetting -eq $CompleteDhcpServer) {
        ReadAndApplyOptionValues $false
    }
    else { 
        if ($script:reader.IsStartElement($OptValuesElement)) {        
            $script:reader.Skip()             #Move to element after OptionValues End element
            WriteTraceMessage ("Skipping v6 OptionValues to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
        }
    }
    
    #If there is a Stateless Node and CompleteDhcpServer is getting imported, import the Stateless config
    if ($script:reader.IsStartElement($StatelessElement)) {
        if ($script:ImportSetting -eq $CompleteDhcpServer) {
            ReadAndApplyStatelessStore
            $script:reader.Read() > $null  #Move to element after Stateless End element
        }
        else { 
            $script:reader.Skip()             #Move to element after Stateless End element
            WriteTraceMessage ("Skipping v6 Stateless to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
        }
    }
    
    #If there is a Scopes Node, import v6 Scopes
    if ($script:reader.IsStartElement($ScopesElement)) {
        if (!${ServerConfigOnly}) {             # Import Scope Nodes if ServerConfigOnly is not given
            ReadAndApplyv6Scopes
            $script:reader.Read() > $null  #Move to element after Scopes End element
        }
        else {
            $script:reader.Skip()             #Move to element after Scopes End element
            WriteTraceMessage ("ServerConfigOnly parameter was provided: Skipped v6 Scopes node to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true  
        }        
    }
}

# Read the Xml file and imports all the relevant settings
function ImportDhcpServerFromFile()
{
    [String[]] $script:ImportFilev4Scopes = @()
    [String[]] $script:ImportFilev6Scopes = @()
    
    #Move to root node
    $script:reader.MoveToContent() > $null  #Current node is now root (DHCPServer) node
    $script:reader.Read()          > $null  #Move to MajorVersion element
    
    #Reads the version info and checks if ImportFile can be imported to destinatin machine
    #After this call, reader is positioned at start element after 'MinorVersion'
    ReadAndVerifyVersionInfo
    
    Write-Verbose ($_system_translations.Ver_Import_Started -f $script:DhcpServerName, $script:ImportFile)
    WriteTraceMessage "ImportSetting is $script:ImportSetting [CompleteDhcpServer=0, SpecificV4AndV6Scopes=1, SpecificV4Scopes=2, SpecificV6Scopes=3"
    
    if ($script:reader.IsStartElement($IPv4Element)) {            #There is IPv4 Node
        if ($script:ImportSetting -ne $SpecificV6Scopes) {        #User has asked for v4 Scopes import                    
            ImportDhcpv4Server
            $script:reader.Read() > $null                          #Move to element after IPv4 End element 
        }
        else {
            #User has not asked for v4 scopes imports
            #Move reader to start element after </IPv4>            
            $script:reader.Skip()                                #This call will move the Reader to element after the End Node of the current node
            WriteTraceMessage ("Skipping the IPv4 Node since ImportSetting is SpecificV6Scope to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
        }
    }    
    
    if ($script:reader.IsStartElement($IPv6Element)) {             #There is a IPv6 Node
        if ($script:ImportSetting -ne $SpecificV4Scopes) {         #User has asked for v6 Scopes import
            ImportDhcpv6Server
            $script:reader.Read() > $null                          #Move to element after IPv6 End element
        }
        else {
            #User has not asked for v6 scopes imports
            #Move reader to start element after </IPv6>            
            $script:reader.Skip()
            WriteTraceMessage ("Skipping the IPv6 Node since ImportSetting is SpecificV4Scope to {1}({0})" -f $script:reader.NodeType, $script:reader.Name) $true
        }
    }
    
    #Give NTE for all the v4/v6 scopes which were given as input but were not part of Import File
    foreach ($scope in $script:scopesToBeImported) {
        if ($script:ImportFilev4Scopes -notcontains $scope) {
            PostNteString ($_system_translations.ErrInputScopeNotInImportFile -f $scope, $script:ImportFile) "ObjectNotFound" "ObjectNotFound" $scope
        }
    }    
    foreach ($scope in $script:prefixesToBeImported) {
        if ($script:ImportFilev6Scopes -notcontains $scope) {
            PostNteString ($_system_translations.ErrInputScopeNotInImportFile -f $scope, $script:ImportFile) "ObjectNotFound" "ObjectNotFound" $scope
        }
    }
    
}

#endregion

#region XML Util Functions

# Generic XML Writer - writes the Key of the HashTable as ElementName and Value of the HashTable as ElementValue of the XML
# Takes 2 HashTables and 2 Arrays of Xml Element names - these corresponds to Mandatory and Optional elements of XML
# Since there is no way to enumeration HashTable in a desired sequence (Note HashTable enumeration is based on its key assignment logic)
# a separate array is maintained for the name of the keys (Xml Element name) in the HashTable
# XML is written as per the sequence of this array
# Fluses the XML at the end so that in-memory XML data is written to the file
function GenericXmlWriter([HashTable]$mandatory, [String[]] $mandatoryKeys, [HashTable]$optional=@(), [String[]] $optionalKeys)
{    
    foreach ($key in $mandatoryKeys)
    {    
        foreach($value in $mandatory[$key]){
            $script:writer.WriteElementString($key, $value);    
        }
    }
    
    foreach ($key in $optionalKeys)
    {
        if ($optional.Contains($key)){
            foreach($value in $optional[$key]){            
                $script:writer.WriteElementString($key, $value);    
            }
        }        
    }
    
    $script:writer.Flush()    
}

# Generic XML Reader - Reads the XML and populates the Hashtable. XmlElementName and XmlElementValue goes as Key and Value respectively for the HashTable
# XML is read in the same order as the corresponding array for mandatory/optional hashtable
# XML with multiple sequential elements with same name is taken care of
function GenericXmlReader([HashTable]$mandatory, [String[]] $mandatoryKeys, [HashTable]$optional=@(), [String[]] $optionalKeys)
{    
    foreach ($key in $mandatoryKeys)
    {
        [string]$singleValue = $null
        [array]$multiValue = $null
        $isMultiValue = $false
        $singleValue = $script:reader.ReadElementString($key);
        while($script:reader.IsStartElement($key)) { #This is a multi value case
            if (!($isMultiValue)) { $multiValue += $singleValue }
            $multiValue += $script:reader.ReadElementString($key);
            $isMultiValue = $true
        }
        if ($isMultiValue) { $mandatory[$key] = $multiValue } else { $mandatory[$key] = $singleValue }
    }
    
    foreach ($key in $optionalKeys)
    {
        [string]$singleValue = $null
        [array]$multiValue = $null
        $isMultiValue = $false    
        if ($script:reader.IsStartElement($key)) {
            $singleValue = $script:reader.ReadElementString($key);
            while ($script:reader.IsStartElement($key)) { #This is a multi value case
                if (!($isMultiValue)) { $multiValue += $singleValue }
                $multiValue += $script:reader.ReadElementString($key);
                $isMultiValue = $true                
            }            
            if ($isMultiValue) { $optional[$key] = $multiValue } else { $optional[$key] = $singleValue }            
        }
    }
}

#endregion

#region UtilFunctions

# ExecuteCmdlet function is used either to execute a given cmdlet or return the full formed cmdlet expression
#  [Later is used when more than 1 cmdlet full expression is needed for running them in pipeline]

# $CmdletName       : Name of the cmdlet
# MandatoryParams   : Mandatory parameters needs to be passed to Cmdlet
# OptionalParams    : Optional parameters needs to be passed to Cmdlet
# SwitchParams      : Switch parameters to be passed to Cmdlet
# Nte               : [Out parameters] If given and NTE occurs while executing th cmdlets, populated with the NTE(s) occurred
# TE                : [Out parameters] If given and TE occurs while executing th cmdlets, populated with the TE occurred, else TE is thrown back to caller
# $DontRun          : Switch parameter - if given the cmdlet is not run - instead its constructed and returned
function ExecuteCmdlet([string]$CmdletName, [HashTable]$MandatoryParams=$null, [HashTable]$OptionalParams=$null, [HashTable]$SwitchParams=$null, [ref]$Nte, [ref]$TE, [Switch]$DontRun)
{
    try
    {
        $localEV        = @()
        $result         = $null        
        $cmdletToRun    = $cmdletName
        $displayStr     = $cmdletName
        
        if ($null -ne $Nte){
            $Nte.Value = @()
        }        
        
        if ($null -ne $TE){
            $TE.Value = $null
        }        
        
        if ($null -ne $mandatoryParams){
            foreach ($paramKey in $mandatoryParams.Keys){
                $cmdletToRun += " -$paramKey `$mandatoryParams[`"$paramKey`"]"
                $displayStr  += " -$paramKey $(__ParamToString $mandatoryParams[$paramKey])"
            }
        }
        
        if ($null -ne $optionalParams){            
            foreach ($paramKey in $optionalParams.Keys){                
                if ($null -ne $optionalParams[$paramKey]){                    
                    $cmdletToRun += " -$paramKey `$optionalParams[`"$paramKey`"]"
                    $displayStr  += " -$paramKey $(__ParamToString $optionalParams[$paramKey])"                    
                }
            }        
        }
        
        if ($null -ne $SwitchParams){            
            foreach ($paramKey in $SwitchParams.Keys){
                if (($null -ne $SwitchParams[$paramKey]) -and ($true -eq $SwitchParams[$paramKey])) {                
                    $cmdletToRun += " -$paramKey"            
                    $displayStr  += " -$paramKey"
                }                
            }            
        }

        if (!(IsNullOrEmptyString ${ComputerName})) {
            $cmdletToRun += " -ComputerName ${ComputerName}"
            $displayStr  += " -ComputerName ${ComputerName}"
        }
        
        if ($null -ne ${CimSession}) {
            $cmdletToRun += " -CimSession $(${CimSession}.ComputerName)"
            $displayStr  += " -CimSession $(${CimSession}.ComputerName)"
        }
        
        if ($null -ne $Nte) {            
            $cmdletToRun += " -EV +localEV"        
            $displayStr  += " -EV +localEV"
        }
        
        $cmdletToRun += " 2> `$null"
        $displayStr  += " 2> `$null"
        
        if ($DontRun) { WriteTraceMessage "Cmdlet string to Return: $displayStr" }
        else { WriteTraceMessage "Running Cmdlet: $displayStr" } 
        
        if ($DontRun) { return $displayStr }
        else {
            $result = Invoke-Expression $cmdletToRun
            
            if ($null -ne $Nte) {
                $Nte.value = $localEV
            }            
            return $result
        }
    }
    catch
    {
        if ($null -ne $TE) {
            $TE.value = $_
        }
        else{
            throw
        }
    }
}

# Helper function for ExecuteCmdlet - Used for display purpose or when DontRun is given
function __ParamToString($obj)
{
    [String]$str = $null
    if($null -ne $obj) {
        if(($obj.GetType().Name -eq "Object[]") -or ($obj.GetType().Name -eq "String[]")){
            if($obj.count -gt 0) {
                $str = "@(`"$($obj[0])`""
                for($i=1; $i -lt $obj.count; $i++){
                    $str += ", `"$($Obj[$i])`""
                }
                $str+=")"
            } else {
                $str="@()"
            }
        } elseif($obj.GetType().Name -eq "String"){
            $str = "`"$obj`""
        } elseif($obj.GetType().Name -eq "Boolean"){
            if($true -eq $obj ) {
                $str = "`$true"
            } else {
                $str = "`$false"
            }
        } else {
            $str = "$obj"
        }
    }
    return $str
}

#Input $fileName can be a relative or Full Path
#The function returns a canonical fully qualified path
function GetFullyQualifiedPath([string] $fileName)
{
    [string] $temp = $fileName
    try
    {
        if ([System.IO.Path]::IsPathRooted($fileName)) {
            #This is a complete path
            #Get canonical path            
            $fullPath = [System.IO.Path]::GetFullPath($fileName)
        }
        else {
            #It is a relative path - add current directory to it
            $temp = ($pwd.Path) + "\" + $fileName
            #Get canonical path
            $fullPath = [System.IO.Path]::GetFullPath($temp)
        }
    }
    catch
    {
        ThrowTEString($_system_translations.ErrFilePathInvalid -f $temp,$_.ToString()) $EC_InvalidArgument $EC_InvalidArgument $temp
    }
    
    return $fullPath
}    

# If $ComputerName is empty or null string, $script:DhcpServerName is set to the localHost name 
# Else copies $ComputerName to $script:DhcpServerName
function GetComputerName ([string]$ComputerName) {
    if (!(IsNullOrEmptyString($ComputerName))) { 
        $script:DhcpServerName = $ComputerName
    } else {
        $script:DhcpServerName = [System.Net.Dns]::GetHostName()
    }
}

# Returns $true if $DhcpServerVersion represents a DhcpVersion equal to or greater than WIN8 (MajorVersion=6, MinorVersion=2)
function IsWindows8OrHigher($DhcpServerVersion)
{
    if (($DhcpServerVersion.MajorVersion -gt $Win8MajorVersion) -or (($DhcpServerVersion.MajorVersion -eq $Win8MajorVersion) -and ($DhcpServerVersion.MinorVersion -ge $Win8MinorVersion))) {
        return $true
    }
    else { return $false }
}

# Returns $true if $DhcpServerVersion represents a DhcpVersion equal to or greater than WIN2K8-R2 (MajorVersion=6, MinorVersion=1)
function IsWindows2008R2OrHigher($DhcpServerVersion)
{
    if (($DhcpServerVersion.MajorVersion -gt $Win8MajorVersion) -or (($DhcpServerVersion.MajorVersion -eq $Win8MajorVersion) -and ($DhcpServerVersion.MinorVersion -ge $Win2K8R2MinorVersion))) {
        return $true
    }
    else { return $false }
}

# Return $true if given variable is $null
function IsNull($var) { return ($null -eq $var) }

# Return $true if given variable is NOT $null
function NotNull($var) { return ($null -ne $var) }

# Return $true if given input string is $null or EmptyString ("")
function IsNullOrEmptyString([string] $str) { return ($null -eq $str -or "" -eq $str) }    

# Throws TE or Post NTE for Export
function ExportDhcpServer([System.Management.Automation.ErrorRecord]$err, [bool]$isTE)
{ 
    if (!$isTE)
    {
        if ($err.Exception -is [Microsoft.Management.Infrastructure.CimException]) {
            #This is CimException returned by DHCP Cmdlets
            $errMsg = ($_system_translations.GenericErrorMsg -f $err.ToString(), $err.Exception.ErrorData.error_WindowsErrorMessage, $err.Exception.ErrorData.error_Code)
            $err.ErrorDetails = $errMsg
            $PSCmdlet.WriteError($err)            
        }
        else {
            $PSCmdlet.WriteError($err)            
        }
    }
    else
    {
        $PSCmdlet.ThrowTerminatingError($err)        
    }
}

# Throws TE or Post NTE for Import
function ImportDhcpServer([System.Management.Automation.ErrorRecord]$err, [bool]$isTE)
{
    if (!$isTE)
    {
        if ($err.Exception -is [Microsoft.Management.Infrastructure.CimException]) {
            #This is CimException returned by DHCP Cmdlets
            $errMsg = ($_system_translations.GenericErrorMsg -f $err.ToString(), $err.Exception.ErrorData.error_WindowsErrorMessage, $err.Exception.ErrorData.error_Code)
            $err.ErrorDetails = $errMsg
            $PSCmdlet.WriteError($err)            
        }
        else {
            $PSCmdlet.WriteError($err)            
        }
    }
    else
    {
        if ($BackupTaken) {
            Write-Warning ($_system_translations.War_RestoreDhcpDatabase -f ${BackupPath})
        }    
        $PSCmdlet.ThrowTerminatingError($err)        
    }
}

# Prepares a ErrorRecord Object and calls ExportDhcpServer/ImportDhcpServer to Post NTE
function PostNteString([string]$errMessage, [string] $errorId=$EC_InvalidOperation, [System.Management.Automation.ErrorCategory]$errorCategory=$EC_InvalidOperation, [Object] $targetObject=$null)
{ 
    $exception = New-Object System.Exception $errMessage
    $err = New-Object System.Management.Automation.ErrorRecord  ( 
                                $exception,
                                $errorId,
                                $errorCategory,
                                $targetObject 
                             )            
    
    if ($script:IsExport) { ExportDhcpServer $err $false }
    else { ImportDhcpServer $err $false }
}

# Prepares a ErrorRecord Object and calls ExportDhcpServer/ImportDhcpServer to throw TE
function ThrowTEString([string]$errMessage, [string] $errorId=$EC_InvalidOperation, [System.Management.Automation.ErrorCategory]$errorCategory=$EC_InvalidOperation, [Object] $targetObject=$null)
{ 
    $exception = New-Object System.Exception $errMessage
    $err = New-Object System.Management.Automation.ErrorRecord  ( 
                                $exception,
                                $errorId,
                                $errorCategory,
                                $targetObject 
                             )            
    
    if ($script:IsExport) { ExportDhcpServer $err $true }
    else { ImportDhcpServer $err $true }
}

# Pass the ErrorRecord objects as returned as a result of executing internal cmdlets to ExportDhcpServer/ImportDhcpServer to Post NTE
function PostNteObject($errorObj)
{        
    if (NotNull $errorObj ) {        
        if (($errorObj -is [System.Collections.ArrayList]) -or ($errorObj -is [Array])) {
            foreach ($err in $errorObj){                
                if ($script:IsExport) { ExportDhcpServer $err $false}
                else { ImportDhcpServer $err $false}
            }
        }
        else {                                                    
            if ($script:IsExport) { ExportDhcpServer $errorObj $false}
            else { ImportDhcpServer $errorObj $false}
        }
    }
}

# Helper function to write trace messages only when $global:TraceMessage is set to $true
function WriteTraceMessage([string] $message, [bool]$isRed=$false) {
    if ($global:TraceMessage) {
        Write-Host -ForegroundColor ([System.ConsoleColor]::Cyan) $message
    }
}

# Helper function to write trace messages for different Export variables
function WriteExportInputValue()
{
    WriteTraceMessage "File             : ${File}"
    WriteTraceMessage "RFile            : $script:ExportFile"
    WriteTraceMessage "ScopeId          : ${ScopeId}"
    WriteTraceMessage "Prefix           : ${Prefix}"
    WriteTraceMessage "Leases           : ${Leases}"
    WriteTraceMessage "ComputerName     : ${ComputerName}"
    WriteTraceMessage "RComputerName    : $script:DhcpServerName"
    if (NotNull ${CimSession}) {$cimSession = ${CimSession}.ComputerName } else { $cimSession = "NULL" }
    WriteTraceMessage "CimSession       : $cimSession"
    WriteTraceMessage "ProcessEntryCount: $script:ProcessEntryCount" 
    WriteTraceMessage ""
}

#endregion

#region LocalizedString

# Localized strings

data _system_translations {
   ConvertFrom-StringData @'
    # fallback text goes here 
    
    #Error Msg
ExportedFileExists= File {0} already exists.
InvalidIPv4ScopeAddress= ScopeID {0} is not a valid IPv4 address.
InvalidIPv6ScopeAddress= Prefix {0} is not a valid IPv6 address.
NothingToExport= Nothing is exported. File {0} is not created.
ImportedVersionMismatch= The functionality is not available on this server version. Version of DHCP server is {0}.{1}.
ImportedFileVersionMismatch= The DHCP server version {0}.{1} is not compatible with the file version {2}.{3}.
ImportFileDoesNotExist= File {0} does not exists.
ErrInputScopeNotInImportFile= Input scope {0} is not present in the specified file {1}.
GenericErrorMsg= {0} : {1}({2})
ErrXmlValidationFailed= XML schema validation for {0} failed. Please ensure that import file {0} is valid as per the XML schema in {1}. {2}
ErrServerConfigGivenWithScopePrefix= ScopeId/Prefix cannot be specified when ServerConfigOnly is specified.
ErrServerConfigGivenWithLeases= Leases cannot be specified when ServerConfigOnly is specified.
ErrServerConfigGivenWithScopeOverwrite= ScopeOverwrite cannot be specified when ServerConfigOnly is specified.
ErrFilePathInvalid= Invalid path {0}. {1}

    #ShouldProcess/ShouldContinue Messages
Msg_Export_DhcpServer_1= The configuration (and leases) for the scope(s) {0} on server {1} will be exported to the file {2}.
Msg_Export_DhcpServer_2= The configuration (and leases) on server {0} will be exported to the file {1}.
Msg_Export_DhcpServer_3= The configuration for the scope(s) {0} on server {1} will be exported to the file {2}.
Msg_Export_DhcpServer_4= The configuration on server {0} will be exported to the file {1}.
Msg_Import_DhcpServer_1= The configuration (and leases) for following scopes will be imported from the file {0} to server {1}: {2}.{3}
Msg_Import_DhcpServer_2= The configuration (and leases) from the file {0} will be imported to server {1}.{2}
Msg_Import_DhcpServer_3= The configuration for following scopes will be imported from the file {0} to server {1}: {2}.{3}
Msg_Import_DhcpServer_4= The configuration from the file {0} will be imported to server {1}. {2}
ShoudContinueCaption= Confirm
ShoudContinueConfirmation= Do you want to perform this action?

    #Export Verbose Msg
Ver_Export_Start= Exporting configuration from server {0} to file {1}.
Ver_Export_Classes= Exporting classes from server...
Ver_Export_OptDef= Exporting option definitions from server...
Ver_Export_Server_OptValue= Exporting server wide option values...
Ver_Export_Server_Pol_OptValue= Exporting server wide option values from policy {0}...
Ver_Export_Scope_OptValue= Exporting option values from scope {0}...
Ver_Export_Rsvation_OptValue= Exporting option values from reservation {0}...
Ver_Export_Scope_Pol_OptValue= Exporting option values from policy {0} of scope {1}...
Ver_Export_Server_Policy= Exporting server wide policies...
Ver_Export_Server_Filter= Exporting Link Layer Filters...
Ver_Export_Scope= Exporting scope {0} from server {1}...
Ver_Export_Scope_ExRanges= Exporting exclusion ranges from scope {0}...
Ver_Export_Scope_Policy= Exporting policies from scope {0}...
Ver_Export_Scope_Rsvation= Exporting reservations from scope {0}. This operation may take some time.
Ver_Export_Scope_ExRange= Exporting exclusion ranges from scope {0}...
Ver_Export_Scope_Lease= Exporting leases from scope {0}. This operation may take some time.
Ver_Export_End= Export operation on server {0} completed.

    #Import Verbose Msg
Ver_Import_Started= Importing configuration on server {0} from file {1}.
Ver_Import_Backup= Dhcp Server database has been backed up at {0} on {1}.
Ver_Import_Classes= Importing classes on server...
Ver_Import_OptDef= Importing option definitions on server...
Ver_Import_Server_OptVal= Importing server wide option values...
Ver_Import_Server_Pol_OptVal= Importing server wide option values for policy {0}...
Ver_Import_Scope_OptVal= Importing option values for scope {0}...
Ver_Import_Rsvation_OptVal= Importing option values for reservation {0}...
Ver_Import_Scope__PolOptVal= Importing option values for policy {0} to scope {1}...
Ver_Import_Server_OptVal_Del= Deleting server wide option values...
Ver_Import_Scope_OptVal_Del= Deleting existing option values from scope {0}...
Ver_Import_Scope_ExRange= Importing exclusion ranges to scope {0}...
Ver_Import_Scope_ExRange_Del= Deleting existing exclusion ranges in scope {0}...
Ver_Import_Rsvation_OptVal_Del= Deleting existing option values on reservation {0}...
Ver_Import_Server_Policy= Importing server wide policies...
Ver_Import_Scope_Policy= Importing policies to scope {0}...
Ver_Import_Server_Policy_Del= Deleting server wide policies...
Ver_Import_Scope_Policy_Del= Deleting existing policies in scope {0}...
Ver_Import_Server_Filter_Del= Deleting link layer filters...
Ver_Import_Server_Filter= Importing link layer filters...
Ver_Import_Scope= Importing scope {0} on server {1}...
Ver_Import_Scope_Rsvation= Importing reservations to scope {0}. This operation may take some time.
Ver_Import_Scope_Leases= Importing leases to scope {0}. This operation may take some time.
Ver_Import_Scope_Del= Deleting existing scope {0} on server {1}...
Ver_Import_Scope_Rsvation_Del= Deleting existing reservations in scope {0}...
Ver_Import_End= Import operation on server {0} completed.
Ver_Import_Scope_Exists_1= Scope {0} exists on server {1}. This scope will be overwritten with data in the import file.
War_Import_Scope_Exists_2= Scope {0} exists on server {1}. This scope will not be imported.
Ver_Import_Scope_Exists_3= Scope {0} exists on server {1}. This scope will be deleted and imported from the data in the import file.

Ver_Import_ClassAlreadyExist= Class '{0}' of type {1} already exists on server {2} and will not be changed.
Ver_Import_OptDefAlreadyExist= Option definition {0} already exists on server {1} and will not be changed.

War_RestoreDhcpDatabase= To restore the DHCP server configuration to the previous state, restore the DHCP database from {0}.
War_ImportOptValueServerLevelWithoutValue= Server wide option value {0} was not imported on server {1} because it did not have any value associated with it.
War_ImportOptValueServerPolicyLevelWithoutValue= Server wide option value {0} for policy {1} was not imported on server {2} because it did not have any value associated with it.
War_ImportOptValueScopeLevelWithoutValue= Option value {0} for scope {1} was not imported on server {2} because it did not have any value associated with it.
War_ImportOptValueReservationLevelWithoutValue= Option value {0} for reservation {1} was not imported on server {2} because it did not have any value associated with it.
War_ImportOptValueScopePolicyLevelWithoutValue= Option value {0} for policy {1} of scope {2} was not imported on server {3} because it did not have any value associated with it.
'@
}

Import-LocalizedData -BindingVariable _system_translations -filename DhcpServerMigration.psd1

#endregion

#region Constants

#Constants used

New-Variable -Option constant -Name Win8MajorVersion                    -Value 6
New-Variable -Option constant -Name Win8MinorVersion                    -Value 2
New-Variable -Option constant -Name Win9MinorVersion                    -Value 3
New-Variable -Option constant -Name Win2K8R2MinorVersion                -Value 1
New-Variable -Option constant -Name DhcpSchemaName                      -Value "http://schemas.microsoft.com/windows/DHCPServer"
New-Variable -Option constant -Name DhcpSchemaFile                      -Value ($env:windir + "\System32\WindowsPowerShell\v1.0\Modules\DhcpServer\DhcpServerSchema.xml")
New-Variable -Option constant -Name CompleteDhcpServer                  -Value 0
New-Variable -Option constant -Name SpecificV4AndV6Scopes               -Value 1
New-Variable -Option constant -Name SpecificV4Scopes                    -Value 2
New-Variable -Option constant -Name SpecificV6Scopes                    -Value 3
New-Variable -Option constant -Name EC_ResourceExists                   -Value "ResourceExists"
New-Variable -Option constant -Name EC_InvalidArgument                  -Value "InvalidArgument"
New-Variable -Option constant -Name EC_InvalidOperation                 -Value "InvalidOperation"
New-Variable -Option constant -Name EC_ResourceUnavailable              -Value "ResourceUnavailable"

#XML Tags
New-Variable -Option constant -Name XmlRootNode                         -Value "DHCPServer"
New-Variable -Option constant -Name MajorVersionElement                 -Value "MajorVersion"
New-Variable -Option constant -Name MinorVersionElement                 -Value "MinorVersion"
New-Variable -Option constant -Name IPv4Element                         -Value "IPv4"
New-Variable -Option constant -Name IPv6Element                         -Value "IPv6"
New-Variable -Option constant -Name ConflictDetAttemptsElement          -Value "ConflictDetectionAttempts"
New-Variable -Option constant -Name NapEnabledElement                   -Value "NapEnabled"
New-Variable -Option constant -Name NpsUnreachableActionElement         -Value "NpsUnreachableAction"
New-Variable -Option constant -Name ActivatePoliciesElement             -Value "ActivatePolicies"
New-Variable -Option constant -Name ClassesElement                      -Value "Classes"
New-Variable -Option constant -Name ClassElement                        -Value "Class"
New-Variable -Option constant -Name OptDefsElement                      -Value "OptionDefinitions"
New-Variable -Option constant -Name OptDefElement                       -Value "OptionDefinition"
New-Variable -Option constant -Name OptValuesElement                    -Value "OptionValues"
New-Variable -Option constant -Name OptValueElement                     -Value "OptionValue"
New-Variable -Option constant -Name PoliciesElement                     -Value "Policies"
New-Variable -Option constant -Name PolicyElement                       -Value "Policy"
New-Variable -Option constant -Name FiltersElement                      -Value "Filters"
New-Variable -Option constant -Name FilterElement                       -Value "Filter"
New-Variable -Option constant -Name FilterListAllowElement              -Value "Allow"
New-Variable -Option constant -Name FilterListDenyElement               -Value "Deny"
New-Variable -Option constant -Name ScopesElement                       -Value "Scopes"
New-Variable -Option constant -Name ScopeElement                        -Value "Scope"
New-Variable -Option constant -Name IPRangesElement                     -Value "IPRanges"
New-Variable -Option constant -Name ExclusionRangesElement              -Value "ExclusionRanges"
New-Variable -Option constant -Name IPRangeElement                      -Value "IPRange"
New-Variable -Option constant -Name StartIPRangeElement                 -Value "StartRange"
New-Variable -Option constant -Name EndIPRangeElement                   -Value "EndRange"
New-Variable -Option constant -Name ReservationsElement                 -Value "Reservations"
New-Variable -Option constant -Name ReservationElement                  -Value "Reservation"
New-Variable -Option constant -Name LeasesElement                       -Value "Leases"
New-Variable -Option constant -Name LeaseElement                        -Value "Lease"
New-Variable -Option constant -Name StatelessElement                    -Value "StatelessStore"
New-Variable -Option constant -Name StatelessEnabledElement             -Value "Enabled"
New-Variable -Option constant -Name StatelessPurgeIntervalElement       -Value "PurgeInterval"

$ClassPropertiesMandatory           = @("Name", "Type", "Data")
$ClassPropertiesOptional            = @("Description", "VendorId")
$OptDefPropertiesMandatory          = @("Name", "OptionId", "Type", "MultiValued")
$OptDefPropertiesOptional           = @("DefaultValue", "Description", "VendorClass")
$OptValuePropertiesMandatory        = @("OptionId")
$OptValuePropertiesOptional         = @("Value", "VendorClass", "UserClass")
$PolicyPropertiesMandatory          = @("Name", "ProcessingOrder", "Enabled", "Condition")
$PolicyPropertiesOptional           = @("Description", "VendorClass", "UserClass", "MacAddress", "ClientId", "RelayAgent", "CircuitId", "RemoteId", "SubscriberId", "Fqdn", "DnsSuffix")
$FilterPropertiesMandatory          = @("List", "MacAddress")
$FilterPropertiesOptional           = @("Description")
$Scopev4PropertiesMandatory         = @("ScopeId", "Name", "SubnetMask", "StartRange", "EndRange", "LeaseDuration", "State", "Type", "MaxBootpClients", "NapEnable")
$Scopev4PropertiesOptional          = @("Delay", "NapProfile", "Description", "ActivatePolicies", "SuperScopeName")
$Scopev6PropertiesMandatory         = @("Prefix", "Name", "Preference", "State")
$Scopev6PropertiesOptional          = @("PreferredLifeTime", "ValidLifeTime", "T1", "T2", "Description")
$ReservationPropertiesMandatory     = @("Name", "IPAddress")
$ReservationPropertiesOptional      = @("ClientId", "Type", "ClientDuid", "IAID", "Description")
$LeasePropertiesMandatory           = @("IPAddress", "ScopeId", "ClientId", "AddressState", "ClientType", "NapCapable")
$LeasePropertiesOptional            = @("DnsRR", "DnsRegistration", "LeaseExpiryTime", "ProbationEnds", "NapStatus", "HostName", "PolicyName", "Description")      
$Leasev6PropertiesMandatory         = @("IPAddress", "ClientDuid", "IAID", "AddressType")
$Leasev6PropertiesOptional          = @("HostName", "LeaseExpiryTime", "Description")

#endregion

#region ScriptVariable
[bool]$global:TraceMessage          = $false
#endregion

Set-StrictMode -Version 3
Export-ModuleMember Export-DhcpServer, Import-DhcpServer
