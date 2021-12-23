# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  IsManagable.ps1
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

Function IsManageable {
    param([string]$Computer,
    [System.Management.Automation.PSCredential]$credential)
    
    if ($credential) 
        {
    #use alternate credentials if supplied
          $sb={(Get-WmiObject win32_operatingsystem -computer $Computer `
    -credential $credential -erroraction SilentlyContinue).caption} 
         }
    else {
    #use existing credentials
        $sb={(Get-WmiObject win32_operatingsystem -computer $Computer `
    -erroraction SilentlyContinue).caption}
         }
    
     if (&$sb -IS [STRING])
        {
            Return $TRUE
        }
     else
        {
            Return $false
        }
} #end function
