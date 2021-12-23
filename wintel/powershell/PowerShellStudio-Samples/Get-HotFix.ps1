# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Get-Hotfix.ps1
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
# ==============================================================================================
# 
# Microsoft PowerShell Source File -- Created with SAPIEN Technologies PrimalScript 2011
# 
# NAME: Get-Hotfix.ps1
# 
# AUTHOR: Jeffery Hicks , SAPIEN Technologies
# DATE  : 8/5/2008
# 
# COMMENT: This script uses WMI to query the Win32_QuickFixEngineering
# class on a specified computer. The script can take a computername and
# a PSCredential as parameters. The default computername is the localhost.
#
# The script uses the original WMI object, but modifies a few properties
# to make them more user and PowerShell friendly.

# EXAMPLES:
# .\Get-HotFix | Format-Table HotFixID,Caption,Description,InstalledOn -auto
# .\Get-HotFix | Sort Description | Format-Table -groupby Description,HotFixID,Caption -auto

# .\Get-HotFix DESK23 $cred | select Description,Caption,HotfixID,Install*

# Get-Content ("computers.txt") | ForEach {
# .\get-hotfix $_ $admin } | 
# sort CSName,InstalledOn | 
# Format-Table -groupby CSName InstalledOn,HotFixID,Description,Installedby | 
# Out-File c:\reports\hotfixes.txt

# .\get-hotfix | sort InstalledOn | 
# Select InstalledOn,Installedby,HotfixID,Description,Caption | 
# ConvertTo-Html | out-file c:\reports\qfe.html

 
#QFE Class properties
# Status
# Caption
# CSName
# Description
# FixComments
# HotFixID
# InstallDate
# InstalledBy
# InstalledOn
# Name
# ServicePackInEffect

#  ****************************************************************
#  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
#  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.       * 						  * 
#  ****************************************************************

# ==============================================================================================

Param([string]$computername=$env:computername,
      [System.Management.Automation.PSCredential]$credential)
    
#function to return int64 UTC dates from Vista to a user friendly
#format
    Function Parse-UTC64 {
     Param([string]$value=0)   
     
    #Sample $value='01c7e70de43f747f'
    
     $value=[system.Int64]::Parse($value,[System.Globalization.NumberStyles]::AllowHexSpecifier)
     
     [system.DateTime]::FromFileTimeUtc($value)
       
    }


#set to Continue if you want to see Warning messages
$WarningPreference="SilentlyContinue"

#Set to Continue if you want to see Debug messages
$DebugPreference="SilentlyContinue"

#Set to Continue if you want to disable the 
#function's error handling
$errorActionPreference="SilentlyContinue"

Write-Debug "Starting Get-Hotfix function"

If ($credential) {
    Write-Debug ("Using alternate credentials:{0}" -f $credential.username)
 }       

#my error handling traps
Trap {
    if ($_.Exception -match "RPC server is unavailable") {
        Write-Warning "$computername is not available via RPC."
        continue
    }
    
    elseif ($_.Exception -match "access is denied") {
        Write-Warning "Access denied to $computername."
        continue
    }
    else {
        Write-Warning "There was an error"
        Write-Warning $_
        continue
    }
}
     
    
if ($qfe) {
    Write-Debug "Removing leftover `$qfe variable"
    Remove-Variable qfe
}

Write-Host "Querying hotfixes on $computername" -foregroundcolor Cyan

$cmd="Get-WmiObject -class win32_quickfixengineering -computername $Computername -ErrorAction 'Stop'"


if ($credential) {
    $cmd=$cmd + " -credential `$credential"
 }

Write-Debug "Scanning $computername"
Write-Debug $cmd

$qfe=Invoke-Expression $cmd
      
if ($qfe.count -eq 0) {
    Write-Debug "No quick fix engineering patches found on $computername."
    Write-Warning "No quick fix engineering patches found on $computername."
    
}
else {
    Write-Debug ("Found {0} hotfixes on {1}" -f $qfe.count,$Computername)
    
    foreach ($hotfix in $qfe) {
        Write-Debug ("ID {0}" -f $hotfix.HotFixID)                     
 
        if ($hotfix.Installedby -match "S-") {
                                
            $sid=$hotfix.Installedby
            Write-Debug "converting $sid to username"
            #WMI should use cached connection, even if alternate credentials were used
            $user=Get-WmiObject win32_useraccount -computername $Computername -filter "SID='$sid'"
            
            if ($user) {
                $installedBy="{0} [{1}]" -f $user.caption,$user.FullName
            }
            else {
                $installedBy="Not found"
            }
            
            Write-Debug $installedBy
            
            #overwrite existing existing property
            $hotfix | Add-Member NoteProperty -name "Installedby" -value $Installedby -force

            }
        
           
        #if queried system is Vista convert InstalledOn to a "real" date
       
        if ($hotfix.InstalledOn.length -eq 16) {
            Write-Debug ("Converting {0} to a date" -f $hotfix.InstalledOn)
            $InstalledOn=Parse-UTC64 $hotfix.InstalledOn
        }
        else {
            #convert existing value to a date if it is something like
            #20080405
            if ($hotfix.installedOn -match "\d{8}") {
            Write-Debug ("Parsing {0}" -f $hotfix.InstalledOn)
              $i=$hotfix.installedOn
              [datetime]$InstalledOn="{0}/{1}/{2}" -f $i.substring(0,4),$i.substring(4,2),$i.substring(6,2)
              }
            else {
                #leave it alone but make it a datetime if it exists
                if ($hotfix.InstalledOn -match "/") {
                    Write-Debug ("Setting {0} to [datetime]" -f $hotfix.InstalledOn)
                    [datetime]$InstalledOn=$hotfix.InstalledOn
                 }
                 else {
                    Write-Debug "InstalledOn is most likely empty"
                    [datetime]$InstalledOn="1/1/1970"
                 }
            }
        }
        
        $hotfix | Add-Member NoteProperty -name "InstalledOn" -value $InstalledOn -force -passthru

        write $hotfix
        
        #remove variables to avoid any surprises next time through
        #the loop
        "User","sid","installedby,installedOn" | foreach {
            Remove-Variable $_ | Out-Null
        }
    
    } #end Foreach hotfix
  } #end else  
   
Write-Debug "Ending Get-Hotfix "

# EOF

