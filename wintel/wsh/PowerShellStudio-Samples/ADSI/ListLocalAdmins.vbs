'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ListLocalAdmins.vbs
'
'	Comments:
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

On Error Resume Next

strComputer="localhost"

Set objLocalAdmins=GetObject("WinNT://" & strComputer & "/Administrators,Group")

If Err.Number = 0 Then
    
    Set memberList=objLocalAdmins.Members
    For Each member In memberList
        WScript.Echo member.ADSPath
    Next
Else
   WScript.Echo "Failed to connect to " & strComputer & ". Error#" & Err.Number
End If
