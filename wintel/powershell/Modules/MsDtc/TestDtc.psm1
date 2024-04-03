Import-Module netsecurity

$Strings = DATA {
    @{ 
        FirewallRuleEnabled = "{0}: Firewall rule for {1} is enabled."
        FirewallRuleDisabled = "{0}: Firewall rule for {1} is disabled. This computer cannot participate in network transactions."
        CmdletFailed = "The {0} cmdlet failed. Please make sure the {1} module is installed."
        InvalidLocalComputer = "{0} is not a valid local computer name."
        RPCEndpointMapper = "RPC Endpoint Mapper"
        DtcIncomingConnection = "DTC incoming connections"
        DtcOutgoingConnection = "DTC outgoing connections"
        MatchingDtcNotFound = "A DTC instance with VirtualServerName {0} does not exist."
        InboundDisabled = "{0}: Inbound transactions are not allowed and this computer cannot participate in network transactions."
        OutboundDisabled = "{0}: Outbound transactions are not allowed and this computer cannot participate in network transactions."
        OSVersion = "{0} Operating System Version: {1}."
        OSQueryFailed = "Failed to query operating system of {0}."
        VersionNotSupported = "Testing DTC on Windows versions below {0} is not supported with this cmdlet."
        FailedToCreateCimSession = "Failed to create a CIM Session to {0}."
        NotARemoteComputer = "{0} is not a remote computer."
        PingingSucceeded = "Pinging computer {0} from {1} succeeded. "
        PingingFailed = "Pinging computer {0} from {1} failed."
        SameCids = "The {0} CID on {1} and {2} is the same. The CID should be unique to each computer."
        DiagnosticTestPrompt = "This diagnostic test will attempt to carry out a transaction propagation between {0} and {1}. It requires that a TCP port is opened on {0} so that a Test Resource Manager can participate in network transactions."
        DefaultPortDescription = "The default port is {0} and you can change it using the 'ResourceManagerPort' parameter and rerunning the test. "
        PortDescription = "You have specified {0} as the 'ResourceManagerPort'."
        FirewallRequest = "Please open port {0} in the firewall to proceed with the test."
        QueryText = "Do you want to proceed with the test?"
        InvalidDefaultCluster = "{0} is not the Virtual Server Name of the default DTC configured on this computer. You can use 'Set-DtcClusterDefault' cmdlet configure the default DTC on this computer."
        InvalidDefault = "{0} is not the Virtual Server Name of the default DTC configured on this computer. You can use 'Set-DtcDefault' cmdlet to configure the default DTC on this computer."
        NeedDtcSecurityFix = "DTC security settings and firewall settings should be fixed in order to complete the transactions propagation test."
        StartResourceManagerFailed = "Test resource manager creation failed."
        ResourceManagerStarted = "Test resource manager started."
        PSSessionCreated = "A new PSSession to {0} created."
        TransactionPropagated = "Transaction propagated from {0} to {1} using {2} propagation."
        TransactionPropagationFailed = "Transaction propagation {0} to {1} failed using {2} propagation."
        TestRMVerboseLog = "Test Resource Manager Verbose Log:"
        TestRMWarningLog = "Test Resource Manager Warning Log:"
        InvalidParameters = "At least one of LocalComputerName or RemoteComputerName parameters should be specified."
    }
}


function IsLocalComputer
{
    param(
        $computerName = $null
        )
    PROCESS 
    {
        $found = $false
        $dtcs = Get-Dtc
        if ($dtcs -eq $null)
        {
            throw
        }
        else
        {
            if ($dtcs.GetType().IsArray)
            {
                foreach ($dtc in $dtcs)
                {
                    if ([string]::Compare($dtc.VirtualServerName, $computerName, $true) -eq 0)
                    {
                        $found = $true
                        break 
                    }
                }
            }
            else
            {
                if ([string]::Compare($dtcs.VirtualServerName, $computerName, $true) -eq 0)
                {
                    $found = $true
                }
            }
        }
        return $found
    }
}

