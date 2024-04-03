#/*++
#
#    Copyright (c) Microsoft Corporation.  All rights reserved.
#
#    Abstract:
#
#        This PowerShell script implements a mechanism to persist
#        iSCSI Target settings for Import/Export across machines.
#
#--*/

#
# Setting aliases for Resize-IscsiVirtualDisk cmdlets for backward compatibility.
#
Set-Alias -Name Expand-IscsiVirtualDisk -Value Resize-IscsiVirtualDisk
Export-ModuleMember -Alias "Expand-IscsiVirtualDisk" -Cmdlet "Resize-IscsiVirtualDisk"

#
# Localized Data table for the format strings
#
Import-LocalizedData -BindingVariable msgTable

#
# templates for property-like XML manipulation of InitiatorId
#
$InitiatorIDTemplate = @'
<InitiatorID>
    <Method></Method>
    <Value></Value>
</InitiatorID>
'@;

#
# templates for property-like XML manipulation of LunMapping
#
$LunMappingTemplate = @'
<LunMapping>
     <DiskId></DiskId>
     <LUN></LUN>
</LunMapping>
'@;

#
# templates for property-like XML manipulation of iSCSI Target
#
$TargetTemplate = @'
<iSCSITarget>
    <Enabled></Enabled>
    <HostName></HostName>
    <TargetIQN></TargetIQN>
    <Description></Description>
    <ResourceGroup></ResourceGroup>
    <MigrationResourceGroup></MigrationResourceGroup>
    <EnforceIdleTimeoutDetection></EnforceIdleTimeoutDetection>
    <FirstBurstLength></FirstBurstLength>
    <MaxBurstLength></MaxBurstLength>
    <MaxRecvDataSegmentLength></MaxRecvDataSegmentLength>
    <NumRecvBuffers></NumRecvBuffers>
    <EnableCHAP></EnableCHAP>
    <CHAPUserName></CHAPUserName>
    <EnableReverseCHAP></EnableReverseCHAP>
    <ReverseCHAPUserName></ReverseCHAPUserName>
    <InitiatorIDs></InitiatorIDs>
    <LunMappings></LunMappings>
</iSCSITarget>
'@;

#
# templates for property-like XML manipulation of VirtualDisk
#
$VirtualDiskTemplate = @'
<iSCSIVirtualDisk>
    <DiskId></DiskId>
    <Type></Type>
    <Enabled></Enabled>
    <DevicePath></DevicePath>
    <ParentPath></ParentPath>
    <Description></Description>
    <SnapshotStorageSize></SnapshotStorageSize>
    <MigrationDevicePath></MigrationDevicePath>
    <MigrationParentPath></MigrationParentPath>
    <MigrationResourceGroup></MigrationResourceGroup>
</iSCSIVirtualDisk>
'@;

#
# Flag used to test for Exported WTD
#
[System.UInt32]$LunFlagShadowLun = 0x00000002;

#
# Cluster Resource State
#
[System.Int32]$ClusterResourceStateOnline  = 2;

#
# Types of VHD
# Before WinBlue, fixed is 1, diff is 2
# In WinBlue, fixed is 2, differencing is 3, dynamic is 4
#
[System.Int32]$VhdTypeFixedVhd        = 1;
[System.Int32]$VhdTypeDifferencingVhd = 2;

[System.Int32]$WinBlueVhdTypeFixedVhd        = 2;
[System.Int32]$WinBlueVhdTypeDynamicVhd = 3;
[System.Int32]$WinBlueVhdTypeDifferencingVhd = 4;

#
# Hash Tables used for IDMethods
#
$IDNumberToMethod = @{
    0 = "NetBiosName";
    1 = "DNSName";
    2 = "IPAddress";
    3 = "MACAddress";
    4 = "IQN";
    5 = "IPV6Address";
};

$IDMethodToNumber = @{
    "NetBiosName" = 0;
    "DNSName"     = 1;
    "IPAddress"   = 2;
    "MACAddress"  = 3;
    "IQN"         = 4;
    "IPV6Address" = 5;
};

$iSCSITargetServerResourceTypeName = 'iSCSI Target Server'

################################################################
# Description
#   Given a computer name (in the form of IP-Address, NetBIOS or DNS name)
#   return if the computer is reachable by RPC/WinMgmt means
#
# Parameter Computername
#   String with a computer name, in NetBIOS, DNS, Ipv4 or IPv6 format
#
# Parameter isReachable
#   Reference to a bool variable that will be set to true if the machine
#   is in a cluster
#
# Parameter PSCredential
#   Optional credentials to be used in the connection to the
#   WinMmgt service of the specified machine. If null,
#   the current user credentials will be implicitly used
#
################################################################
function IsReachable
{
    PARAM(
        [Parameter(Position=0,Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Position=1,Mandatory=$true)]
        [ref]
        $isReachable,

        [Parameter(Position=2)]
        [System.Management.Automation.PSCredential]
        $PSCredential = $null
    )

    $RootWmiNSObj = $null;

    if ($null -ne $PSCredential)
    {
        $RootWmiNSObj = Get-WmiObject -namespace root -class __NAMESPACE -Filter "Name = 'wmi'" -ComputerName $ComputerName -Authentication PacketPrivacy -Credential $PSCredential -ErrorAction SilentlyContinue -ErrorVariable ResolveComputerError;
    }
    else
    {
        $RootWmiNSObj = Get-WmiObject -namespace root -class __NAMESPACE -Filter "Name = 'wmi'" -ComputerName $ComputerName -Authentication PacketPrivacy -ErrorAction SilentlyContinue -ErrorVariable ResolveComputerError;
    }

    if ( $null -eq $RootWmiNSObj )
    {
        $isReachable.Value = $false;
    }
    else
    {
        $isReachable.Value = $true;
    }

    return;
}


################################################################
# Description
#   Given a computer name (in the form of IP-Address, NetBIOS or DNS name)
#   return if the computer is member of a cluster, and return the cluster name
#
# Parameter Computername
#   String with a computer name, in NetBIOS, DNS, Ipv4 or IUPv6 format
#
# Parameter ClusterName
#   Reference to a variable that will be set to the cluster name
#   if the machine is in a cluster
#
# Parameter isCluster
#   Reference to a bool variable that will be set to true if the machine
#   is in a cluster
#
# Parameter PSCredential
#   Optional credentials to be used in the connection to the
#   WinMmgt service of the specified machine. If null,
#   the current user credentials will be implicitly used
#
################################################################
function IsCluster
{
    PARAM(
        [Parameter(Position=0,Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Position=1,Mandatory=$true)]
        [ref]
        $ClusterName,

        [Parameter(Position=2,Mandatory=$true)]
        [ref]
        $isCluster,

        [Parameter(Position=3)]
        [System.Management.Automation.PSCredential]
        $PSCredential = $null
    )

    $MsClusterNSObj;
    if ($null -ne $PSCredential)
    {
        $MsClusterNSObj = Get-WmiObject -namespace root -class __NAMESPACE -Filter "Name = 'MsCluster'" -ComputerName $ComputerName -Authentication PacketPrivacy -Credential $PSCredential;
    }
    else
    {
        $MsClusterNSObj = Get-WmiObject -namespace root -class __NAMESPACE -Filter "Name = 'MsCluster'" -ComputerName $ComputerName -Authentication PacketPrivacy;
    }

    if ( $null -eq $MsClusterNSObj )
    {
        $isCluster.Value = $false;
        return;
    }

    $MsClusterNSObj = $null;

    $MsClusterObj;
    if ($null -ne $PSCredential)
    {
        $MsClusterObj = Get-WmiObject -Namespace root\MSCluster -Authentication PacketPrivacy -class MSCluster_Cluster -ComputerName $ComputerName -Credential $PSCredential -ErrorAction SilentlyContinue -ErrorVariable FetchMsClusterError;
    }
    else
    {
        $MsClusterObj = Get-WmiObject -Namespace root\MSCluster -Authentication PacketPrivacy -class MSCluster_Cluster -ComputerName $ComputerName -ErrorAction SilentlyContinue -ErrorVariable FetchMsClusterError;
    }

    if ($null -eq $MsClusterObj)
    {
        $isCluster.Value = $false;
        return;
    }

    # return the cluster name to the by-ref parameter
    $ClusterName.Value = $MsClusterObj.Name;
    # return the cluster state to the by-ref parameter
    $isCluster.Value = $true;

    $MsClusterObj = $null;

    return;
}

