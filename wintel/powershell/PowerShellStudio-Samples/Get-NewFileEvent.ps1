# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Get-NewFileEvent.ps1
# 
# 	Comments:
# 
#    Disclaimer: This source code is intended only as a supplement to 
# 				SAPIEN Development Tools and/or on-line documentation.  
# 				See these other materials for detailed information 
# 				regarding SAPIEN code samples.
# 
# 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
# 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
# 	PARTICULAR PURPOSE.
# 
# **************************************************************************

# $path is the full path to the folder you
# want to monitor like C:\files\PowerShell. It is relative
# to the computer you are monitoring

# $poll is the polling interval in seconds.

Param([string]$path=$env:temp,
      [int32]$poll=10,
      [string]$computername=$env:computername,
      [System.Management.Automation.PSCredential]$credential)

$ESCkey  = 27

$namespace="\\$computername\root\cimv2"
$drive=Split-Path $path -Qualifier
$Folder=(Split-Path $path -NoQualifier).Replace("\","\\")+"\\"

$query="Select * from __InstanceCreationEvent Within `
$poll where TargetInstance ISA 'CIM_datafile' AND `
TargetInstance.drive='$drive' AND TargetInstance.Path='$folder'"

$EventQuery  = New-Object System.Management.WQLEventQuery $query
$scope       = New-Object System.Management.ManagementScope $namespace

 if ($Credential) {
  #use alternate credentials if passed
    $scope.options.Username = $credential.GetNetworkCredential().Username
    $scope.options.Password = $credential.GetNetworkCredential().Password
    $scope.options
  } 
  
$watcher     = New-Object System.Management.ManagementEventWatcher $scope,$EventQuery
$options     = New-Object System.Management.EventWatcherOptions 
$options.TimeOut = [timespan]"0.0:0:1"
$watcher.Options = $options

cls
Write-Host "Waiting for:" $EventQuery.querystring " on $computername. Press ESC to quit." -back cyan -fore black
#start waiting for events
$watcher.Start()

#keep looping and waiting
while ($true) {

#trap any errors and keep going
 trap [System.Management.ManagementException] {continue}
 
  $evt=$watcher.WaitForNextEvent() 
 #if an event has fired get the target instance and select a subset
 #of properties
  if ($evt) {
     $evt.TargetInstance | select @{Name="Server";Expression={$_.CSName}},`
     Name,FileType,FileSize,@{Name="Created";Expression={
     [System.Management.ManagementDateTimeConverter]::ToDateTime($_.CreationDate)}}
    #clear the evt object and wait for the next event
    Clear-Variable evt
    }
  
   #watch for ESC key
 if ($host.ui.RawUi.KeyAvailable)
  {   $key = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp")
      if ($key.VirtualKeyCode -eq $ESCkey)  
      {   $watcher.Stop()
          break
      }
  }
    
} #end while Loop
