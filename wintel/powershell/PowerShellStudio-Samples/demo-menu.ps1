# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Demo-Menu.ps1
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

Function Show-Menu {

$menu="Help Desk Tasks `n" +`
"1 `t show info abount a computer `n" +`
"2 `t show info about someones mailbox `n" +`
"3 `t restarts the print spooler or empties queue `n" +`
"Q `t quit `n" +`
"Select a menu choice"

$rc=Read-Host $menu
write $rc

} 

Do {
    Switch (Show-Menu) {
     "1" {Write-Host "run get info code"} 
     "2" {Write-Host "run show mailbox code"}
     "3" {Write-Host "restart spooler"}
     "Q" {Write-Host "Goodbye";Return}
    
    }
} While ($True)