function CheckFirewallRule
{
    param(
        $computerName = $null,
        $ruleId = $null,
        $ruleDesription = $null
    )
    PROCESS 
    {
        $success = $false
        $errorVariable = $null
        if ($computerName -eq $null)
        {
            $rule = Get-NetFirewallRule -ID $ruleId  -ErrorVariable errorVariable    
        }
        else
        {
            $rule = Get-NetFirewallRule -ID $ruleId -CimSession  $computerName  -ErrorVariable errorVariable    
        }

        if ($rule -eq $null)
        {
            if ($errorVariable -ne $null)
            {
                throw $errorVariable
            }
            else
            {
                throw ([string]::Format($Strings.CmdletFailed, "Get-NetFirewallRule", "networksecurity"))
            }
    
        }
        else
        {
            if ($rule.Enabled -eq 1)
            {
                Write-Verbose ([string]::Format($Strings.FirewallRuleEnabled, $computerName, $ruleDesription))
                $success = $true
            }
            else
            {
                Write-Warning ([string]::Format($Strings.FirewallRuleDisabled, $computerName, $ruleDesription))
            }
        }
        return $success
    }    
}

function CheckFirewallRules
{ 
    param(
        $ComputerName = $null
        )   
    $rpcEPRuleId = "MSDTC-RPCSS-In-TCP"
    $dtcOutRule = "MSDTC-Out-TCP"
    $dtcInRule = "MSDTC-In-TCP"
   
    $rpcOutcss = CheckFirewallRule $ComputerName $rpcEPRuleId $Strings.RPCEndpointMapper
    $dtcIn = CheckFirewallRule $ComputerName $dtcInRule $Strings.DtcIncomingConnection
    $dtcOut = CheckFirewallRule $ComputerName $dtcOutRule $Strings.DtcOutgoingConnection

    return ($rpcOutcss -and $dtcOutRule -and $dtcInRule)
}

function FindDtc
{
    param(
        $ComputerName = $null,
        $CimSession = $null
        )   
        
    $matchedDtc = $null
    $errorVariable = $null
    if ($cimsession -eq $null)
    {
        $dtcs = Get-Dtc -ErrorVariable $errorVariable
    }
    else
    {
        $dtcs = Get-Dtc -CimSession $CimSession -ErrorVariable errorVariable
    }

    if ($dtcs -eq $null)
    {
        if ($errorVariable -ne $null)
        {
            throw $errorVariable
        }
        else
        {
            throw ([string]::Format($Strings.CmdletFailed, "Get-Dtc", "MSDTC"))
        }
    }
    else
    {
        if ($dtcs.GetType().IsArray -eq $true)
        {
            foreach ($dtc in $dtcs)
            {
                if ($dtc.VirtualServerName -eq $computerName)
                {
                    $matchedDtc = $dtc
                    break
                }
            }
        }
        else
        {
            $matchedDtc = $dtcs
        }
    }

    if ($matchedDtc -eq $null)
    {
        throw ([string]::Format($Strings.MatchingDtcNotFound, $computerName))
    }

    return $matchedDtc
}

function CheckDtcSecurity
{ 
    param(
        $DtcNetworkSetting = $null,
        $ComputerName = $nul
        )   
    PROCESS 
    {
        Write-Verbose ([string]::Format("{0}: AuthenticationLevel: {1}", $ComputerName, $DtcNetworkSetting.AuthenticationLevel))
        Write-Verbose ([string]::Format("{0}: InboundTransactionsEnabled: {1}", $ComputerName, $DtcNetworkSetting.InboundTransactionsEnabled))
        if ($DtcNetworkSetting.InboundTransactionsEnabled -eq $false)
        {
            Write-Warning ([string]::Format($Strings.InboundDisabled, $ComputerName))
        }

        Write-Verbose ([string]::Format("{0}: OutboundTransactionsEnabled: {1}", $ComputerName, $DtcNetworkSetting.OutboundTransactionsEnabled))
        if ($DtcNetworkSetting.OutboundTransactionsEnabled -eq $false)
        {
            Write-Warning ([string]::Format($Strings.OutboundDisabled, $ComputerName))
        }

        Write-Verbose ([string]::Format("{0}: RemoteClientAccessEnabled: {1}", $ComputerName, $DtcNetworkSetting.RemoteClientAccessEnabled))
        Write-Verbose ([string]::Format("{0}: RemoteAdministrationAccessEnabled: {1}", $ComputerName, $DtcNetworkSetting.RemoteAdministrationAccessEnabled))
        Write-Verbose ([string]::Format("{0}: XATransactionsEnabled: {1}", $ComputerName, $DtcNetworkSetting.XATransactionsEnabled))
        Write-Verbose ([string]::Format("{0}: LUTransactionsEnabled: {1}", $ComputerName, $DtcNetworkSetting.LUTransactionsEnabled))

        return $DtcNetworkSetting.InboundTransactionsEnabled -and $DtcNetworkSetting.OutboundTransactionsEnabled
    }    
}


