# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  PowerShellPrompts.ps1
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
# NAME: Prompts.ps1
# 
# AUTHOR: Jeffery Hicks , SAPIEN Technologies
# DATE  : 2/5/2009
# 
# COMMENT: 	A collection of prompt functions to use in your PowerShell Profile. Simply copy the
#           prompt function you want to use into your profile.
#		   	You can also copy and paste the functions into your PowerShell session
#			to see the effect.
# 
# ==============================================================================================


Function prompt {
    #PoSH C:\temp >
    "PoSH " + $(get-location) + " >"
 }


 Function Prompt {
    #Tue 6/5/2007 2:43:02 PM PS C:\temp >  
    #prompt is in Yellow
    
    Switch ((get-date).dayofweek.toString()) {
        Sunday {$dow="Sun"}
        Monday {$dow="Mon"}
        Tuesday {$dow="Tue"}
        Wednesday {$dow="Wed"}
        Thursday {$dow="Thu"}
        Friday {$dow="Fri"}
        Saturday {$dow="Sat"}
    }
    
    $myPrompt=$dow+ " " + (get-date).ToShortDateString() + `
    " " + (get-date).ToLongTimeString()+ " PS " + `
    $(get-location) + " >"
        Write-Host ($myPrompt) -nonewline -fore Yellow
        return " "
}


# Function prompt {
    #PS C:\temp[2:44 PM] >

    "PS " + $(get-location) + "[" + (get-date).ToShortTimeString()+ "] > "
    
}

Function prompt {
    #PS [SAPIEN\JHICKS 3:03 PM] C:\temp >
    "PS [" +($env:UserDomain).ToUpper() + "\" + ($env:Username).ToUpper() + `
    " " +(get-date).ToShortTimeString()+`
     "] " + $(Get-Location) + " > "
}

Function Prompt {
    #PS [SAPIEN\jhicks] C:\temp >
    $Global:CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    "PS [" + $CurrentUser.Name + "] " + $(Get-Location) + " > "
}

Function Prompt {
    #PSH GODOT C:\temp >
    "PSH " + $env:Computername + " " +  $(Get-Location) + " > "
}

Function Prompt {
    #[GODOT\jhicks] PSH C:\temp >
    #Colored Red if user has admin rights
    #colored Green if regular user
    
    $Global:CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = new-object System.Security.principal.windowsprincipal($CurrentUser)
    if ($principal.IsInRole("Administrators")) {
    $fore="Red"
    }
    else {
    #colors for non admin
    $fore="Green"
    }
    
    $myPrompt="[" + $CurrentUser.Name +"] PSH " +  $(Get-Location) + " > "
    Write-Host ($myPrompt) -nonewline -fore $fore 
    
    return " "
}

function Prompt {
    #Install SAPIEN Community extensions and use Write-Speech to 
    #speak the current directory
    Get-Location | Write-Speech 
    $myPrompt="PSH " +  $(Get-Location) + " > "
    Write-Host ($myPrompt) -nonewline
    return " "
}

Function Prompt {
    #[137] PSH C:\temp >
    # You need to define $global:i=0
    # in your profile before you run this function
    # You can reset $i to 0 at any time if you want
    # to "reset" the prompt counter
    $global:i++
    "["+$i+"] PSH " +  $(Get-Location) + " > "
}

Function Prompt {
    #[CPU:7% Procs:66] PS C:\temp >
    
    $cpu=(gwmi win32_processor).loadpercentage
    $pcount=(Get-Process).Count
    
    "[CPU:" + $cpu + "% Procs:"+$pcount +"] PS " +  $(Get-Location) + " > "
}

Function Prompt {
    #[6/6/2007 11:08 AM CPU:1% Procs:71] PS S:\ >
    
    $cpu=(gwmi win32_processor).loadpercentage
    $pcount=(Get-Process).Count
    
    "[" + (Get-Date -format g)+ " CPU:" + $cpu + "% Procs:"+$pcount +"] PS " +  $(Get-Location) + " > "

}

Function Prompt {
    $shortpath=$null
    #truncate long path names
    #use pwd to see full local path
    $p=(Get-Location).ToString()
    $arrayParts=@($p.Split("\"))
    foreach ($part in $arrayParts) {
    if ($part.length -gt 4) {
    	$shortpath=$shortpath+$part.Remove(4)+"..\"
    	}
    	else {
    		$shortpath=$shortpath+$part+"\"
    	}
    }
    
    "PSH "+ $shortpath + "> "

}

Function Prompt {
    $shortpath=$null
    #truncate long path names
    #use pwd to see full local path
    #full path set in Window Title
    $p=(Get-Location).ToString()
    $arrayParts=@($p.Split("\"))
    foreach ($part in $arrayParts) {
    if ($part.length -gt 4) {
    	$shortpath=$shortpath+$part.Remove(4)+"..\"
    	}
    	else {
    		$shortpath=$shortpath+$part+"\"
    	}
    }
    
    "PSH "+ $shortpath + "> "
    $host.ui.rawui.set_WindowTitle("Windows PowerShell: " + (get-location))
}

Function prompt {

    $text="PSH " +(Get-Date -format g) + " " +(Get-Location) + " > "
    
    $myPrompt=[char]0x250c
    $myPrompt=$myPrompt+([char]0x2500).ToString()*$text.length
    $myPrompt=$myPrompt+[char]0x2510
    $myPrompt=$myPrompt+"`n"
    $myPrompt=$myPrompt+([char]0x2502)+$text+([char]0x2502)
    $myPrompt=$myPrompt+"`n"
    $myPrompt=$myPrompt+[char]0x2514
    $myPrompt=$myPrompt+([char]0x2500).ToString()*$text.length
    $myPrompt=$myPrompt+[char]0x2518
    Write-Host $myPrompt -fore Green -nonewline
    Write-Host "->" -nonewline
    return " "
    
}