################################################################
# Description
#   This function simplifies Get-WmiObject for the root\MsCluster namespace
#   by optionally taking the PSCredential parameter.
#
# Parameter ClassName
#  The name of the WinMgmt class in the CIM repository to be used
#  for the enumeration
#
# Parameter ComputerName
#   String with a computer name, in NetBIOS, DNS, Ipv4 or IPv6 format
#
# Parameter PSCredential
#   Optional credentials to be used in the connection to the
#   WinMmgt service of the specified machine. If null,
#   the current user credentials will be implicitly used
#
# Parameters FilterString
#   Optional fiter for the WinMgmt enumeration in WQL-syntax
#
################################################################
function
Get-RootMsCluster-WmiObject
{

    PARAM(
        [Parameter(Position=0,Mandatory=$true)]
        [string]
        $ClassName,

        [Parameter(Position=1,Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Position=2)]
        [System.Management.Automation.PSCredential]
        $PSCredential = $null,

        [Parameter(Position=3)]
        [string]
        $FilterString = $null
    )

    if ( $null -ne $PSCredential )
    {
        if ( $null -ne $FilterString )
        {
            return Get-WmiObject -Class $ClassName -Namespace root\MsCluster -Filter $FilterString -Authentication PacketPrivacy -Computername $ComputerName -Credential $PSCredential
        }
        else
        {
            return Get-WmiObject -Class $ClassName -Namespace root\MsCluster -Authentication PacketPrivacy -Computername $ComputerName -Credential $PSCredential
        }
    }
    else
    {
        if ( $null -ne $FilterString )
        {
            return Get-WmiObject -Class $ClassName -Namespace root\MsCluster -Filter $FilterString -Authentication PacketPrivacy -Computername $ComputerName
        }
        else
        {
            return Get-WmiObject -Class $ClassName -Namespace root\MsCluster -Authentication PacketPrivacy -Computername $ComputerName
        }
    }
}

################################################################
# Description
#  This function simplifies Get-WmiObject for the root\wmi namespace
#   by optionally taking the PSCredential parameter.
#
# Parameter ClassName
#  The name of the WinMgmt class in the CIM repository to be used
#  for the enumeration
#
# Parameter ComputerName
#   String with a computer name, in NetBIOS, DNS, Ipv4 or IPv6 format
#
# Parameter PSCredential
#   Optional credentials to be used in the connection to the
#   WinMmgt service of the specified machine. If null,
#   the current user credentials will be implicitly used
#
# Parameters FilterString
#   Optional fiter for the WinMgmt enumeration in WQL-syntax
#
################################################################
function
Get-RootWmi-WmiObject
{

    PARAM(
        [Parameter(Position=0,Mandatory=$true)]
        [string]
        $ClassName,

        [Parameter(Position=1,Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Position=2)]
        [System.Management.Automation.PSCredential]
        $PSCredential = $null,

        [Parameter(Position=3)]
        [string]
        $FilterString = $null
    )

    if ( $null -ne $PSCredential )
    {
        if ( $null -ne $FilterString )
        {
            return Get-WmiObject -Class $ClassName -Namespace root\wmi -Filter $FilterString -Computername $ComputerName -Credential $PSCredential
        }
        else
        {
            return Get-WmiObject -Class $ClassName -Namespace root\wmi -Computername $ComputerName -Credential $PSCredential
        }
    }
    else
    {
        if ( $null -ne $FilterString )
        {
            return Get-WmiObject -Class $ClassName -Namespace root\wmi -Filter $FilterString -Computername $ComputerName
        }
        else
        {
            return Get-WmiObject -Class $ClassName -Namespace root\wmi -Computername $ComputerName
        }
    }
}

################################################################
# Description
#   This function is executed once per script execution in a clustered
#   environment. It returns 3 Hashable (that are passed-in by reference).
#
# Parameter Computername
#   String with a computer name, in NetBIOS, DNS, Ipv4 or IPv6 format.
#
# Parameter ClusterNodesRef
#   Reference to hash table that will be filled with the cluster nodes
#   indexed by node-name.
#
# Parameter ClientAccessPointsRef
#   Reference to a hash table variable that will be filled with the
#   client access point, indexed by the Cluster-Resource name of
#   the 'Network Name'.
#
# Parameter GroupsOfNetworkNamesRef
#   Reference to a hash table variable that will be filled with the
#   cluster resource groups associated with Network-Names, indexed
#   by the Cluster-Resource name of the 'Network Name'.
#
# Parameter PSCredential
#   Optional credentials to be used in the connection to the
#   WinMmgt service of the specified machine. If null,
#   the current user credentials will be implicitly used.

################################################################
function GetNodesClientAccessPoints
{
    PARAM(
        [Parameter(Position=0,Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Position=1,Mandatory=$true)]
        [ref]
        $ClusterNodesRef,

        [Parameter(Position=2,Mandatory=$true)]
        [ref]
        $ClientAccessPointsRef,

        [Parameter(Position=3,Mandatory=$true)]
        [ref]
        $GroupsOfNetworkNamesRef,

        [Parameter(Position=4)]
        [System.Management.Automation.PSCredential]
        $PSCredential = $null
    )

    #
    # get the referenced Hash passed as a parameter
    #
    $ClientAccessPoints   = $ClientAccessPointsRef.Value;
    $ClusterNodes         = $ClusterNodesRef.Value;
    $GroupsOfNetworkNames = $GroupsOfNetworkNamesRef.Value;

    #
    # select * from MSCluster_Node
    #
    $ClusterNodeObjs = Get-RootMsCluster-WmiObject "MSCluster_Node" $ComputerName $PSCredential;
    foreach($ClusterNodeObj in $ClusterNodeObjs)
    {
        $ClusterNodes[$ClusterNodeObj.Name] = @();
        $ClusterNodes[$ClusterNodeObj.Name] += $ClusterNodeObj.Name;
        #
        # gather DNS information for a node
        #
        try 
        {
            $IPHostEntry = [System.Net.Dns]::GetHostEntry($ClusterNodeObj.Name);
            $ClusterNodes[$ClusterNodeObj.Name] += $IPHostEntry.HostName;
            $ClusterNodes[$ClusterNodeObj.Name] += $IPHostEntry.Aliases;
            foreach($IPAddress in $IPHostEntry.AddressList)
            {
                if ( 0 -eq [System.Int64]$IPAddress.ScopeId)
                {
                    $ClusterNodes[$ClusterNodeObj.Name] += $IPAddress.IPAddressToString;
                }
            }
        }
        catch
        {
            #
            # GetHostEntry could fail, we spew an warning message and this entry is skipped
            #
            Write-Host $([String]::Format($msgTable.NameResolutionFailed, $ClusterNodeObj.Name));
        }
    }

    #
    # Hash for the __RELPATH to Name of the 'Network Name' resource
    #
    $NetworkNamesRelPath = @{};
    #
    # Hash of the ClusterResources by __RELPATH
    #
    $ClusterResourcesByRelPath = @{};

    #
    # select * from MSCluster_Resource
    #
    $ClusterResources = Get-RootMsCluster-WmiObject "MSCluster_Resource" $ComputerName $PSCredential;
    foreach ($ClusterResource in $ClusterResources)
    {
        $ClusterResourcesByRelPath[$ClusterResource.__RELPATH] = $ClusterResource;

        if ($ClusterResource.Type -eq "Network Name")
        {
            $NetworkNamesRelPath[$ClusterResource.__RELPATH] = $ClusterResource.Name;

            $ClientAccessPoints[$ClusterResource.Name] = @();
            $ClientAccessPoints[$ClusterResource.Name] += $ClusterResource.PrivateProperties.Name;
            $ClientAccessPoints[$ClusterResource.Name] += $ClusterResource.PrivateProperties.DnsName;

            #
            # gather DNS information for a network name by NetBIOS Name
            #
            try 
            {
                $IPHostEntry = [System.Net.Dns]::GetHostEntry($ClusterResource.PrivateProperties.Name);
                $ClientAccessPoints[$ClusterResource.Name] += $IPHostEntry.HostName;
                $ClientAccessPoints[$ClusterResource.Name] += $IPHostEntry.Aliases;
                foreach($IPAddress in $IPHostEntry.AddressList)
                {
                    if ( 0 -eq [System.Int64]$IPAddress.ScopeId)
                    {
                        $ClientAccessPoints[$ClusterResource.Name] += $IPAddress.IPAddressToString;
                    }
                }
            }
            catch
            {
                #
                # GetHostEntry could fail, we spew an error message and continue processing DnsName
                #
                Write-Host $([String]::Format($msgTable.NameResolutionFailed, $ClusterResource.PrivateProperties.Name));
            }

            #
            # gather DNS information for a network name by DNS Name
            #
            try 
            {
                $IPHostEntry = [System.Net.Dns]::GetHostEntry($ClusterResource.PrivateProperties.DnsName);
                $ClientAccessPoints[$ClusterResource.Name] += $IPHostEntry.HostName;
                $ClientAccessPoints[$ClusterResource.Name] += $IPHostEntry.Aliases;
                foreach($IPAddress in $IPHostEntry.AddressList)
                {
                    if ( 0 -eq [System.Int64]$IPAddress.ScopeId)
                    {
                        $ClientAccessPoints[$ClusterResource.Name] += $IPAddress.IPAddressToString;
                    }
                }
            }
            catch
            {
                #
                # GetHostEntry could fail, we spew an error message
                #
                Write-Host $([String]::Format($msgTable.NameResolutionFailed, $ClusterResource.PrivateProperties.DnsName));
            }
        }
    }

    #
    # Groups with network names
    #
    $GroupRelPathNames = @{};

    #
    # select * from MSCluster_ResourceGroupToResource
    #
    $ResourceGroupToResources = Get-RootMsCluster-WmiObject "MSCluster_ResourceGroupToResource" $ComputerName $PSCredential;
    foreach($ResourceGroupToResource in $ResourceGroupToResources)
    {
        #
        # find all of the groups that have Network Names
        #
        if ($NetworkNamesRelPath.Keys -contains $ResourceGroupToResource.PartComponent)
        {
            $GroupRelPathNames[$ResourceGroupToResource.GroupComponent] = $NetworkNamesRelPath[$ResourceGroupToResource.PartComponent];
        }
    }

    #
    # find all the resources that have the same group as the NetworkNames
    #
    foreach($ResourceGroupToResource in $ResourceGroupToResources)
    {
        if ( $GroupRelPathNames.Keys -contains $ResourceGroupToResource.GroupComponent )
        {
            $ResourceInSameGroup = $ClusterResourcesByRelPath[$ResourceGroupToResource.PartComponent];

            $ClientAccessPoint = $GroupRelPathNames[$ResourceGroupToResource.GroupComponent];

            if ($ResourceInSameGroup.Type -eq 'IP Address')
            {
                $ClientAccessPoints[$ClientAccessPoint] += $ResourceInSameGroup.PrivateProperties.Address;
            }
            elseif ($ResourceInSameGroup.Type -eq 'IPv6 Address')
            {
                $ClientAccessPoints[$ClientAccessPoint] += $ResourceInSameGroup.PrivateProperties.Address;
            }
        }
    }

    #
    # find all of the ResourceGroups that have 'Network Names'
    #
    $ResourceGroups = Get-RootMsCluster-WmiObject "MSCluster_ResourceGroup" $ComputerName $PSCredential;
    foreach($ResourceGroup in $ResourceGroups)
    {
        if ( $GroupRelPathNames.Keys -contains $ResourceGroup.__RELPATH )
        {
            $ResourceNameNetworkName = $GroupRelPathNames[$ResourceGroup.__RELPATH];

            $GroupsOfNetworkNames[$ResourceNameNetworkName] = $ResourceGroup.Name;
        }
    }
}

