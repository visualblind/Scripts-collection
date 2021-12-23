' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: GetExchangeAdminGroups.vbs 
' 
' 	Comments: Get the distinguishedName, CN and Name of all Exchange
' Administrative Groups in your Exchange organization.
' You should use CSCRIPT to run this.  Requires access to a Global Catalog
' server.
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
Dim objRootDSE
Dim objConfiguration
Dim cat
Dim conn
Dim cmd
Dim RS
Set objRootDSE = GetObject("LDAP://rootDSE")

strConfiguration = "LDAP://" & objRootDSE.Get("configurationNamingContext")
Set objConfiguration = GetObject(strConfiguration)

strQuery="Select name,cn,distinguishedname from '" & _
objConfiguration.ADSPath & "' Where objectclass='msExchAdminGroup'"

strResults=""
set cat=GetObject("GC:")
for each obj in cat
 set GC=obj
Next

set conn=Createobject("ADODB.Connection")
set cmd=CreateObject("ADODB.Command")
conn.Provider="ADSDSOObject"
conn.Open	

set cmd.ActiveConnection=conn
set RS=conn.Execute(strQuery)
do while not RS.EOF
 DN=rs.Fields("distinguishedname")
 CN=RS.Fields("cn")
 NM=RS.Fields("name")
  WScript.Echo "Name: " & NM
  WScript.Echo "CN: " & CN
  WScript.Echo "DN: " & vbcrlf & DN
 rs.movenext
Loop
rs.Close
conn.Close	

'EOF