# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Get-NewProcessEvent.ps1
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

# Usage:
# Get-NewProcessEvent SERVER02

# ****************************************************************
# * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
# * IN A SECURED LAB ENVIRONMENT. USE AT YOUR OWN RISK.          * 
# ****************************************************************

Param([string]$computername=$env:computername)
 
 
  Function Convert-UTC {

    Param([int64]$var=0)
    
    [datetime]$utc="1/1/1601"
    
    if ($var -eq 0) {
        write $utc
    } else {
        
        $i=$var/864000000000
        write ($utc.AddDays($i))
    }
}
        
 $ESCkey  = 27
 
 $namespace="\\$computername\root\cimv2"
 $query="Select * from Win32_ProcessStartTrace"
 $EventQuery = New-Object System.Management.WQLEventQuery $query
 $scope      = New-Object System.Management.ManagementScope $namespace
 $watcher    = New-Object System.Management.ManagementEventWatcher $scope,$EventQuery
 $options    = New-Object System.Management.EventWatcherOptions 
 $options.TimeOut = [timespan]"0.0:0:1"
 $watcher.Options = $options
 
 cls 
 
 #diplay a message about what the script is waiting for
 Write-Host "Waiting for events in response to: " $EventQuery.querystring "on $computername. Press ESC to quit." -back cyan -fore black
 
 #start the management watcher
 $watcher.Start()
 
 #loop and wait for events to fire
 while ($true) {
    trap [System.Management.ManagementException] {continue}
    
 $evt=$watcher.WaitForNextEvent() 
 
 #if an event fires....
 if ($evt) {
  #uncomment the next line if you want a beep everytime a new process is started
  #write `a
  $evt | select @{name="Time";Expression={Convert-UTC $_.Time_Created}},ProcessName,ProcessID,ParentProcessID
  
  #clear the variable for the next event
  Clear-Variable evt 
  }
  
 if ($host.ui.RawUi.KeyAvailable)
  {   $key = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp")
      if ($key.VirtualKeyCode -eq $ESCkey)  
      {   $watcher.Stop()
          break
      }
  }
 
 }

#end of script
