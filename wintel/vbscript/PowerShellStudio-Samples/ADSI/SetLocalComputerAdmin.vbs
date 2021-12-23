' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: SetLocalComputerAdmin.vbs 
' 
' 	Comments:
' 	USAGE: cscript SetLocalComputerAdmin.vbs [domain\username1,domain\username2]
'	NOTES: Add specified users to the computer's local administrator's
'	group. The username must be in the format domain\samAccountName.
'	You can enter as many names as you want, separated by commas. You can
'	specify a global or universal group as well by following the same format.
'
'	Obviously, you need local administrative credentials to run this script.
'	One recommended method is to run this as a computer startup script
'	specifying a user or group as a runtime parameter.
'
'	Results and errors will be recorded in the local application log.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY And/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

Option Explicit
Dim objLocalAdmins,memberList,member
Dim strTitle,strPrompt,AddedUsers
Dim arrAddedUsers,x
Dim objItem,itemPath
Dim objShell,strMsg

On Error Resume Next
'settings for input box
strTitle=WScript.ScriptName
strPrompt="Enter the names of users and/or groups to add to add " _
& "to the local administrator group. Names must be separated by commas " _
& "and in the format domain\name."
'Event log constants
Const SUCCESS=0
Const ERROR=1
Const WARNING=2
Const INFORMATION=4

If WScript.Arguments.Count=1 Then
    AddedUsers=WScript.Arguments.Item(0)
Else
    AddedUsers=InputBox(strPrompt,strTitle,"mydomain\jdoe")
    'bail if nothing entered or cancelled
    If AddedUsers="" Or AddedUsers=-1 Then WScript.Quit
End If

Set objShell=CreateObject("WScript.Shell")

Set objLocalAdmins=GetObject("WinNT://./Administrators,Group")
'uncomment next lines for debug information or to list current members
' Set memberList=objLocalAdmins.Members
' For Each member In memberList
'     WScript.Echo member.name
' Next

arrAddedUsers=Split(AddedUsers,",")
For x=0 To UBound(arrAddedUsers)
    'uncomment for debugging
    'WScript.Echo "Adding " & arrAddedUsers(x)
    'change format from domain\user to domain/user so we
    'can reuse in the GetObject command
    'Note: It is possible to add a user or group without
    'specifying a domain name. However, specifying a domain
    'removes any ambiguity or the possibility of adding the
    'wrong user or group.
     itemPath=Replace(arrAddedUsers(x),"\","/")
    'Get object
    Set objItem=GetObject("WinNT://" & itemPath)
    
    'if user not found, then record an error
    If objItem.ADSPath="" Then
        strMsg= "Could not add WinNT://" & itemPath &_
        " to the local administrator's group." & VbCrLf &_
            "Error #" & Err.Number &" " & Err.Description
        objShell.LogEvent ERROR,strMsg
    Else
        'otherwise:
        'Take ADSpath and add to local administrators group
        objLocalAdmins.Add objItem.ADSPath
        objLocalAdmins.SetInfo
        If Err.Number<>0 Then
        'error handling just in case something goes wrong
            strMsg="Failed to add WinNT://" & itemPath &_
            " to the local administrator's group." & VbCrLf &_
            "Error #" & Err.Number &" " & Err.Description
            objShell.LogEvent WARNING, strMsg
        Else
            'successfully added entry
            strMsg="Added WinNT://" & itemPath &_
            " to the local administrator's group."
            objShell.LogEvent SUCCESS, strMsg
        End if
    End If
Next

WScript.quit
