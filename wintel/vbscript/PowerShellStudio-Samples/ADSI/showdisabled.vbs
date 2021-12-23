' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: SHOWDISABLED.VBS 
' 
' 	Comments: Show disabled user accounts and account description.
' 	Usage: cscript|wscript showdisabled.vbs 
'	Output is to a  CSV file you can specify below.  Any existing versions of
'	the file will be overwritten.
'
'	You must run this with domain admin credentials on any computer that is in 
'	the domain.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE And INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

On Error Resume Next
Dim objDomain
Dim wshNetwork
Dim fso,f
strLog="DisabledAccounts.csv"
Set fso=CreateObject("Scripting.FilesystemObject")
Set f=fso.CreateTextFile(strLog,True)

Set wshNetwork=CreateObject("wscript.network")

set objdomain = GetObject("WinNT://" & wshNetwork.UserDomain)

If err.number<>0 Then
wscript.echo "There was a problem connecting to the domain!"
wscript.quit
End If

objDomain.filter = array("user")
wscript.echo "BUILDING DISABLED USER ACCOUNTS FOR LIST FOR " & UCASE(wshNetwork.UserDomain)
f.writeline "USER,FULLNAME,DESCRIPTION"

for each x in objDomain
  if x.AccountDisabled then f.writeline x.name & "," & x.fullname & "," & CHR(34) & x.Description & CHR(34)
Next

f.Close

wscript.echo "Finished auditing.  See " & strLog & " for details."

Set fso=Nothing
Set f=Nothing
set objDomain=Nothing

WScript.Quit
'EOF
