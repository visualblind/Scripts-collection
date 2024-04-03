' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: Login.vbs
' 
' 	Comments:
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

Dim obj

Set obj = WScript.CreateObject("Primalscript.LoginDlg")

obj.Title = "Fancy Login"
obj.User = "Preset User"
obj.ShowDialog()

If obj.WasOk = True Then
	' WScript.Echo obj.UserName
	' The UserName property still exists for compatibility
	' Use the "User" property in new scripts
	WScript.Echo obj.User
	WScript.Echo obj.Password
End If 