function DoPingTest
{
    param(
        $ToComputerName = $null,
        $FromComputerName = $null
        )
    
        
        $filter = "Address='$ToComputerName'"
        $pingingResult = Get-WmiObject -Class Win32_PingStatus -Filter $filter -ComputerName $FromComputerName

        if ($pingingResult.StatusCode -eq 0)
        {
            Write-Verbose ([string]::Format($Strings.PingingSucceeded, $ToComputerName, $FromComputerName))
            return $true;
        }
        else
        {
            Write-Warning ([string]::Format($Strings.PingingFailed, $ToComputerName, $FromComputerName))
            return $false;
        }
}

function CompareCids
{
    param(
        $LocalDtc = $null,
        $RemoteDtc = $null
        )

        Write-Verbose ([string]::Format("{0}: OleTx: {1}", $LocalDtc.VirtualServerName, $LocalDtc.OleTxEndpointCid))
        Write-Verbose ([string]::Format("{0}: OleTx: {1}", $RemoteDtc.VirtualServerName, $RemoteDtc.OleTxEndpointCid))
        if ([string]::Compare($LocalDtc.OleTxEndpointCid, $RemoteDtc.OleTxEndpointCid, $true) -eq 0)
        {
            throw ([string]::Format($Strings.SameCids, "OleTx", $LocalDtc.VirtualServerName, $RemoteDtc.VirtualServerName))
        }
        Write-Verbose ([string]::Format("{0}: XA: {1}", $LocalDtc.VirtualServerName, $LocalDtc.XAEndpointCid))
        Write-Verbose ([string]::Format("{0}: XA: {1}", $RemoteDtc.VirtualServerName, $RemoteDtc.XAEndpointCid))
        if ([string]::Compare($LocalDtc.XAEndpointCid, $RemoteDtc.XAEndpointCid, $true) -eq 0)
        {
            throw ([string]::Format($Strings.SameCids, "XA", $LocalDtc.VirtualServerName, $RemoteDtc.VirtualServerName))
        }
        Write-Verbose ([string]::Format("{0}: UIS: {1}", $LocalDtc.VirtualServerName, $LocalDtc.UisEndpointCid))
        Write-Verbose ([string]::Format("{0}: UIS: {1}", $RemoteDtc.VirtualServerName, $RemoteDtc.UisEndpointCid))
        if ([string]::Compare($LocalDtc.UisEndpointCid, $RemoteDtc.UisEndpointCid, $true) -eq 0)
        {
            throw ([string]::Format($Strings.SameCids, "UIS", $LocalDtc.VirtualServerName, $RemoteDtc.VirtualServerName))
        }
}

