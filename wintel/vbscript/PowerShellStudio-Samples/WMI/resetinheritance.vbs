' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: ResetInheritance.vbs 
' 
' 	Comments:
'	USAGE: cscript ResetInheritance.vbs foldername inherit|noinherit
'	for example cscript ResetInheritance.vbs c:\users\jhicks noinherit
'
' 	DESCRIPTION: Using WMI set whether folder should be enabled for permissions
'	inheritance or not.  If second parameter is set to ON, then folder will inherit parent
'	folder permissions.  If set to OFF, parent permissions are not inherited.  Any 
'	existing settings will remain but show as not inherited.
'
'	If there are any spaces in the folder name, you must put the path in quotes ""
'
'	It is recommended to use CSCRIPT when executing this script
'	This script does not verify for folder existance

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

On Error Resume Next

Dim oWmi
Dim oRef
Dim oArgs
On Error Resume Next
set oArgs=WScript.Arguments

If oArgs.Count<2 Then
strHelpMsg="USAGE: cscript ResetInheritance.vbs foldername inherit|noinherit" & vbcrlf &_
"	for example: cscript ResetInheritance.vbs c:\users\jhicks noinherit" & vbcrlf & vbcrlf &_
"DESCRIPTION: Using WMI set whether folder should be enabled for permissions" & vbcrlf &_
"inheritance or not.  If second parameter is set to ON, then folder will inherit parent" & vbcrlf &_
"folder permissions.  If set to OFF, parent permissions are not inherited.  Any " & vbcrlf &_
"existing settings will remain but show as not inherited." & vbcrlf & vbcrlf &_
"If there are any spaces in the folder name, you must put the path in quotes " & Chr(34) & Chr(34)

WScript.Echo strHelpMsg
WScript.Quit
End if

f=oArgs(0)

Select Case UCASE(oArgs(1))
Case "INHERIT" iInheritance=33796
Case "NOINHERIT" iInheritance=37892
Case Else 
	WScript.Echo "You entered an invalid inheritance choice: " & oArgs(1) & "  Please try again."
	WScript.Quit
End Select

strFile=Replace(f,"\","\\")

strQuery="Select * from Win32_Directory WHERE Name='" & strFile & "'"

Set oWmi=GetObject("winmgmts:{(Security,Restore)}")
If Err.Number Then
  strErrMsg= "Error connecting to WINMGMTS" & vbCrlf
  strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
        If Err.Description <> "" Then
            strErrMsg = strErrMsg & "Error description: " & Err.Description & "." & vbCrlf
        End If
  Err.Clear
  wscript.echo strErrMsg
  wscript.quit
End If

Set oRef=oWmi.ExecQuery(strQuery) 
If Err.Number Then
  strErrMsg= "Error connecting executing query!" & vbCrlf
  strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
        If Err.Description <> "" Then
            strErrMsg = strErrMsg & "Error description: " & Err.Description & "." & vbCrlf
        End If
  Err.Clear
  wscript.echo strErrMsg
  wscript.quit
End If

Call SetInheritance(strFile,iInheritance)

WScript.quit

'************************************************************************************
' Set Inheritance Flag Subroutine
'************************************************************************************
Sub SetInheritance(strFile,iInheritance)
Dim objFile
Dim objDescriptor
'On Error resume next
WScript.Echo "Resetting inheritance on " & strFile & " to " & iInheritance
strFileQuery="Select * from Win32_LogicalFileSecuritySetting WHERE Path='" & _
strFile & "'"

Set objFile=oWMI.ExecQuery(strFileQuery)

For Each item In objFile
 r=item.GetSecurityDescriptor(objDescriptor)
'uncomment next lines to display control flag information
 'WScript.Echo strfile
 'WScript.Echo "Control Flag:" & objDescriptor.ControlFlags
 'WScript.Echo decodeControlBits(objDescriptor.ControlFlags)
objDescriptor.ControlFlags=iInheritance
'objDescriptor.ControlFlags=37892	'no inheritance
'objDescriptor.ControlFlags=33796	'inheritance enabled
j=item.SetSecurityDescriptor(objDescriptor)
Next

Set objFile=Nothing
Set objDescriptor=Nothing

End Sub

'decode controlbits
Function decodeControlBits(c)
Dim s
If c And 32768 Then s=s + "Self-Relative,"
If c And 8192 Then s=s + "SACL Protected,"
If c And 4096 Then s=s + "DACL Protected,"
If c And 2048 Then s=s + "SACL auto inherited,"
If c And 1024 Then s=s + "DACL auto inherited,"
If c And 512 Then s=s + "SE_SACL_AUTO_INHERIT_REQ,"
If c And 256 Then s=s + "SE_DACL_AUTO_INHERIT_REQ,"
If c And 32 Then s=s + "Default SACL,"
If c And 16 Then s=s + "SACL present,"
If c And 8 Then s=s + "DACL defaulted,"
If c And 4 Then s=s + "DACL Present,"
If c And 2 Then s=s + "SE_group defaulted,"
If c And 1 Then s=s + "SE_Owner defaultd,"
decodeControlBits=s
End function

'EOF