################################################################
# Description
#     This function performs exception handling for
#     WinMgmt method invocation (IWbemServices::ExecMethod,
#     IWbemServices::PutInstance and the such) .
#     It attempts to add an error-record for the 'HashTableKey' entry
#     in the supplied HasTable
#
# Parameter Exception
#   A generic System.Object parameter. This allows type-checking
#   inside the function, since PowerShell ErrorRecords are
#   not derived from System.Exception
#
# Parameter HashTableRef
#    Reference to a hash table that will be updated by this funciton
#
# Parameter HashTableKey
#   Indexer of the hash table, to indicate where to add
#
# Parameter FormatString
#   Format string with 2 replacement location for the error message
#
# Parameter AddToArray
#   Is set to true, the hash table entry is expected to contain
#   an arrany (in the Powershell '@()' sense) of messages,
#   instead of a plain value
#
################################################################
function HandleWinMgmtMethodException
{
    PARAM(
        [Parameter(Position=0,Mandatory=$true)]
        [System.Object]
        $Exception,

        [Parameter(Position=1,Mandatory=$true)]
        [ref]
        $HashTableRef,

        [Parameter(Position=2,Mandatory=$true)]
        [string]$HashTableKey,

        [Parameter(Position=3,Mandatory=$true)]
        $FormatString,

        [Parameter(Position=4,Mandatory=$false)]
        $AddToArray = $false
    )

    #
    # final string
    #
    [string]$ComposedString;

    #
    # fetch the HashTable passed by reference
    #
    [System.Collections.Hashtable]$HashTable = $HashTableRef.Value;

    #
    # account for the case where the ErrorRecord has the exception
    # chain is: ErrorRecor -> Exception -> InnerException
    #
    if($Exception -is [System.Management.Automation.ErrorRecord])
    {
        $Exception = $Exception.Exception;
    }

    if ($Exception -is [System.Management.Automation.MethodInvocationException])
    {
        #
        # chain is: Exception -> InnerException
        #
        $InnerException = $Exception.InnerException;
        if ( $InnerException -ne $null )
        {
            if ($InnerException -is [System.Runtime.InteropServices.COMException])
            {
                $ErrMsg = [System.Runtime.InteropServices.Marshal]::GetExceptionForHR($InnerException.ErrorCode).Message;

                $ComposedString = [String]::Format($FormatString,$HashTableKey,$ErrMsg);
            }
            else
            {
                $ComposedString = [String]::Format($FormatString,$HashTableKey,$InnerException.ToString());
            }
        }
        else
        {
            $ComposedString = [String]::Format($FormatString,$HashTableKey,$Exception.ToString());
        }
    }
    else
    {
        $ComposedString = [String]::Format($FormatString,$HashTableKey,$Exception.ToString());
    }

    if ($AddToArray)
    {
        $HashTable[$HashTableKey] += $ComposedString;
    }
    else
    {
        $HashTable[$HashTableKey] = $ComposedString
    }
}

