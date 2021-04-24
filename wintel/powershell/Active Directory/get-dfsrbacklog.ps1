<# 
 
.SYNOPSIS 
 
Retrieves DFSR backlog information for all Replication Groups and Connections from the perspective of the targeted server. 
 
 
 
.DESCRIPTION 
 
The Get-DFSRBacklog script uses Windows Management Instrumentation (WMI) to retrieve Replication Groups, Replication Folders, and Connections from the targeted computer.  
 
The script then uses this information along with MicrosoftDFS WMI methods to calculate the version vector and in turn backlog for each pairing. 
 
All of this information is returned in an array custom objects, that can be later processed as needed. 
 
The computername defaults to "localhost", or may be passed to the –computerName parameter. 
 
The parameters -RGName and -RFName may also be used to filter either or both results, but currently each parameter only accepts one single value. 
 
Checking multiple replication groups/folders will require either running the script again, or using the default to return all pairings. 
  
 
 
 
.EXAMPLE 
 
Output all of the DFSR backlog information from the local system into a sorted and grouped table. 
 
.\Get-DFSRBacklog.ps1 | sort-object BacklogStatus | format-table -groupby BacklogStatus 
 
 
 
.EXAMPLE 
 
Specify a DFSR target remotely, with a warning threshold of 100 
 
.\Get-DFSRBacklog.ps1 computername -WarningThreshold 100 
 
 
 
.EXAMPLE 
 
Specify a DFSR target remotely, only returning the data for a replication group named RepGroup1 
 
.\Get-DFSRBacklog.ps1 computername RepGroup1 
 
 
 
.NOTES 
 
You need to run this script with an account that has appropriate permission to query WMI from the remote computer. 
 
#> 
 
 
Param 
( 
    [string]$Computer = "localhost", 
    [string]$RGName = "", 
    [string]$RFName = "",  
    [int]$WarningThreshold = 50, 
    [int]$ErrorThreshold = 500 
) 
 
$DebugPreference = "SilentlyContinue" 
 
Function PingCheck 
{ 
    Param 
    ( 
        [string]$Computer = "localhost", 
        [int]$timeout = 120 
    ) 
    Write-Debug $computer 
    Write-Debug $timeout 
    $Ping = New-Object System.Net.NetworkInformation.Ping 
    trap  
    { 
        Write-Debug "The computer $computer could not be resolved."            
        continue 
    }  
    
    Write-Debug "Checking server: $computer"        
    $reply = $Ping.Send($computer,$timeout) 
    Write-Debug $reply 
    If ($reply.status -eq "Success")  
    { 
        Write-Output $True 
    } else { 
        Write-Output $False 
    }   
    
} 
 
Function Check-WMINamespace ($computer, $namespace) 
{ 
    $Namespaces = $Null 
    $Namespaces = Get-WmiObject -class __Namespace -namespace root -computername $computer | Where {$_.name -eq $namespace} 
    If ($Namespaces.Name -eq $Namespace) 
    { 
        Write-Output $True 
    } else { 
        Write-Output $False 
    } 
} 
 
Function Get-DFSRGroup ($computer, $RGName) 
{ 
    ## Query DFSR groups from the MicrosftDFS WMI namespace. 
    If ($RGName -eq "") 
    { 
        $WMIQuery = "SELECT * FROM DfsrReplicationGroupConfig" 
    } else { 
        $WMIQuery = "SELECT * FROM DfsrReplicationGroupConfig WHERE ReplicationGroupName='" + $RGName + "'" 
    } 
    $WMIObject = Get-WmiObject -computername $computer -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
    Write-Output $WMIObject 
} 
 