Function Prompt {
    $shortpath=$null
    #truncate long path names
    #use pwd to see full local path
    #full path set in Window Title
    $p=(Get-Location).ToString()
    $arrayParts=@($p.Split("\"))
    foreach ($part in $arrayParts) {
    if ($part.length -gt 4) {
    	$shortpath=$shortpath+$part.Remove(4)+"..\"
    	}
    	else {
    		$shortpath=$shortpath+$part+"\"
    	}
    }
    
    "PSH "+ $shortpath + "> "
    $host.ui.rawui.set_WindowTitle("Windows PowerShell: " + (get-location))
}


Function prompt {
    #this function requires the Show-Weather function to be loaded
    #$global:zip should be defined in your function for your zip code
    
    #add global variable if it doesn't already exist
    if ($global:LastCheck -eq $Null) {
    	$global:LastCheck=Get-Date
    }
    if ($global:weather -eq $Null) {
    	$global:weather=Show-Weather $global:zip
    }
    if ($global:cddrive -eq $Null) {
        [wmi]$Global:cdrive=gwmi -query "Select * from win32_logicaldisk where deviceid='c:'"
    }
    
    #only refresh weather and disk check once every 15 minutes
    $min=(New-TimeSpan $Global:lastCheck).TotalMinutes
    if ($min -ge 15) {
    $global:weather=Show-Weather $global:zip
    [wmi]$Global:cdrive=gwmi -query "Select * from win32_logicaldisk where deviceid='c:'"
    $global:LastCheck=Get-Date
    }
    
    $w=([char]0x263c)+" "+$Global:weather.Condition +" "+$Global:weather.Temp
    $cpu=(gwmi win32_processor).loadpercentage
    $pcount=(Get-Process).Count
    $diskinfo=" Free C:"+"{0:N2}" -f (($global:cdrive.freespace/1gb)/($global:cdrive.size/1gb)*100)+"%"
    #get uptime
    $time=Get-WmiObject -class Win32_OperatingSystem
    $t=$time.ConvertToDateTime($time.Lastbootuptime)
    [TimeSpan]$uptime=New-TimeSpan $t $(get-date)
    $up="$($uptime.days)d $($uptime.hours)h $($uptime.minutes)m $($uptime.seconds)s"
    
    $text="CPU:"+$cpu+"% Procs:"+$pcount+$diskinfo+ " "+([char]0x25b2)+$up +" "+`
    (Get-Date -format g)+" "+$w
    
    $myPrompt=[char]0x250c
    $myPrompt=$myPrompt+([char]0x2500).ToString()*$text.length
    $myPrompt=$myPrompt+[char]0x2510
    $myPrompt=$myPrompt+"`n"
    $myPrompt=$myPrompt+([char]0x2502)+$text+([char]0x2502)
    $myPrompt=$myPrompt+"`n"
    $myPrompt=$myPrompt+[char]0x2514
    $myPrompt=$myPrompt+([char]0x2500).ToString()*$text.length
    $myPrompt=$myPrompt+[char]0x2518
    Write-Host $myPrompt -fore Green 
    Write-Host "PS $(Get-Location) >" -nonewline
    return " "
}


Function prompt {
    #PSH S:\PoSH <green right pointing triangle>
    Write-Host "PSH $(get-location) " -nonewline -fore yellow
    Write-Host ([char]0x25ba) -fore Green -nonewline
    Return " "
 }
