# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  pwdage.ps1
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

Function Get-PassAge {
  Param([string]$Computername = (Read-Host "Enter a computername:"),
        [string]$Username = (Read-Host "Enter username:  "))
 
[ADSI]$user="WinNT://$Computername/$Username,User"
[int]$pwdAge=$user.passwordAge.value
[int]$pwdMax=$user.maxPasswordAge.value
[datetime]$now=Get-Date
[datetime]$pwdSet=$now.AddSeconds(-$pwdAge)
[datetime]$pwdExpires=$pwdSet.AddSeconds($pwdMax)
 
$obj = New-Object PSObject
 
$obj | Add-Member NoteProperty "Computer" $Computername.toUpper()
$obj | Add-Member NoteProperty "Username" $Username
$obj | Add-Member NoteProperty "PasswordAge" ($pwdAge/86400 -as [int])
$obj | Add-Member NoteProperty "PasswordSet" $pwdSet
$obj | Add-Member NoteProperty "PasswordExpires" $pwdExpires
 
Write $obj

}

Get-PassAge $env:computername administrator