function CheckIfDefaultDtcConfigured
{
   param(
        $ComputerName = $null,
        $Cimsession = $null
        )

    $errorVariable = $null
    $cluster = $false
    if ($Cimsession -eq $null)
    {
        $dtcs = Get-Dtc -ErrorVariable errorVariable
    }
    else
    {
        $dtcs = Get-Dtc -ErrorVariable errorVariable -CimSession $Cimsession
    }

    if ($dtcs -eq $null)
    {
        if ($errorvariable -ne $null)
        {
            throw $errorVariable
        }
        else
        {
            throw ([string]::Format($Strings.CmdletFailed, "Get-Dtc","MSDTC"))
        }
    }
    $errorVariable = $null
    if ($dtcs.GetType().IsArray)
    {
        $cluster = $true
        if ($Cimsession -eq $null)
        {
            $defaultDtc = Get-DtcClusterDefault -ErrorVariable errorVariable        
        }
        else
        {
            $defaultDtcResource = Get-DtcClusterDefault -ErrorVariable errorVariable -CimSession $Cimsession
        }

        foreach ($dtc in $dtcs)
        {
            if ([string]::Compare($dtc.DtcName, $defaultDtcResource, $true) -eq 0)
            {
                $defaultDtc = $dtc.VirtualServerName
            }
        }
        
    }
    elseif ([string]::Compare($dtcs.DtcName, "Local", $true) -ne 0)
    {
        $cluster = $true
        #there is only one dtc instance and it is clustered        
        $defaultDtc = $dtc.VirtualServerName
    }
    else
    {
    
        if ($Cimsession -eq $null)
        {
            $defaultDtc = Get-DtcDefault -ErrorVariable errorVariable        
        }
        else
        {
            $defaultDtc = Get-DtcDefault -ErrorVariable errorVariable -CimSession $Cimsession
        }
        
    }

    if ($defaultDtc -eq $null)
    {
        if ($errorvariable -ne $null)
        {
            throw $errorVariable
        }
        else
        {
            if ($cluster -eq $true)
            {
                throw ([string]::Format($Strings.CmdletFailed, "Get-DtcClusterDefault", "MSDTC"))            
            }
            else
            {
                throw ([string]::Format($Strings.CmdletFailed, "Get-DtcDefault", "MSDTC"))            
            }
        }
    }
    else
    {        
        if ([string]::Compare($defaultDtc, $ComputerName, $true) -ne 0)
        {
            if ($cluster -eq $true)
            {
                throw ([string]::Format($Strings.InvalidDefaultCluster, $ComputerName))           
            }
            else
            {
                throw ([string]::Format($Strings.InvalidDefault, $ComputerName))            
            }
        }
    }
}

function DoPingTest
{
    param(
        $ToComputerName = $null,
        $FromComputerName = $null
        )    
        
        $filter = "Address='$ToComputerName'"
        $pingingResult = Get-WmiObject -Class Win32_PingStatus -Filter $filter -ComputerName $FromComputerName

        if ($pingingResult.StatusCode -eq 0)
        {
            Write-Verbose ([string]::Format($Strings.PingingSucceeded, $ToComputerName, $FromComputerName))
            return $true;
        }
        else
        {
            Write-Warning ([string]::Format($Strings.PingingFailed, $ToComputerName, $FromComputerName))
            return $false;
        }
}

function IsVersionSupported
{
   param(
        $ComputerName = $null
        )
 
    $minSupportedVersion = New-Object -TypeName System.Version -ArgumentList "6.2"
    $errorVariable = $null
    $operatngSystem = Get-WmiObject  -ComputerName $ComputerName -Class WIn32_OperatingSystem -ErrorVariable errorVariable
    if ($operatngSystem -eq $null)
    {
        if ($errorVariable -ne $null)
        {
            throw $errorVariable
        }
        else
        {
            throw ([string]::Format($Strings.OSQueryFailed, $ComputerName))
        }
    }
    else
    {
        $version = New-Object -TypeName System.Version -ArgumentList $operatngSystem.Version
        Write-Verbose ([string]::Format($Strings.OSVersion, $ComputerName, $version))
        if ($version -ge $minSupportedVersion)
        {            
            return $true;
        }
        else
        {
            return $false;
        }
    }
}

function TestLocalComputer
{
    param(
        $ComputerName = $null
        )
    PROCESS 
    {
        $errorVariable = $null
        $firewallOK = CheckFirewallRules $null
        $dtc = FindDtc $ComputerName $null
        $networkSetting = Get-DtcNetworkSetting -DtcName $dtc.DtcName -ErrorVariable errorVariable
        if ($networkSetting -eq $null)
        {
            if ($errorVariable -ne $null)
            {
                throw $errorVariable
            }
            else
            {
                throw ([string]::Format($Strings.CmdletFailed, "Get-DtcNetworkSetting", "MSDTC"))
            }
        }
        $networkOk = CheckDtcSecurity $networkSetting $ComputerName
        return $networkOk -and $firewallOK
    }   
}

