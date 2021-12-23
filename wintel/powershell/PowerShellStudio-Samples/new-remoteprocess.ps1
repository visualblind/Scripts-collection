# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  New-RemoteProcess.ps1
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

#The remote process will NOT be interactive or necessarily visible to any user
#logged on to the console.

Function New-RemoteProcess {
    Param([string]$computername=$env:computername,
          [string]$cmd=$(Throw "You must enter the full path to the command which will create the process.")
        )
    
    $ErrorActionPreference="SilentlyContinue"
     
    Trap {
        Write-Warning "There was an error connecting to the remote computer or creating the process"
        Continue
    }    
        
    Write-Host "Connecting to $computername" -ForegroundColor CYAN
    Write-Host "Process to create is $cmd" -ForegroundColor CYAN

    [wmiclass]$wmi="\\$computername\root\cimv2:win32_process"
    
    #bail out if the object didn't get created
    if (!$wmi) {return}
    
    $remote=$wmi.Create($cmd)
    
    if ($remote.returnvalue -eq 0) {
        Write-Host "Successfully launched $cmd on $computername with a process id of" $remote.processid -ForegroundColor GREEN
    }
    else {
        Write-Host "Failed to launch $cmd on $computername. ReturnValue is" $remote.ReturnValue -ForegroundColor RED
    }
}

#Sample usage
#New-RemoteProcess -comp "puck" -cmd "c:\windows\notepad.exe"
