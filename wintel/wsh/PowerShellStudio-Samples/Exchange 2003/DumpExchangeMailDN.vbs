' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: DumpExchangeMailDN.vbs 
' 
' 	Comments:
'	Get the distinguished names of all the private mailbox stores in your Exchange
' 	organization on a specified server.  It is recommended you run this with cscript.  
' 	If you want to save the results use standard console redirection:
'	cscript //nologo DumpExchangeMailDN.vbs > mymail.txt
'
' 	You can execute this on the Exchange server on any client workstation that has the
' 	Exchange Adminstrator tools installed.
'
'	 The distinguished names will be very long.  When you use the names in other scripts, make
' 	sure you don't "wrap" the name.
'
' 	You will be prompted for a server name.
' 
'   Disclaimer: This source code is intended only as a supplement To 
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
Dim objRootDSE,objConfiguration
Dim cat,conn
Dim cmd,RS
Set objRootDSE = GetObject("LDAP://rootDSE")
x=1
strSrv=InputBox("What Exchange server do you want to list?","Dump Exchange Mail Stores","Exchange01")
	If strSrv="" Then
		WScript.Echo "Nothing entered or you cancelled."
		WScript.Quit
	End if

strConfiguration = "LDAP://" & objRootDSE.Get("configurationNamingContext")
Set objConfiguration = GetObject(strConfiguration)

strQuery="Select name,cn,distinguishedname from '" & _
objConfiguration.ADSPath & "' Where objectclass='msExchPrivateMDB'"	

set cat=GetObject("GC:")
for each obj in cat
 set GC=obj
Next

AdsPath=GC.ADSPath

set conn=Createobject("ADODB.Connection")
set cmd=CreateObject("ADODB.Command")
conn.Provider="ADSDSOObject"
conn.Open	

set cmd.ActiveConnection=conn
set RS=conn.Execute(strQuery)
WScript.Echo "Mailbox stores on " & UCase(strSrv) & ":"
Do while not RS.EOF
	 DN=rs.Fields("distinguishedname")
	 CN=RS.Fields("cn")
	 NM=RS.Fields("name")
	 If InStr(UCase(DN),UCase(strSrv)) Then 
		WScript.Echo x & ") " &DN
		'WScript.Echo "Name: " & NM
		'WScript.Echo "CN: " & CN
		x=x+1
	End If
	rs.movenext
Loop
rs.Close
conn.Close	

'EOF