################################################################
#
# Description
#   The main script begins here
#
################################################################
#
# Import case
#
function Import-IscsiTargetServerConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Filename,

        [string]
        $ComputerName = ".",

        [string]
        $Credential = $null,

        [System.Management.Automation.SwitchParameter]
        [bool]
        $Force = $false
    )

    #
    # resolve the supplied path. It is unknown if the file exists at this point
    #
    $ResolvedFileName = Resolve-Path $Filename -ErrorAction SilentlyContinue -ErrorVariable ResolvePathError
    if (!$ResolvedFileName)
    {
        $Filename = $ResolvePathError[0].TargetObject;
    }
    else
    {
        $Filename = $ResolvedFileName;
    }

    #
    # test the supplied file path
    #
    if (!$(Test-Path $Filename))
    {
        Write-Host $([String]::Format($msgTable.FileNotFound,$Filename));
        return;
    }

    #
    # create the credentials, if required
    #
    [System.Management.Automation.PSCredential]$PSCredential = $null;
    if ( ($null -ne $Credential) -and ($Credential -ne ""))
    {
        $PSCredential = Get-Credential -Credential $Credential;
    }

    #
    # convert from System.Management.Automation.SwitchParameter
    #
    [bool]$ForceFlag = $Force.ToBool();

    #
    # check for reachability
    #
    [bool]$isReachable = $false;
    IsReachable $ComputerName ([ref]$isReachable) $PSCredential > $null;
    if ( !$isReachable )
    {
        Write-Host $([String]::Format($msgTable.ComputerNotReachable,$ComputerName));
        return
    }

    #
    # check for cluster
    #
    [string]$ClusterName = ".";
    [bool]$isCluster = $false;
    IsCluster $ComputerName ([ref]$ClusterName) ([ref]$isCluster) $PSCredential > $null;

    #
    # get the WT_General object as a test for iSCSI Target
    #
    $wtGeneral = Get-RootWmi-WmiObject "WT_General" $ComputerName $PSCredential;
    if ($null -eq $wtGeneral)
    {
        Write-Host $msgTable.TargetNotInstalled;
        return
    }

    #
    # check the version of the destination server
    #
    if ( !($wtGeneral.Version -match '^v6.3' -or $wtGeneral.Version -match '^v10.0') )
    {
        #
        # disallow importing on anything that is not iSCSI Target 6.3 or 10.0
        #
        Write-Host $([String]::Format($msgTable.VersionUnsupported,$wtGeneral.Version));
        return
    }

    #
    # create the DOM and load the settings file
    #
    [xml]$xml = New-Object XML;
    $xml.Load($Filename);

    #
    # figure-out the source version
    #
    [bool]$isZamfir = $false;
    [bool]$isWin8 = $false;
    [bool]$isWinBlue = $false;
    [string]$SettingsVersion = $xml.iSCSITargetServiceSetting.Version;

    if ( $SettingsVersion -match '^v3.3' )
    {
        $isZamfir = $true;
    }
    elseif( $SettingsVersion -match '^v6.1' )
    {
        $isWin8 = $true;
    }
    elseif( $SettingsVersion -match '^v6.2' )
    {
        $isWin8 = $true;
    }
    elseif( $SettingsVersion -match '^v6.3' )
    {
        $isWinBlue = $true;
    }
    elseif( $SettingsVersion -match '^v10.0' )
    {
        # in threshold we didn't have disk type/configuration change et al. use winblue setting
        $isWinBlue = $true;
    }
    else
    {
        Write-Host $([String]::Format($msgTable.SettingsVersionUnsupported,$SettingsVersion));
        return
    }

    #
    # print general information
    #
    Write-Host $([String]::Format($msgTable.ImportHeader,$Filename));

    #
    # if in cluster get the resource groups for the current node and XML-set
    # to detect duplication with the import set
    #
    $currentResourceGroup = @{};

    #
    # if in Cluster, gather the client access points
    #
    $ClientAccessPoints           = @{};
    $ClusterNodes                 = @{};
    $ResourceGroupsOfNetworkNames = @{};

    #
    # if in cluster, maintain the not-found the resource groups
    #
    $NotFoundMigrationResourceGroups = @{};

    if ($isCluster)
    {
        #
        # In win8 and above, if not all the resource groups are online, we bail out
        #
        #
        # select * from MSCluster_Resource where resource type equals to "iSCSI Target Server"
        #
        if (-not $isZamfir)
        {
            $iSCSITargetServerResources = Get-RootMsCluster-WmiObject "MSCluster_Resource" $ComputerName $PSCredential "Type='$iSCSITargetServerResourceTypeName'";
            foreach ($iSCSITargetServerResource in $iSCSITargetServerResources)
            {
                if ($iSCSITargetServerResource.State -ne $ClusterResourceStateOnline)
                {
                    Write-Host $([String]::Format($msgTable.AllTargetServerResourcesMustBeOnline,$iSCSITargetServerResource.Name));
                    return
                }
            }
        }
                
        #
        # get all the ResourceGroups from this cluster
        #
        $resourceGroupObjs = Get-RootMsCluster-WmiObject "MSCluster_ResourceGroup" $ComputerName $PSCredential;
        foreach($resourceGroupObj in $resourceGroupObjs)
        {
            [void]$currentResourceGroup.Add($resourceGroupObj.Name,$resourceGroupObj);
        }

        #
        # enumerate the targets, and check for MigrationResourceGroup
        #
        if ( $xml.DocumentElement.iSCSITargetRecords.ChildNodes.Count -gt 0 )
        {
            foreach($Target in $xml.DocumentElement.iSCSITargetRecords.ChildNodes)
            {
                if (!($currentResourceGroup.Keys -contains $Target.MigrationResourceGroup))
                {
                    if (!($NotFoundMigrationResourceGroups.Keys -contains $Target.MigrationResourceGroup))
                    {
                        $NotFoundMigrationResourceGroups[$Target.MigrationResourceGroup] = @();
                    }
                    $NotFoundMigrationResourceGroups[$Target.MigrationResourceGroup] += [String]::Format($msgTable.ResourceGroupNotFoundTarget,
                                                                                                         $Target.MigrationResourceGroup,
                                                                                                         $Target.HostName);
                }
            }
        }

        #
        # enumerate the VirtualDisk, and check for MigrationResourceGroup
        #
        if ( $xml.DocumentElement.iSCSIVirtualDiskRecords.ChildNodes.Count -gt 0 )
        {
            foreach($VirtualDisk in $xml.DocumentElement.iSCSIVirtualDiskRecords.ChildNodes)
            {

                if (!($currentResourceGroup.Keys -contains $VirtualDisk.MigrationResourceGroup))
                {
                    if (!($NotFoundMigrationResourceGroups.Keys -contains $VirtualDisk.MigrationResourceGroup))
                    {
                        $NotFoundMigrationResourceGroups[$VirtualDisk.MigrationResourceGroup] = @();
                    }
                    $NotFoundMigrationResourceGroups[$VirtualDisk.MigrationResourceGroup] += [String]::Format($msgTable.ResourceGroupNotFoundVirtualDisk,
                                                                                                              $VirtualDisk.MigrationResourceGroup,
                                                                                                              $VirtualDisk.DevicePath);
                }
            }
        }

        #
        # find the client access points and nodes
        #
        GetNodesClientAccessPoints $ComputerName ([ref]$ClusterNodes) ([ref]$ClientAccessPoints) ([ref]$ResourceGroupsOfNetworkNames) $PSCredential;
    }

    #
    # prepare the HashSet of the current resources - Targets
    #
    $currentTargetNames = @{};
    $currentTargetIQNs  = @{};
    $TargetObjects = Get-RootWmi-WmiObject "WT_Host" $ComputerName $PSCredential;
    foreach ($TargetObj in $TargetObjects)
    {
        if ($TargetObj -ne $null)
        {
            $currentTargetNames[$TargetObj.HostName] = $TargetObj;
            $currentTargetIQNs[$TargetObj.TargetIQN] = $TargetObj;
        }
    }

    #
    # prepare the HashSet of the current resources - VirtualDisks
    #
    $currentDevicePaths = @{};
    $VirtualDiskObjects = Get-RootWmi-WmiObject "WT_Disk" $ComputerName $PSCredential;
    foreach($VirtualDiskObj in $VirtualDiskObjects)
    {
        if ($VirtualDiskObj -ne $null)
        {
            $currentDevicePaths[$VirtualDiskObj.DevicePath] = $VirtualDiskObj;
        }
    }

    #
    # prepare the System.Management.ManagementObject for the static method invocation
    #
    $Wt_DiskClass       = Get-RootWmi-WmiObject "meta_class" $ComputerName $PSCredential "__class = 'WT_Disk'";
    $Wt_HostClass       = Get-RootWmi-WmiObject "meta_class" $ComputerName $PSCredential "__class = 'WT_Host'";
    $Wt_IdMethodClass   = Get-RootWmi-WmiObject "meta_class" $ComputerName $PSCredential "__class = 'WT_IdMethod'";
    $Wt_LunMappingClass = Get-RootWmi-WmiObject "meta_class" $ComputerName $PSCredential "__class = 'WT_LunMapping'";

    #
    # HashTable mapping the old DiskId with the new DiskId
    #
    $oldDiskIdToNewDiskId = @{};
    $oldDiskIdToDevicePath = @{};

    #
    # hash table used for reporting
    #
    $ImportedVirtualDisks    = @{};
    $NotImportedVirtualDisks = @{};

    #
    # These are the arrays for to store different types of VHD
    #
    $ArrayDifferencingVHDs = @();
    $ArrayNonDifferencingVHDs = @();
    $ArrayAllVHDs = @();
    if ( $xml.DocumentElement.iSCSIVirtualDiskRecords.ChildNodes.Count -gt 0 )
    {
        #
        # enumerate the VirtualDisk from the XML set, checking VHD types
        #
        foreach($VirtualDisk in $xml.DocumentElement.iSCSIVirtualDiskRecords.ChildNodes)
        {
            $oldDiskIdToDevicePath[$VirtualDisk.DiskId] = $VirtualDisk.DevicePath;

            if ([string]::IsNullOrEmpty([string]$VirtualDisk.Type))
            {
                #
                # unspecified VHD type can happen for cluster - offline.
                # because ParentPath is not available for offline resoruces,
                # assume fixed. If the file exists, then the code in
                # Wt_DiskClass.NewWTDisk will import both types
                #
                $ArrayNonDifferencingVHDs += $VirtualDisk;
            }
            elseif ($isWinBlue -and ([System.Int32]$VirtualDisk.Type -eq $WinBlueVhdTypeFixedVhd))
            {
                $ArrayNonDifferencingVHDs += $VirtualDisk;
            }
            elseif ($isWinBlue -and ([System.Int32]$VirtualDisk.Type -eq $WinBlueVhdTypeDynamicVhd))
            {
                $ArrayNonDifferencingVHDs += $VirtualDisk;
            }
            elseif ($isWinBlue -and ([System.Int32]$VirtualDisk.Type -eq $WinBlueVhdTypeDifferencingVhd))
            {
                $ArrayDifferencingVHDs += $VirtualDisk;
            }
            elseif ((-not $isWinBlue) -and ([System.Int32]$VirtualDisk.Type -eq $VhdTypeFixedVhd))
            {
                $ArrayNonDifferencingVHDs += $VirtualDisk;
            }
            elseif ((-not $isWinBlue) -and ([System.Int32]$VirtualDisk.Type -eq $VhdTypeDifferencingVhd))
            {
                $ArrayDifferencingVHDs += $VirtualDisk;
            }
            else
            {
                $NotImportedVirtualDisks[$VirtualDisk.MigrationDevicePath] = [String]::Format($msgTable.DevicePathInvalidType,
                                                                                                $VirtualDisk.MigrationDevicePath,
                                                                                                $VirtualDisk.Type);
            }
        }
    }

    #
    # Combine the arrays, and test if there is anything to do
    #
    $ArrayAllVHDs = $ArrayNonDifferencingVHDs + $ArrayDifferencingVHDs;
    if ($ArrayAllVHDs.Count -gt 0)
    {
        foreach($VirtualDisk in $ArrayAllVHDs)
        {
            #
            # check for MigrationDevicePath
            #
            [bool]$RunImport = $true;
            if ($currentDevicePaths.keys -contains $VirtualDisk.MigrationDevicePath)
            {
                if ($ForceFlag)
                {
                    $RunImport = $false;
                    #
                    # There is already a VirtualDisk, but -Force was specified.
                    # delete the VirtualDisk by DevicePath, then fall-through
                    #
                    [string]$DevicePathEscaped = $VirtualDisk.MigrationDevicePath;
                    $DevicePathEscaped = $DevicePathEscaped.Replace('\','\\');
                    $Filter = "DevicePath = `'$DevicePathEscaped`'";
                    $VirtualDiskToDelete = Get-RootWmi-WmiObject "WT_Disk" $ComputerName $PSCredential $Filter;
                    if ( $VirtualDiskToDelete -ne $null )
                    {
                        try
                        {
                            $VirtualDiskToDelete.Delete();
                            $RunImport = $true;
                        }
                        catch
                        {
                            HandleWinMgmtMethodException $_ ([ref]$NotImportedVirtualDisks) $VirtualDisk.MigrationDevicePath $msgTable.VirtualDiskDeleteInvocationFailureMsg;
                        }
                    }
                    else
                    {
                        $NotImportedVirtualDisks[$VirtualDisk.MigrationDevicePath] = [String]::Format($msgTable.NotDeletedDevicePathAlreadyExists,
                                                                                                      $VirtualDisk.MigrationDevicePath);
                    }
                }
                else
                {
                    $NotImportedVirtualDisks[$VirtualDisk.MigrationDevicePath] = [String]::Format($msgTable.DevicePathAlreadyExists,
                                                                                                  $VirtualDisk.MigrationDevicePath);
                    $RunImport = $false;
                }
            }

            if ($RunImport)
            {
                $ReturnObj = $null;

                try
                {
                    if (($isWinBlue -and ([System.Int32]$VirtualDisk.Type -eq $WinBlueVhdTypeDifferencingVhd)) -or ((-not $isWinBlue) -and ([System.Int32]$VirtualDisk.Type -eq $VhdTypeDifferencingVhd)))
                    {
                        $ReturnObj = $Wt_DiskClass.NewDiffWTDisk($VirtualDisk.MigrationDevicePath,
                                                                 $null,
                                                                 $VirtualDisk.Description);
                    }
                    else
                    {
                        $ReturnObj = $Wt_DiskClass.NewWTDisk($VirtualDisk.MigrationDevicePath,
                                                             $VirtualDisk.Description,
                                                             0);
                    }

                    if ( $null -ne $ReturnObj )
                    {
                        $CreatedWtDisk = $ReturnObj.ReturnValue;
                        if ( $null -ne $CreatedWtDisk )
                        {
                            #
                            # Save-off the generated DiskId ~ WTD
                            #
                            $oldDiskIdToNewDiskId.Add([string]$VirtualDisk.DiskId,[System.UInt32]$CreatedWtDisk.Wtd);

                            #
                            # If the VirtualDisk was disabled, disable-it now.
                            # if the settings were from cluster and now the environment is standalone
                            # the property may be undefined. Assume enable
                            #
                            [bool]$EnableState = $true;
                            if (![string]::IsNullOrEmpty([string]$VirtualDisk.Enabled))
                            {
                                $EnableState = [System.Convert]::ToBoolean($VirtualDisk.Enabled);
                            }
                            if (!$EnableState)
                            {
                                $Filter = "WTD = $($CreatedWtDisk.Wtd)";
                                $FetchedWtDisk = Get-RootWmi-WmiObject "WT_Disk" $ComputerName $PSCredential $Filter;
                                $FetchedWtDisk.Enabled = $EnableState;
                                $null = $FetchedWtDisk.Put();
                            }

                            #
                            # add this Devicepath to our hashtable of success case
                            #
                            $ImportedVirtualDisks[$VirtualDisk.MigrationDevicePath] = $true;

                            $CreatedWtDisk = $null;
                        }
                        else
                        {
                            $NotImportedVirtualDisks[$VirtualDisk.MigrationDevicePath] = [String]::Format($msgTable.NewWTDiskMethodInvocationFailure,
                                                                                                          $VirtualDisk.MigrationDevicePath);
                        }

                        $ReturnObj = $null;
                    }
                    else
                    {
                        $NotImportedVirtualDisks[$VirtualDisk.MigrationDevicePath] = [String]::Format($msgTable.NewWTDiskMethodInvocationFailure,
                                                                                                      $VirtualDisk.MigrationDevicePath);
                    }
                }
                catch
                {
                    HandleWinMgmtMethodException $_ ([ref]$NotImportedVirtualDisks) $VirtualDisk.MigrationDevicePath $msgTable.NewWTDiskMethodInvocationFailureMsg;
                }
            }
        }
    }

    #
    # hash table used for reporting
    #
    $ImportedTargets     = @{};
    $NotImportedTargets  = @{};
    $TargetsImportErrors = @{};

    #
    # get the Targets from the XML-set
    #
    if ( $xml.DocumentElement.iSCSITargetRecords.ChildNodes.Count -gt 0 )
    {
        foreach($Target in $xml.DocumentElement.iSCSITargetRecords.ChildNodes)
        {
            [bool]$RunImport = $true;
            if ($currentTargetNames.Keys -contains $Target.HostName)
            {
                if ($ForceFlag)
                {
                    $RunImport = $false;

                    $Filter = "HostName = `'$($Target.HostName)`'";
                    $TargetToDelete = Get-RootWmi-WmiObject "WT_Host" $ComputerName $PSCredential $Filter;
                    if ( $TargetToDelete -ne $null )
                    {
                        try
                        {
                            $TargetToDelete.Delete();
                            $RunImport = $true;
                        }
                        catch
                        {
                            HandleWinMgmtMethodException $_ ([ref]$NotImportedTargets) $Target.HostName $msgTable.TargetDeleteInvocationFailureMsg;
                        }
                    }
                    else
                    {
                        $NotImportedTargets[$Target.HostName] = [String]::Format($msgTable.NotDeletedTargetNameAlreadyExists,
                                                                                 $Target.HostName);
                    }
                }
                else
                {
                    $NotImportedTargets[$Target.HostName] = [String]::Format($msgTable.TargetNameAlreadyExists,$Target.HostName);
                    $RunImport = $false;
                }
            }
            elseif ($currentTargetIQNs.keys -contains $Target.TargetIQN)
            {
                if ($ForceFlag)
                {
                    $RunImport = $false;

                    $Filter = "TargetIQN = `'$($Target.HostName)`'";
                    $TargetToDelete = Get-RootWmi-WmiObject "WT_Host" $ComputerName $PSCredential $Filter;
                    if ( $TargetToDelete -ne $null )
                    {
                        try
                        {
                            $TargetToDelete.Delete();
                            $RunImport = $true;
                        }
                        catch
                        {
                            # Failure to delete in -Force mode, do nothing
                        }
                    }

                    if (!$RunImport)
                    {
                        $NotImportedTargets[$Target.HostName] = [String]::Format($msgTable.NotDeletedTargetNameAlreadyExists,
                                                                                 $Target.HostName);
                    }
                }
                else
                {
                    $NotImportedTargets[$Target.HostName] = [String]::Format($msgTable.TargetIQNNameAlreadyExists,$Target.TargetIQN);
                    $RunImport = $false;
                }
            }

            if ($RunImport)
            {
                $ReturnObj = $null;
                try
                {
                    $ReturnObj = $Wt_HostClass.NewHost($Target.HostName,
                                                       $Target.MigrationResourceGroup);

                    if ( $null -ne $ReturnObj )
                    {
                        $CreatedWtHost = $ReturnObj.ReturnValue;
                        if ( $null -ne $CreatedWtHost )
                        {
                            # add and empty array to the hashtable
                            $TargetsImportErrors[$Target.HostName] = @();

                            #
                            # Get back the object to modify properties
                            #
                            $Filter = "HostName = '$($Target.HostName)'";
                            $FetchedWtHost = Get-RootWmi-WmiObject "WT_Host" $ComputerName $PSCredential $Filter;

                            if (![string]::IsNullOrEmpty([string]$Target.Description))
                            {
                                $FetchedWtHost.Description = [string]$Target.Description;
                            }
                            if (![string]::IsNullOrEmpty([string]$Target.TargetIQN))
                            {
                                $FetchedWtHost.TargetIQN = [string]$Target.TargetIQN;
                            }
                            if (![string]::IsNullOrEmpty([string]$Target.NumRecvBuffers))
                            {
                                $FetchedWtHost.NumRecvBuffers = [System.UInt32]$Target.NumRecvBuffers;
                            }
                            if (![string]::IsNullOrEmpty([string]$Target.FirstBurstLength))
                            {
                                $FetchedWtHost.TargetFirstBurstLength = [System.UInt32]$Target.FirstBurstLength;
                            }
                            if (![string]::IsNullOrEmpty([string]$Target.MaxBurstLength))
                            {
                                $FetchedWtHost.TargetMaxBurstLength = [System.UInt32]$Target.MaxBurstLength;
                            }
                            if (![string]::IsNullOrEmpty([string]$Target.MaxRecvDataSegmentLength))
                            {
                                $FetchedWtHost.TargetMaxRecvDataSegmentLength = [System.UInt32]$Target.MaxRecvDataSegmentLength;
                            }

                            [bool]$EnforceIdleTimeoutDetection = $true;
                            if (![string]::IsNullOrEmpty([string]$Target.EnforceIdleTimeoutDetection))
                            {
                                $EnforceIdleTimeoutDetection = [System.Convert]::ToBoolean($Target.EnforceIdleTimeoutDetection);
                                $FetchedWtHost.EnforceIdleTimeoutDetection    = $EnforceIdleTimeoutDetection;
                            }

                            try
                            {
                                $null = $FetchedWtHost.Put();
                            }
                            catch
                            {
                                HandleWinMgmtMethodException $_ ([ref]$TargetsImportErrors) $Target.HostName $msgTable.NewHostPutInvocationFailureMsg $true;
                            }

                            #
                            # now process the InitiatorIDs
                            #
                            foreach($InitiatorID in $Target.InitiatorIDs.ChildNodes)
                            {
                                if ([string]::IsNullOrEmpty([string]$InitiatorID.Method) -or
                                    [string]::IsNullOrEmpty([string]$InitiatorID.Value) )
                                {
                                    # skip empty records
                                }
                                #
                                # validate the Id-Method
                                #
                                elseif ($IDNumberToMethod.Keys -contains $InitiatorID.Method)
                                {
                                    $IdMethodInstance = $Wt_IdMethodClass.CreateInstance();

                                    $IdMethodInstance.HostName = $Target.HostName;
                                    $IdMethodInstance.Method   = [System.Int32]$InitiatorID.Method;
                                    $IdMethodInstance.Value    = $InitiatorID.Value;
                                    $null = $IdMethodInstance.Put();
                                }
                                else
                                {
                                    # unsupported Identification method
                                    $TargetsImportErrors[$Target.HostName] += [String]::Format($msgTable.TargetIdMethodError,
                                                                                               $InitiatorID.Method);
                                }
                            }

                            #
                            # now process the LunMappings
                            #
                            foreach($LunMapping in $Target.LunMappings.ChildNodes)
                            {
                                if ([string]::IsNullOrEmpty([string]$LunMapping.DiskId) -or
                                    [string]::IsNullOrEmpty([string]$LunMapping.LUN) )
                                {
                                    # skip empty records
                                }
                                elseif ($oldDiskIdToNewDiskId.ContainsKey([string]$LunMapping.DiskId))
                                {
                                    $LunMappingInstance = $Wt_LunMappingClass.CreateInstance();

                                    $LunMappingInstance.HostName = $Target.HostName;
                                    $LunMappingInstance.LUN      = [System.UInt32]$LunMapping.LUN;
                                    #
                                    # derive the old to new mapping from the HashTable
                                    #
                                    $LunMappingInstance.WTD      = [System.UInt32]$oldDiskIdToNewDiskId.get_Item([string]$LunMapping.DiskId);
                                    $null = $LunMappingInstance.Put();
                                }
                                else
                                {
                                    $TargetsImportErrors[$Target.HostName] += [String]::Format($msgTable.TargetLunMappingError,
                                                                                               $LunMapping.DiskId);
                                }
                            }

                            #
                            # If the Target was disabled, disable-it now.
                            # if the settings were from cluster and now the environment is standalone
                            # the property may be undefined. Assume enable
                            #

                            [bool]$EnableState = $true;
                            if (![string]::IsNullOrEmpty([string]$Target.Enabled))
                            {
                                $EnableState = [System.Convert]::ToBoolean($Target.Enabled);
                            }

                            if (!$EnableState)
                            {
                                $FetchedWtHost = Get-RootWmi-WmiObject "WT_Host" $ComputerName $PSCredential $Filter;
                                $FetchedWtHost.Enabled = $EnableState;
                                $null = $FetchedWtHost.Put();
                            }

                            #
                            # Print a message for Chap/ReverseChap
                            #
                            if (![string]::IsNullOrEmpty($Target.EnableCHAP) -and
                                [System.Convert]::ToBoolean($Target.EnableCHAP))
                            {
                                $TargetsImportErrors[$Target.HostName] += [String]::Format($msgTable.TargetChapError,
                                                                                           $Target.CHAPUserName);
                            }

                            if (![string]::IsNullOrEmpty($Target.EnableReverseCHAP) -and
                                [System.Convert]::ToBoolean($Target.EnableReverseCHAP))
                            {
                                $TargetsImportErrors[$Target.HostName] += [String]::Format($msgTable.TargetReverseChapError,
                                                                                           $Target.ReverseCHAPUserName);
                            }

                            #
                            # save this target as the successfully imported ones
                            #
                            $ImportedTargets[$Target.HostName] = $true;
                        }
                        else
                        {
                            $NotImportedTargets[$Target.HostName] = [String]::Format($msgTable.NewHostMethodInvocationFailure,
                                                                                     $Target.HostName);
                        }

                        $ReturnObj = $null;
                    }
                    else
                    {
                        $NotImportedTargets[$Target.HostName] = [String]::Format($msgTable.NewHostMethodInvocationFailure,
                                                                                 $Target.HostName);
                    }
                }
                catch
                {
                    HandleWinMgmtMethodException $_ ([ref]$NotImportedTargets) $Target.HostName $msgTable.NewHostMethodInvocationFailureMsg;
                }
            }
        }
    }

    #
    # print the mismatched resource groups
    #
    if($isCluster -and ($NotFoundMigrationResourceGroups.Count -gt 0))
    {
        Write-Host $([String]::Format($msgTable.FooterNotImportedResourceGroups,$NotFoundMigrationResourceGroups.Count));
        foreach ($KeyVal in $NotFoundMigrationResourceGroups.GetEnumerator())
        {
            Write-Host "    $($KeyVal.Key) - $($KeyVal.Value)"
        }
    }

    #
    # print the Imported iSCSI Target
    #
    if ($ImportedTargets.Count -gt 0)
    {
        Write-Host $([String]::Format($msgTable.FooterImportedTargets,$ImportedTargets.Count));
        foreach ($KeyVal in $ImportedTargets.GetEnumerator())
        {
            Write-Host "    $($KeyVal.Key)";
            if ($TargetsImportErrors.ContainsKey($KeyVal.Key))
            {
                $TargetErrorMessages = $TargetsImportErrors[$KeyVal.Key];
                if ($TargetErrorMessages.Count -gt 0)
                {
                    Write-Host $($msgTable.ErrorHeader);
                    foreach($TargetErrorMessage in $TargetErrorMessages)
                    {
                        Write-Host $([String]::Format($msgTable.TargetSingleError,$TargetErrorMessage));
                    }
                }
            }
        }
    }

    if ($NotImportedTargets.Count -gt 0)
    {
        Write-Host $([String]::Format($msgTable.FooterNotImportedTargets,$NotImportedTargets.Count));
        foreach ($KeyVal in $NotImportedTargets.GetEnumerator())
        {
            Write-Host $([String]::Format($msgTable.TargetNameError,$KeyVal.Key,$KeyVal.Value));
        }
    }

    #
    # print a report of the VHD actually imported from the settings
    #
    if ($ImportedVirtualDisks.Count -gt 0)
    {
        Write-Host $([String]::Format($msgTable.FooterImportedVirtualDisks,$ImportedVirtualDisks.Count));
        foreach ($KeyVal in $ImportedVirtualDisks.GetEnumerator())
        {
            Write-Host "   $($KeyVal.Key)";
        }
    }

    if ($NotImportedVirtualDisks.Count -gt 0)
    {
        Write-Host $([String]::Format($msgTable.FooterNotImportedVirtualDisks,$NotImportedVirtualDisks.Count));
        foreach ($KeyVal in $NotImportedVirtualDisks.GetEnumerator())
        {
            Write-Host $([String]::Format($msgTable.VirtualDiskNameError,$KeyVal.Key,$KeyVal.Value));
        }
    }
}

