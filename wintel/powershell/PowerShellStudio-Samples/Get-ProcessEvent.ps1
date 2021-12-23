# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Get-ProcessEvent.ps1
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

#sample usage
# PS C:\> Get-ProcessEvent "Puck"
# PS C:\> $cred=get-credential mycompany\admin
# PS C:\> get-Process Event -computername "SRV01" -credential $cred
# PS C:\> get-Process Event -computername "SRV01" -log
# PS C:\> get-Process Event -computername "SRV01" -log -filter "notepad.exe"
# PS C:\> get-Process Event -computername "SRV01" -log -filter "notepad.exe" -poll 30

#if -log is specified a file will be created with a
#name like C:\SERVER02_ProcessEvents_07192008193700.csv

# ****************************************************************
# * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
# * IN A SECURED LAB ENVIRONMENT. USE AT YOUR OWN RISK.          * 
# ****************************************************************
#///////////////////////////////////////////////////////////////////

Param([string]$computername=$env:computername,
      [string]$filter="%", 
      [int]$poll=10,
      [System.Management.Automation.PSCredential]$credential,
      [switch]$log,
      [switch]$beep
      )
     
     
Function Convert-UTC {
#returns a UTC date time
Param([int64]$var=0)

[datetime]$utc="1/1/1601"

if ($var -eq 0) {
    write $utc
 } 
else {  
    $i=$var/864000000000
    write ($utc.AddDays($i))
 }
}

     
 if ($log) {
   #if -log is specified a file will be created with a
   #name like C:\SERVER02_ProcessEvents_07192008193700.csv
   $d=Get-Date -f MMddyyyyHHmmss
   $logfile="C:\{0}_ProcessEvents_{1}.csv" -f $computername.ToUpper(),$d

   Set-Content $logfile "ComputerName,ProcessEvent,Time,ProcessName,ProcessID,ProcessPath,ParentProcess" -encoding ASCII
   
   #define name for temporary csv file
   $tmpfile="$env:temp\~tmp$.csv"
 }
 
 #get current time zone for the computer so that the UTC time can be
 #converted to local time
 
 if ($credential) {
  $tz=(Get-WmiObject win32_operatingsystem -computername $computername -credential $credential).currentTimeZone
 }
 else
 {
  $tz=(Get-WmiObject win32_operatingsystem -computername $computername).currentTimeZone

 }
 
 $ESCkey  = 27
 
 $namespace="\\$computername\root\cimv2"
 $query="Select * from Win32_ProcessTrace Where ProcessName LIKE '$filter'"
 $EventQuery = New-Object System.Management.WQLEventQuery $query
 $scope      = New-Object System.Management.ManagementScope $namespace
 
 if ($Credential) {
  #use alternate credentials if passed
    $scope.options.Username = $credential.GetNetworkCredential().Username
    $scope.options.Password = $credential.GetNetworkCredential().Password
    $scope.options
  } 
 
 $watcher    = New-Object System.Management.ManagementEventWatcher $scope,$EventQuery
 $options    = New-Object System.Management.EventWatcherOptions 
 $options.TimeOut = [timespan]"0.0:0:1"
 $watcher.Options = $options
 
 cls 
 
 #diplay a message about what the script is waiting for
 Write-Host "Waiting for events :" $EventQuery.querystring "on $computername. Press ESC to quit." -back cyan -fore black
 
 #start the management watcher
 $watcher.Start()
 
 #loop and wait for events to fire
 while ($true) {
 
    trap [System.Management.ManagementException] {continue}

    $evt=$watcher.WaitForNextEvent() 
 
     #if an event fires....
     if ($evt) {
        if ($beep) {write `a}
     
     #build a custom object showing what type of event, converted
     #date time values and other relevant information    
     $data=$evt | select @{name="ComputerName";Expression={$computername}},`
     @{Name="ProcessEvent";Expression={
       Switch ($_.__Class) {
        "Win32_ProcessStartTrace" {"Start"}
        "Win32_ProcessStopTrace" {"Stop"}
        default {$_.__Class}
       }
       }},`
     @{name="Time";Expression={
       #convert time to UTC
       [datetime]$utcTime=Convert-UTC $_.Time_Created
       #adjust UTC to local time
       $utcTime.AddMinutes($tz)
       }},`
     ProcessName,ProcessID,`
     @{name="ProcessPath";Expression={
       $procPath=(Get-Process -Id $_.ProcessID).path
       if ($procPath) {
         $procPath
       }
       else {
        "N/A"
       }
       }},`
     @{name="ParentProcess";Expression={
     "{0} ({1})" -f $_.ParentProcessID,(Get-Process -id $_.ParentProcessID).processname}}
     
     #write process event data to pipeline
     $data 
     
     # if -log was specified export data to the temp CSV file
     # then copy that content to the log file and remove the temp CSV file
     if ($log) { 
       $data | Export-Csv -Path $tmpfile -encoding ASCII -NoTypeInformation
       Get-Content $tmpfile | select -Last 1 | Out-File $logfile -append -encoding ASCII
       Remove-Item $tmpfile
       }

     #Clear $EVT for next event
     Clear-Variable evt 
     
     #sleep for the specified number of seconds
     Start-Sleep -Seconds $poll
      
 } #end If ($evt) 
 
 #watch for ESC key
     if ($host.ui.RawUi.KeyAvailable)
      {   $key = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp")
          if ($key.VirtualKeyCode -eq $ESCkey)  
          {   $watcher.Stop()

              break
          }
      }
      
} #end of while loop

#end of script
