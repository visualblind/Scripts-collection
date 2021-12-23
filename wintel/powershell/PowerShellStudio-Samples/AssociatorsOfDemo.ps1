# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  AssociatorsOfDemo.ps1
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
$Computer = $env:computername
$Service="termservice"

$query="Associators of {Win32_Service.Name='$Service'} Where AssocClass=Win32_DependentService Role=Dependent"
Get-WmiObject -query $query -computername $Computer | Add-Member noteproperty "Role" "Dependent" -passthru |select Role,Displayname,Name

$query="Associators of {Win32_Service.Name='$Service'} Where AssocClass=Win32_DependentService Role=Antecedent"
Get-WmiObject -query $query -computername $Computer | Add-Member noteproperty "Role" "Antecedent" -passthru|select Role,Displayname,Name





