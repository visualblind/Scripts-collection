'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  IfMember.vbs
'
'	Comments:Sample code demonstrating how to find group membership and map drives accordingly
'
'   Disclaimer: This source code is intended only as a supplement to 
'				SAPIEN Development Tools and/or on-line documentation.  
'				See these other materials for detailed information 
'				regarding SAPIEN code samples.
'
'	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
'	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
'	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
'	PARTICULAR PURPOSE.
'
'**************************************************************************

dim UserObj
dim objNetwork

set objNetwork=CreateObject("WScript.Network")

set UserObj = GetObject("WinNT://" & objNetwork.UserDomain & "/" & objNetwork.UserName)
For Each Group In UserObj.groups
'based on name of group that user is a member of, map certain drives and printers
'or execute any other code

'We compare using UPPERCASE to avoid any confusion or errors
     Select Case UCASE(Group.Name)
             Case "SALESUSERS"
			objNetwork.MapNetworkDrive "G:", "\\Server03\Grp1Data"
			objNetwork.AddPrinterConnection "LPT1", "\\PrtSvr\HP001"
             Case "ITUSERS"
			objNetwork.MapNetworkDrive "G:", "\\Server03\Grp2Data"
			objNetwork.AddPrinterConnection "LPT1", "\\PrtSvr\HP002"
             Case "EXECUTIVEUSERS"
			objNetwork.MapNetworkDrive "G:", "\\Server03\Grp3Data"
			objNetwork.MapNetworkDrive "H:", "\\Server04\Accounting"
			objNetwork.MapNetworkDrive "I:", "\\Server04\Finance"
			objNetwork.AddPrinterConnection "LPT1", "\\PrtSvr\HP001"
			objNetwork.AddPrinterConnection "LPT2", "\\PrtSvr\HPColor"
     End Select
Next          
'Map enterprise wide drives that everyone gets
			objNetwork.MapNetworkDrive "P:", "\\Server01\Public"
			objNetwork.MapNetworkDrive "Z:", "\\Server99\NetShare"