Function Get-DFSRConnections ($computer) 
{ 
    ## Query DFSR connections from the MicrosftDFS WMI namespace. 
    $WMIQuery = "SELECT * FROM DfsrConnectionConfig" 
    $WMIObject = Get-WmiObject -computername $computer -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
    Write-Output $WMIObject 
} 
 
 
Function Get-DFSRFolder ($computer, $RFname) 
{ 
    ## Query DFSR folders from the MicrosftDFS WMI namespace. 
    If ($RFName -eq "") 
    { 
        $WMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig" 
    } else { 
        $WMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig WHERE ReplicatedFolderName='" + $RFName + "'" 
    } 
    $WMIObject = Get-WmiObject -computername $computer -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
    Write-Output $WMIObject 
} 
 
 
Function Get-DFSRBacklogInfo ($Computer, $RGroups, $RFolders, $RConnections) 
{ 
   $objSet = @() 
    
   Foreach ($Group in $RGroups) 
   { 
        $ReplicationGroupName = $Group.ReplicationGroupName     
        $ReplicationGroupGUID = $Group.ReplicationGroupGUID 
            
        Foreach ($Folder in $RFolders)  
        { 
           If ($Folder.ReplicationGroupGUID -eq $ReplicationGroupGUID)  
           { 
                $ReplicatedFolderName = $Folder.ReplicatedFolderName 
                $FolderEnabled = $Folder.Enabled 
                Foreach ($Connection in $Rconnections) 
                { 
                    If ($Connection.ReplicationGroupGUID -eq $ReplicationGroupGUID)  
                    {     
                        $ConnectionEnabled = $Connection.Enabled 
                        $BacklogCount = $Null 
                        If ($FolderEnabled)  
                        { 
                            If ($ConnectionEnabled) 
                            { 
                                If ($Connection.Inbound) 
                                { 
                                    Write-Debug "Connection Is Inbound" 
                                    $Smem = $Connection.PartnerName.Trim() 
                                    Write-Debug $smem 
                                    $Rmem = $Computer.ToUpper() 
                                    Write-Debug $Rmem 
                                     
                                    #Get the version vector of the inbound partner 
                                    $WMIQuery = "SELECT * FROM DfsrReplicatedFolderInfo WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'" 
                                    $InboundPartnerWMI = Get-WmiObject -computername $Rmem -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
                                     
                                    $WMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'" 
                                    $PartnerFolderEnabledWMI = Get-WmiObject -computername $Smem -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
                                    $PartnerFolderEnabled = $PartnerFolderEnabledWMI.Enabled              
                                     
                                    If ($PartnerFolderEnabled) 
                                    { 
                                        $Vv = $InboundPartnerWMI.GetVersionVector().VersionVector 
                                         
                                        #Get the backlogcount from outbound partner 
                                        $WMIQuery = "SELECT * FROM DfsrReplicatedFolderInfo WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'" 
                                        $OutboundPartnerWMI = Get-WmiObject -computername $Smem -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
                                        $BacklogCount = $OutboundPartnerWMI.GetOutboundBacklogFileCount($Vv).BacklogFileCount   
                                    } 
                                } else { 
                                    Write-Debug "Connection Is Outbound" 
                                    $Smem = $Computer.ToUpper()   
                                    Write-Debug $smem                    
                                    $Rmem = $Connection.PartnerName.Trim() 
                                    Write-Debug $Rmem 
                                     
                                    #Get the version vector of the inbound partner 
                                    $WMIQuery = "SELECT * FROM DfsrReplicatedFolderInfo WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'" 
                                    $InboundPartnerWMI = Get-WmiObject -computername $Rmem -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
                                     
                                    $WMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'" 
                                    $PartnerFolderEnabledWMI = Get-WmiObject -computername $Rmem -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
                                    $PartnerFolderEnabled = $PartnerFolderEnabledWMI.Enabled 
                                     
                                    If ($PartnerFolderEnabled) 
                                    { 
                                        $Vv = $InboundPartnerWMI.GetVersionVector().VersionVector 
                                         
                                        #Get the backlogcount from outbound partner 
                                        $WMIQuery = "SELECT * FROM DfsrReplicatedFolderInfo WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'" 
                                        $OutboundPartnerWMI = Get-WmiObject -computername $Smem -Namespace "root\MicrosoftDFS" -Query $WMIQuery 
                                        $BacklogCount = $OutboundPartnerWMI.GetOutboundBacklogFileCount($Vv).BacklogFileCount 
                                    }               
                                } 
                            } 
                        } 
                     
                        $obj = New-Object psobject 
                        $obj | Add-Member noteproperty ReplicationGroupName $ReplicationGroupName 
                        write-debug $ReplicationGroupName 
                        $obj | Add-Member noteproperty ReplicatedFolderName $ReplicatedFolderName  
                        write-debug $ReplicatedFolderName 
                        $obj | Add-Member noteproperty SendingMember $Smem 
                        write-debug $Smem 
                        $obj | Add-Member noteproperty ReceivingMember $Rmem$ 
                        write-debug $Rmem 
                        $obj | Add-Member noteproperty BacklogCount $BacklogCount 
                        write-debug $BacklogCount 
                        $obj | Add-Member noteproperty FolderEnabled $FolderEnabled 
                        write-debug $FolderEnabled 
                        $obj | Add-Member noteproperty ConnectionEnabled $ConnectionEnabled 
                        write-debug $ConnectionEnabled 
                        $obj | Add-Member noteproperty Inbound $Connection.Inbound 
                        write-debug $Connection.Inbound 
                         
                         
                        If ($BacklogCount -ne $Null) 
                        { 
                            If ($BacklogCount -lt $WarningThreshold)  
                            { 
                                $Backlogstatus = "Low" 
                            } 
                            elseif (($BacklogCount -ge $WarningThreshold) -and ($BacklogCount -lt $ErrorThreshold)) 
                            { 
                                $Backlogstatus = "Warning" 
                            } 
                            elseif ($BacklogCount -ge $ErrorThreshold) 
                            { 
                                $Backlogstatus = "Error" 
                            }  
                        } else { 
                            $Backlogstatus = "Disabled" 
                        } 
                     
                        $obj | Add-Member noteproperty BacklogStatus $BacklogStatus 
                     
                        $objSet += $obj 
                    } 
                }   
           }  
        } 
   } 
   Write-Output $objSet 
} 
 
