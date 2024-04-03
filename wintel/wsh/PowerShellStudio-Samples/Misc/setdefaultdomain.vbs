' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: SetDefaultDomain.vbs 
' 
' 	Comments: Set the HKLM Winlogon registry key to specify the default domain
'that shows up in the Windows logon dialog box.  This is especially useful after
'migrating a computer and user account and you want the user to not have to worry
'about what domain they are logging onto.  It might be very useful to set this as
'a computer startup script at the domain level so it affects all computer accounts
'in a given domain.
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

On Error Resume Next

Dim oShell

If WScript.Arguments.Count<1 Then
 m="Missing Parameter!" & vbcrlf 
 m=m & "Usage: cscript " & LCase(WScript.ScriptName) & " domainname" & VBCRLF
 m=M & "for example: cscript " & LCase(WScript.ScriptName) & " MyCompany & VBCRLF
 WScript.Echo m
 WScript.Quit
End if

Set oShell=CreateObject("Wscript.Shell")
strDomain=UCase(WScript.Arguments.Item(0))

'next lines are for debugging
' WScript.Echo "DefaultDomainName is " & oShell.RegRead("HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName")
' WScript.Echo "AltDefaultDomainName is " & oShell.RegRead("HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AltDefaultDomainName")
' WScript.Echo "Setting new default domain to " & strDomain

oShell.RegWrite "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName",strDomain
oShell.RegWrite "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AltDefaultDomainName",strDomain

Set oShell=Nothing

'EOF