function TestRemoteComputer
{
    param(
        $ComputerName = $null,
        $CimSession = $null
        )
    PROCESS 
    {
        if ((IsVersionSupported $ComputerName) -eq $false)
        {
            throw ([string]::Format($Strings.VersionNotSupported, "6.2"))
        }          
        
        $firewallOK = CheckFirewallRules $ComputerName
        $dtc = FindDtc $ComputerName $CimSession
        $networkSetting = Get-DtcNetworkSetting -DtcName $dtc.DtcName -CimSession $CimSession -ErrorVariable errorVariable
        if ($networkSetting -eq $null)
        {
            if ($errorVariable -ne $null)
            {
                throw $errorVariable
            }
            else
            {
                throw ([string]::Format($Strings.CmdletFailed, "Get-DtcNetworkSetting", "MSDTC"))
            }
        }

        $networkOk = CheckDtcSecurity $networkSetting $ComputerName
        return $networkOk -and $firewallOK
        
    }   
}

function TestTransactionsPropagation
{
    param(
        $LocalComputerName = $null,
        $RemoteComputerName = $null,
        $ResourceManagerPort = $null
        )

    $rm = $null;
    $pssession = $null;
    try
    {      
        $errorVariable   
        $rm = Start-DtcDiagnosticResourceManager -Port $ResourceManagerPort -ErrorVariable errorVariable
        if ($rm -eq $null)
        {
            if ($errorVariable -ne $null)
            {
                throw $errorVariable
            }
            else
            {
                throw ([string]::Format($Strings.StartResourceManagerFailed))
            }
        }

        Write-Verbose $Strings.ResourceManagerStarted    
        
        $pssession = New-PSSession -ComputerName $RemoteComputerName
        Write-Verbose ([string]::Format($Strings.PSSessionCreated, $RemoteComputerName))

        
        Invoke-Command -Session $pssession -ScriptBlock {Import-Module msdtc} -ErrorVariable errorVariable
        if ($errorVariable -ne $null)
        {
            throw $errorVariable
        }        

        $errorVariable = $null
        $tx = Invoke-Command -Session $pssession -ScriptBlock {Receive-DtcDiagnosticTransaction -ComputerName $args[0] -Port $args[1] -PropagationMethod Pull}  -args $LocalComputerName,$ResourceManagerPort -ErrorVariable errorVariable
 
        if ($tx -eq $null)
        {
            if ($errorVariable -ne $null)
            {
                throw $errorVariable
            }
            else
            {
                throw ([string]::Format($Strings.TransactionPropagationFailed, $LocalComputerName, $RemoteComputerName, "PULL"))
            }
        }

        Write-Verbose ([string]::Format($Strings.TransactionPropagated, $LocalComputerName, $RemoteComputerName, "PULL"))

        $tx = $null        
        $tx=Invoke-Command -Session $pssession -ScriptBlock {Receive-DtcDiagnosticTransaction -ComputerName $args[0] -Port $args[1] -PropagationMethod Push} -args $LocalComputerName,$ResourceManagerPort -ErrorVariable errorVariable
        if ($tx -eq $null)
        {
            if ($errorVariable -ne $null)
            {
                throw $errorVariable
            }
            else
            {
                throw ([string]::Format($Strings.TransactionPropagationFailed, $LocalComputerName, $RemoteComputerName, "PUSH"))
            }        
        }

        Write-Verbose ([string]::Format($Strings.TransactionPropagated, $LocalComputerName, $RemoteComputerName, "PUSH"))
     }
     finally
     {
        if ($rm -ne $null)
        {
            Write-Verbose $Strings.TestRMVerboseLog
            foreach ( $verbose in $rm.Verbose)
            {
                Write-Verbose $verbose
            }

            if ($rm.Warning -ne $null)
            {
                Write-Warning $Strings.TestRMWarningLog
                foreach ( $warning in $rm.Warning)
                {
                    Write-Warning $warning
                }
            }
            Stop-DtcDiagnosticResourceManager -Job $rm
        }
        
        if ($pssession -ne $null)
        {
            Remove-PSSession $pssession
        }
     } 
}

