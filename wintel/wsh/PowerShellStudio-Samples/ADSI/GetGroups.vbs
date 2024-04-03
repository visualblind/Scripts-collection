' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File:  GetGroups.vbs 
' 
' 	Comments: List all groups of a specified type in a given domain.
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
Dim rootDSE
Dim mydomain
Dim conn
Dim cat
Dim cmd
Dim rs

Const ADS_GROUP_TYPE_GLOBAL_GROUP 			= &h00000002
Const ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP  	= &h00000004
Const ADS_GROUP_TYPE_LOCAL_GROUP         	= &h00000004
Const ADS_GROUP_TYPE_UNIVERSAL_GROUP     	= &h00000008
Const ADS_GROUP_TYPE_SECURITY_ENABLED    	= &h80000000

sGroupScope = ADS_GROUP_TYPE_GLOBAL_GROUP or ADS_GROUP_TYPE_SECURITY_ENABLED

set RootDSE=GetObject("LDAP://RootDSE")
set myDomain=GetObject("LDAP://"&RootDSE.get("DefaultNamingContext"))

strQuery="Select cn,distinguishedname,groupType from '" & _
myDomain.ADSPath & "' Where objectclass='group' AND GroupType='" & sGroupScope & "'"

WScript.Echo strQuery

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
do while not RS.EOF
 wscript.Echo rs.Fields("distinguishedname")
 rs.movenext
loop
rs.Close
conn.Close	

'EOF