Write-Debug "Computer = $Computer" 
Write-Debug "RFName = $RFName" 
Write-Debug "RGName = $RGName" 
Write-Debug "WarningThreshold = $WarningThreshold" 
Write-Debug "ErrorThreshold = $ErrorThreshold" 
 
 
 
$Pingable = PingCheck $computer 
If ($Pingable) 
{ 
    $NamespaceExists = Check-WMINamespace $computer "MicrosoftDFS" 
    If ($NamespaceExists) 
    { 
        Write-Debug "Collecting RGroups from $computer" 
        $RGroups = Get-DFSRGroup $computer $RGName 
        Write-Debug "Rgroups = $Rgroups" 
        Write-Debug "Collecting RFolders from $computer" 
        $RFolders = Get-DFSRFolder $computer $RFName 
        Write-Debug "RFolders = $RFolders" 
        Write-Debug "Collecting RConnections from $computer" 
        $RConnections = Get-DFSRConnections $computer 
        Write-Debug "RConnections = $RConnections" 
 
        Write-Debug "Calculating Backlog from $computer" 
        $BacklogInfo = Get-DFSRBacklogInfo $Computer $RGroups $RFolders $RConnections 
 
        Write-Output $BacklogInfo 
        
$css = "<style>"
$css = $css + "BODY{background-color:white;}"
$css = $css + "TABLE{border-width: 0px;border-collapse: collapse;}"
$css = $css + "TH{padding: 2px;background-color:#EEAF30;color:white;font-family:Arial;font-size:12px;}"
$css = $css + "TD{padding: 2px;}"
$css = $css + "TD{Font-size: 10px;font-family:Arial;}"
$css = $css + "</style>"
        
        $BacklogInfoEmail = $BacklogInfo | sort-object BacklogStatus,ReplicatedFolderName,SendingMember | ConvertTo-Html -head $css | Out-String
        
        $email = @{
From = "si01file0@sentric.int"
To = "netadmin@sentric.net"
Subject = "DFSR Backlog Report"
SMTPServer = "si01exc1.sentric.int"
Body = $BacklogInfoEmail
BodyAsHtml = $True
}
send-mailmessage @email


    } else { 
        Write-Error "MicrosoftDFS WMI Namespace does not exist on '$computer'.  Run locally on a system with the Namespace, or provide computer parameter of that system to run remotely." 
    } 
} else { 
    Write-Error "The computer '$computer' did not respond to ping." 
}