# .Link 
# http://go.microsoft.com/fwlink/?LinkID=253754
# .ExternalHelp TestDtc.psm1-help.xml
function Test-Dtc {
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Low"
    )]
    [cmdletbinding(PositionalBinding=$false)]

    param(        
        [ValidateNotNullOrEmpty()]
        [string]
        $LocalComputerName = $null,
                
        [ValidateNotNullOrEmpty()]                
        [string]
        $RemoteComputerName = $null,

        [ValidateNotNullOrEmpty()]
        [int]        
        [ValidateRange(0, 65535)]
        $ResourceManagerPort = $null
    )
    BEGIN {
    }
    PROCESS {
        Import-LocalizedData -bindingVariable Strings  -ErrorAction SilentlyContinue

        if ([string]::IsNullOrEmpty($LocalComputerName))
        {
            if ([string]::IsNullOrEmpty($RemoteComputerName))
            {
                throw $Strings.InvalidParameters
            }
            else
            {
                if (IsLocalComputer $RemoteComputerName)
                {
                   throw ([string]::Format($Strings.NotARemoteComputer, $RemoteComputerName))
                }
                
                $errorvariabe = $null         
                $cimSession = New-CimSession -ComputerName $RemoteComputerName
                if ($cimSession -eq $null)
                {
                    throw ([string]::Format($Strings.FailedToCreateCimSession, $ComputerName))
                }
                try
                {
                    $remoteTest = TestRemoteComputer $RemoteComputerName $cimSession
                }
                finally
                {
                    Remove-CimSession -CimSession $cimSession
                }
            }        
        }
        else
        {
            if ([string]::IsNullOrEmpty($RemoteComputerName))
            {
                if (IsLocalComputer $LocalComputerName)
                {
                   $localTest = TestLocalComputer $LocalComputerName
                }
                else
                {
                   throw ([string]::Format($Strings.InvalidLocalComputer, $LocalComputerName))
                }
            }
            else
            {
                if ((IsLocalComputer $LocalComputerName) -eq $false)
                {
                   throw ([string]::Format($Strings.InvalidLocalComputer, $LocalComputerName))
                }
                    
                $DefaultResourceManagerPort = 3002
                $remoteComputerTestable = $false
                $localToRemotePinging = $false
                $remoteToLocalPinging = $false
                $localComputerTestable = $false
                $port = $DefaultResourceManagerPort

                $localComputerTestable = TestLocalComputer $LocalComputerName

                if (IsLocalComputer $RemoteComputerName)
                {
                   throw ([string]::Format($Strings.NotARemoteComputer, $RemoteComputerName))
                }                
                
                $errorvariabe = $null         
                $cimSession = New-CimSession -ComputerName $RemoteComputerName
                if ($cimSession -eq $null)
                {
                    throw ([string]::Format($Strings.FailedToCreateCimSession, $RemoteComputerName))
                }

                try
                {
                    $remoteComputerTestable = TestRemoteComputer $RemoteComputerName $cimSession

                    $localToRemotePinging = DoPingTest $LocalComputerName $RemoteComputerName
                    $remoteToLocalPinging = DoPingTest $RemoteComputerName $LocalComputerName 
                    $localDtc = FindDtc $LocalComputerName $null
                    $remoteDtc = FindDtc $RemoteComputerName $cimSession
                    CompareCids $localDtc $remoteDtc
                    
                    if (($localComputerTestable -and $remoteComputerTestable -and $localToRemotePinging -and $remoteToLocalPinging) -eq $false)
                    {
                        throw $Strings.NeedDtcSecurityFix
                    }                    

                    $diagnosticTestPrompt = ([string]::Format($Strings.DiagnosticTestPrompt, $LocalComputerName, $RemoteComputerName))
                    $portDescription = $null
                    if ($ResourceManagerPort -eq $null)
                    {
                        $portDescription =  ([string]::Format($Strings.DefaultPortDescription, $port))
                    }
                    else
                    {
                        $port = $ResourceManagerPort
                        $portDescription = ([string]::Format($Strings.PortDescription, $port))
                    }

                    $firewallRequest = ([string]::Format($Strings.FirewallRequest, $port))
                    $completePrompt = ([string]::Format("{0} {1} {2}", $diagnosticTestPrompt, $portDescription, $firewallRequest))
                    
                    if ($pscmdlet.ShouldProcess($completePrompt, $Strings.QueryText, $completePrompt)) 
                    {
                        CheckIfDefaultDtcConfigured $LocalComputerName $null
                        CheckIfDefaultDtcConfigured $RemoteComputerName $cimSession
                        TestTransactionsPropagation $LocalComputerName $RemoteComputerName $port
                    }


                }
                finally
                {
                    Remove-CimSession -CimSession $cimSession
                }
                
            }
        } 
    }
    END {
    }
}