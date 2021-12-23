' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: QuickDN.vbs 
' 
' 	Comments: This function returns a user's distinguished name from their
' samAccount name
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
 Dim oUser,oArgs
 Set oArgs=WScript.Arguments
 strUser=oArgs(0)
 UserDN=GetDN(strUser)
 WScript.Echo UserDN
 WScript.quit

Function GetDN(samAccount)
On Error Resume Next
 GetDN=samAccount & " NotFound"
 set RootDSE=GetObject("LDAP://RootDSE")
 set myDomain=GetObject("LDAP://"&RootDSE.get("DefaultNamingContext"))
'the query should all be on one line
 strQuery="Select sAMAccountname,cn,distinguishedname from '" & _
myDomain.ADSPath & "' Where objectcategory='person' AND objectclass='user'" & " AND sAMAccountName='" & samAccount & "'"

 set cat=GetObject("GC:")
 for each obj in cat
  set GC=obj
 next
 AdsPath=GC.ADSPath
 set conn=Createobject("ADODB.Connection")
 set cmd=CreateObject("ADODB.Command")
 conn.Provider="ADSDSOObject"
 conn.Open	
 set cmd.ActiveConnection=conn
 set RS=conn.Execute(strQuery)
 do while not RS.EOF
  GetDN=rs.Fields("distinguishedname")
  rs.movenext
 Loop
 rs.Close
 conn.Close	

End Function
'EOF
