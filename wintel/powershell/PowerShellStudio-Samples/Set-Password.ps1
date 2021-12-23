# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Set-Password.ps1
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

#change an account password for a member server or desktop

Function Set-Password {
 Param([string]$computer=$env:computername,
         [string]$account="Administrator",
         [string]$password="P@ssw0rd"
      )

    $errorActionPreference="silentlyContinue"
  
    [adsi]$user="WinNT://$computer/$account,user"
    #get current password age
    [int]$oldage=$user.passwordage[0]
    if ($user.name) {
        $user.SetPassword($password)
        sleep -milliseconds 500
        }
    else {
        $msg="Failed to get $account on "+$computer.toUpper()
        Write-Warning $msg
        return
    }
    
    #refresh object and check to make sure pass
    #word was changed
    $user.psbase.refreshcache()
    if ($user.passwordage -gt $oldage) {
        $msg="Failed to change password for $account on "+$computer.toUpper()
        Write-Warning $msg  
    }

}

#examples:
# this will use the function's default password
# Set-Password -computer dogtoy -account nobody

# You don't have to use parameter names provided you use all 3
# Set-Password server01 administrator N3wP@$$

#process a list using the defaults
# "server1","server2","server3" | foreach { set-password $_ }

#process a list using a different password
# "server1","server2","server3" | foreach { set-password $_ administrator "N3wP@%%w0rd"}

#or use Get-content to read a list
# get-content servers.txt | foreach { set-password $_ administrator "N3wP@%%w0rd"}