#
# Export case
#
function Export-IscsiTargetServerConfiguration
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Filename,

        [string]
        $ComputerName = ".",

        [string]
        $Credential = $null,

        [System.Management.Automation.SwitchParameter]
        [bool]
        $Force = $false
    )
    #
    # resolve the supplied path. It is unknown if the file exists at this point
    #
    $ResolvedFileName = Resolve-Path $Filename -ErrorAction SilentlyContinue -ErrorVariable ResolvePathError
    if (!$ResolvedFileName)
    {
        $Filename = $ResolvePathError[0].TargetObject;
    }
    else
    {
        $Filename = $ResolvedFileName;
    }

    #
    # convert from System.Management.Automation.SwitchParameter
    #
    [bool]$ForceFlag = $Force.ToBool();

    #
    # test the supplied file path
    #
    [bool]$FileNameTest = $(Test-Path $Filename);
    if ( $FileNameTest -and !$ForceFlag )
    {
        Write-Host $([String]::Format($msgTable.SettingsFileExists,$Filename));
        return;
    }
    #
    # test the folder to the supplied file path
    #
    $FolderPath = Split-Path $Filename;
    $FileNameTest = $(Test-Path $FolderPath);
    if (!$FileNameTest)
    {
        Write-Host $([String]::Format($msgTable.SettingsFileFolderNotFound,$FolderPath));
        return;
    }

    #
    # create the credentials, if required
    #
    [System.Management.Automation.PSCredential]$PSCredential = $null;
    if ( ($null -ne $Credential) -and ($Credential -ne ""))
    {
        $PSCredential = Get-Credential -Credential $Credential;
    }

    #
    # check for reachability
    #
    [bool]$isReachable = $false;
    IsReachable $ComputerName ([ref]$isReachable) $PSCredential > $null;
    if ( !$isReachable )
    {
        Write-Host $([String]::Format($msgTable.ComputerNotReachable,$ComputerName));
        return
    }

    #
    # check for cluster
    #
    [string]$ClusterName = ".";
    [bool]$isCluster = $false;
    IsCluster $ComputerName ([ref]$ClusterName) ([ref]$isCluster) $PSCredential > $null;

    #
    # if in Cluster, gather the client access points and the nodes
    #
    $ClientAccessPoints           = @{};
    $ClusterNodes                 = @{};
    $ResourceGroupsOfNetworkNames = @{};

    #
    # matching type, if any
    #
    $NodeMatched              = $null;
    $ClientAccessPointMatched = $null;
    $ClusterNameMatched       = $null;
    $FilterResourceGroup      = $null;

    if ($isCluster)
    {
        #
        # find the client access points and node names
        #
        GetNodesClientAccessPoints $ComputerName ([ref]$ClusterNodes) ([ref]$ClientAccessPoints) ([ref]$ResourceGroupsOfNetworkNames) $PSCredential;

        $ComputerNameStr = $ComputerName;
        if ($ComputerNameStr -eq ".")
        {
            $ComputerNameStr = $env:COMPUTERNAME;
        }

        #
        # find which class of cluster access point the ComputerName belongs to
        #
        foreach ($KeyVal in $ClusterNodes.GetEnumerator())
        {
            if ($KeyVal.Value -contains $ComputerNameStr)
            {
                $NodeMatched = $KeyVal.Key;
                break;
            }
        };

        if ( $null -eq $NodeMatched )
        {
            foreach ($KeyVal in $ClientAccessPoints.GetEnumerator())
            {
                if ($KeyVal.Value -contains $ComputerNameStr)
                {
                    $ClientAccessPointMatched = $KeyVal.Key;
                    break;
                }
            };
        }

        if ($null -ne $ClientAccessPointMatched )
        {
            #
            # for the 'Cluster' Name case, dafault to a special-case `node`
            #
            if ($ClientAccessPointMatched -eq 'Cluster Name')
            {
                $ClusterNameMatched = $ClusterName;
                $ClientAccessPointMatched = $null;
            }
        }

        if ($null -ne $ClientAccessPointMatched)
        {
            $FilterResourceGroup = $ResourceGroupsOfNetworkNames[$ClientAccessPointMatched];
        }
    }

    #
    # get the version
    #
    $wtGeneral = Get-RootWmi-WmiObject "WT_General" $ComputerName $PSCredential;
    if ($null -eq $wtGeneral)
    {
        Write-Host $msgTable.TargetNotInstalled;
        return;
    }

    [bool]$isZamfir = $false;
    if( $wtGeneral.Version -match '^v3.3' )
    {
        $isZamfir = $true
    }
   if( -not ( ( $wtGeneral.Version -match '^v3.3' ) -or 
              ( $wtGeneral.Version -match '^v6.2' ) -or
              ( $wtGeneral.Version -match '^v6.3' ) -or
              ( $wtGeneral.Version -match '^v10.0' ) ) )
    {
        Write-Host $([String]::Format($msgTable.VersionUnsupported,$wtGeneral.Version));
        return
    }

    if ($isCluster -and (-not $isZamfir))
    {
        #
        # In win8 and above, if not all the resource groups are online, we bail out
        #
        #
        # select * from MSCluster_Resource where resource type equals to "iSCSI Target Server"
        #
        $iSCSITargetServerResources = Get-RootMsCluster-WmiObject "MSCluster_Resource" $ComputerName $PSCredential "Type='$iSCSITargetServerResourceTypeName'";
        foreach ($iSCSITargetServerResource in $iSCSITargetServerResources)
        {
            if ($iSCSITargetServerResource.State -ne $ClusterResourceStateOnline)
            {
                Write-Host $([String]::Format($msgTable.AllTargetServerResourcesMustBeOnline, $iSCSITargetServerResource.Name));
                return
            }
        }
    }
    
    #
    # Print general information
    #
    if ($isCluster)
    {
        if ( $null -ne $NodeMatched )
        {
            Write-Host $([String]::Format($msgTable.HeaderNodeName,$Filename,$ClusterName,$NodeMatched));
        }
        elseif ( $null -ne $ClusterNameMatched )
        {
            Write-Host $([String]::Format($msgTable.HeaderClusterName,$Filename,$ClusterName,$NodeMatched));
        }
        elseif ( $null -ne $ClientAccessPointMatched )
        {
            Write-Host $([String]::Format($msgTable.HeaderClientAccessPointName,$Filename,$ClusterName,$ClientAccessPointMatched,$FilterResourceGroup));
        }
    }
    else
    {
        $ComputerNameStr = $ComputerName;
        if ($ComputerNameStr -eq ".")
        {
            $ComputerNameStr = $env:COMPUTERNAME;
        }
        Write-Host $([String]::Format($msgTable.HeaderStandalone,$Filename,$ComputerNameStr));
    }

    #
    # create the DOM
    #
    [xml]$xml = New-Object XML;

    #
    # Processing instruction and root node
    #
    [System.Xml.XmlProcessingInstruction]$processingInstruction = $xml.CreateProcessingInstruction("xml","version='1.0'");
    $null = $xml.AppendChild($processingInstruction);
    [System.Xml.XmlElement]$root = $xml.CreateElement("iSCSITargetServiceSetting");
    $root.SetAttribute("xmlns","http://schemas.microsoft.com/iSCSITarget/DeploymentSettings/3.3");
    $root.SetAttribute("Version",[string]$wtGeneral.Version);
    $root.SetAttribute("ExportTimeStamp",$([datetime]::Now.Date.ToString("o")));
    $root.SetAttribute("ComputerName",[string]$ComputerName);
    $root.SetAttribute("IsCluster",([string]$isCluster));
    if ($isCluster)
    {
        $root.SetAttribute("ClusterName",$ClusterName);

        if ( $null -ne $NodeMatched )
        {
            $root.SetAttribute("ClusterResourcesScope","NodeName");
            $root.SetAttribute("ClusterNode",$NodeMatched);
        }
        elseif ( $null -ne $ClusterNameMatched )
        {
            $root.SetAttribute("ClusterResourcesScope","ClusterName");
        }
        elseif ( $null -ne $ClientAccessPointMatched )
        {
            $root.SetAttribute("ClusterResourcesScope","ClientAccessPoint");
            $root.SetAttribute("ClusterClientAccessPoint",$ClientAccessPointMatched);
        }
    }
    $null = $xml.AppendChild($root);

    #
    # XmlNode holder for Target
    #
    $rootTargets = $xml.CreateElement("iSCSITargetRecords");
    $null = $root.AppendChild($rootTargets);

    #
    # convert the templates into System.Xml.XmlNode
    #
    $InitiatorIDBaseNode = $xml.ImportNode(([xml]$InitiatorIDTemplate).DocumentElement,$true);
    $LunMappingBaseNode  = $xml.ImportNode(([xml]$LunMappingTemplate).DocumentElement,$true);
    $TargetBaseNode      = $xml.ImportNode(([xml]$TargetTemplate).DocumentElement,$true);

    #
    # hash table used for reporting
    #
    $TargetsInExportSet = @{};

    $TargetObjects = Get-RootWmi-WmiObject "WT_Host" -ComputerName $ComputerName $PSCredential;
    if ($null -ne $TargetObjects)
    {
        foreach ($TargetObj  in $TargetObjects)
        {
            if ( $null -ne $FilterResourceGroup)
            {
                if ( $TargetObj.ResourceGroup -ne $FilterResourceGroup )
                {
                    continue;
                }
            }

            $TargetNode = $TargetBaseNode.CloneNode($true);

            if ($isZamfir)
            {
                $TargetNode.Enabled                 = [string]$TargetObj.Enable;
            }
            else
            {
                $TargetNode.Enabled                 = [string]$TargetObj.Enabled;
            }
            $TargetNode.HostName                    = [string]$TargetObj.HostName;
            $TargetNode.TargetIQN                   = [string]$TargetObj.TargetIQN;
            $TargetNode.Description                 = [string]$TargetObj.Description;
            $TargetNode.ResourceGroup               = [string]$TargetObj.ResourceGroup;
            $TargetNode.MigrationResourceGroup      = [string]$TargetObj.ResourceGroup;
            $TargetNode.EnforceIdleTimeoutDetection = [string]$TargetObj.EnforceIdleTimeoutDetection;
            $TargetNode.FirstBurstLength            = [string]$TargetObj.TargetFirstBurstLength;
            $TargetNode.MaxBurstLength              = [string]$TargetObj.TargetMaxBurstLength;
            $TargetNode.MaxRecvDataSegmentLength    = [string]$TargetObj.TargetMaxRecvDataSegmentLength;
            $TargetNode.NumRecvBuffers              = [string]$TargetObj.NumRecvBuffers;
            $TargetNode.EnableCHAP                  = [string]$TargetObj.EnableCHAP;
            # secrets are not stored
            #$TargetNode.CHAPSecret                  = [string]$TargetObj.CHAPSecret;
            $TargetNode.CHAPUserName                = [string]$TargetObj.CHAPUserName;
            $TargetNode.EnableReverseCHAP           = [string]$TargetObj.EnableReverseCHAP;
            # secrets are not stored
            #$TargetNode.ReverseCHAPSecret           = [string]$TargetObj.ReverseCHAPSecret;
            $TargetNode.ReverseCHAPUserName         = [string]$TargetObj.ReverseCHAPUserName;

            #
            # Fetch the System.Xml.XmlNode used to append later
            #
            $InitiatorIDsNode = $TargetNode.SelectSingleNode("InitiatorIDs");
            $LunMappingsNode  = $TargetNode.SelectSingleNode("LunMappings");

            #
            # Initiator IDs
            #
            $FilterString = "HostName = '$($TargetObj.HostName)'";
            $IdMethods = Get-RootWmi-WmiObject "WT_IDMethod" $ComputerName $PSCredential $FilterString;
            if ($null -ne $IdMethods)
            {
                foreach($IdMethod in $IdMethods)
                {
                    $InitiatorIDNode = $InitiatorIDBaseNode.CloneNode($true);

                    $InitiatorIDNode.Method = [string]$IdMethod.Method;
                    $InitiatorIDNode.Value  = [string]$IdMethod.Value;

                    $null = $InitiatorIDsNode.AppendChild($InitiatorIDNode);
                }
            }

            #
            # Lun Mappings
            #
            $LunMappings = Get-RootWmi-WmiObject "WT_LunMapping" $ComputerName $PSCredential $FilterString
            if ($null -ne $LunMappings)
            {
                foreach($LunMapping in $LunMappings)
                {
                    $LunMappingNode = $LunMappingBaseNode.CloneNode($true);

                    $LunMappingNode.LUN    = [string]$LunMapping.LUN;
                    $LunMappingNode.DiskId = [string]$LunMapping.WTD;

                    $null = $LunMappingsNode.AppendChild($LunMappingNode);
                }
            }

            $null = $rootTargets.AppendChild($TargetNode);

            $TargetsInExportSet[$TargetObj.HostName] = $true;
        }
    }
    #
    #  XmlNode holder for VirtualDisks
    #
    $rootVirtualDisks = $xml.CreateElement("iSCSIVirtualDiskRecords");
    $null = $root.AppendChild($rootVirtualDisks);

    #
    # hash table used for reporting
    #
    $FilesInExportSet    = @{};
    $FilesNotInExportSet = @{};

    #
    # convert the template into System.Xml.XmlNode
    #
    $VirtualDiskNode = $xml.ImportNode(([xml]$VirtualDiskTemplate).DocumentElement,$true);

    $VirtualDiskObjects = Get-RootWmi-WmiObject "WT_Disk" $ComputerName $PSCredential;
    if ($null -ne $VirtualDiskObjects )
    {
        foreach($VirtualDiskObj in  $VirtualDiskObjects)
        {
            if ( $null -ne $FilterResourceGroup)
            {
                if ( $VirtualDiskObj.ResourceGroup -ne $FilterResourceGroup )
                {
                    continue;
                }
            }

            if ($VirtualDiskObj.Flags -eq $LunFlagShadowLun)
            {
                #
                # WT_Disk Exported from snapshots are excluded from the settings
                #
                $FilesNotInExportSet[$VirtualDiskObj.DevicePath] = $false;
            }
            else
            {
                $VirtualDiskNode = $VirtualDiskNode.CloneNode($true);

                $VirtualDiskNode.DiskId                 = [string]$VirtualDiskObj.Wtd;
                $VirtualDiskNode.Type                   = [string]$VirtualDiskObj.Type;
                $VirtualDiskNode.Enabled                = [string]$VirtualDiskObj.Enabled;
                $VirtualDiskNode.DevicePath             = [string]$VirtualDiskObj.DevicePath;
                $VirtualDiskNode.ParentPath             = [string]$VirtualDiskObj.ParentPath;
                $VirtualDiskNode.MigrationDevicePath    = [string]$VirtualDiskObj.DevicePath;
                $VirtualDiskNode.MigrationParentPath    = [string]$VirtualDiskObj.ParentPath;
                $VirtualDiskNode.MigrationResourceGroup = [string]$VirtualDiskObj.ResourceGroup;
                $VirtualDiskNode.Description            = [string]$VirtualDiskObj.Description;
                $VirtualDiskNode.SnapshotStorageSize    = [string]$VirtualDiskObj.SnapshotStorageSizeInMB;

                $null = $rootVirtualDisks.AppendChild($VirtualDiskNode);

                $FilesInExportSet[$VirtualDiskObj.DevicePath] = $true;
            }
        }
    }

    $xml.Save($Filename);

    #
    # print a report of the Targets actually exported in the settings
    #
    if ( $TargetsInExportSet.Count -gt 0 )
    {
        Write-Host $([String]::Format($msgTable.FooterExportedTargets,$TargetsInExportSet.Count));
        foreach ($KeyVal in $TargetsInExportSet.GetEnumerator())
        {
            Write-Host "   $($KeyVal.Key)"
        }
    }

    #
    # print a report of the VHD actually exported in the settings
    #
    if ( $FilesInExportSet.Count -gt 0 )
    {
        Write-Host $([String]::Format($msgTable.FooterExportedVirtualDisks,$FilesInExportSet.Count));
        foreach ($KeyVal in $FilesInExportSet.GetEnumerator())
        {
            Write-Host "   $($KeyVal.Key)"
        }
    }

    #
    # print a report of the VHD actually NOT exported in the settings
    #
    if ( $FilesNotInExportSet.Count -gt 0 )
    {
        Write-Host $([String]::Format($msgTable.FooterNotExportedVirtualDisks,$FilesNotInExportSet.Count));
        foreach ($KeyVal in $FilesNotInExportSet.GetEnumerator())
        {
            Write-Host "    $($KeyVal.Key)"
        }
    }
}

#
# Export functions to be visible in the global scope.
#
Export-ModuleMember "Import-IscsiTargetServerConfiguration", "Export-IscsiTargetServerConfiguration"
