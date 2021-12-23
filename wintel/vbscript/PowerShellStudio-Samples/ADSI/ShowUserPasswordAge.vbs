'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ShowUserPasswordAge.vbs
'
'	Comments: Display user's password age in days in a pop-up window.
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
Dim objNetwowrk
Dim objShell

'Set the number of seconds to display the message before it disappears.  User
'can click OK at any time.
Const DisplayFor=10

Set objNetwowrk=CreateObject("wscript.Network")
Set objShell=CreateObject("wscript.shell")

'display user's password age
Dim objUser
Set objUser=GetObject("WinNT://" & objNetwowrk.userDomain & "/"&objNetwowrk.Username &",user")
PassAge=INT(objUser.PasswordAge/86400)

'Password age message to display
PassMsg="Your password is " & PassAge & " days old."

objShell.Popup PassMsg,DisplayFor,"Password Age",0+64

Set objShell=Nothing
Set objNetwowrk=Nothing

'EOF
