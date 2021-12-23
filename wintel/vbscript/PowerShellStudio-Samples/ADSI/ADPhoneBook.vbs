' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: ADPhoneBook.vbs 
' 
' 	Comments:
'	This is sample code you could use to create a phone book
'	based on user account information in Active Directory
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

Dim objConn,objCmd,objRS 
Set objConn=Createobject("ADODB.Connection")
Set objCmd=CreateObject("ADODB.Command")
Set objRoot=Getobject("LDAP://RootDSE")
Set objDomain=Getobject("LDAP://"& objRoot.get("DefaultNamingContext"))
strQuery="Select cn,telephonenumber,physicaldeliveryofficename,mail from '" & _ 
 objDomain.AdsPath & "' Where objectCategory='person' AND " & _
 "objectclass='user'"
set objCatalog=Getobject("GC:")
for each objItem In objCatalog
    Set objGC=objItem
Next
objConn.Provider="ADSDSOobject"
objConn.Open "Active Directory Provider"
objCmd.ActiveConnection=objConn
objCmd.Properties("Page Size") = 100
objCmd.Properties("asynchronous")=True
objCmd.Properties("Timeout") =30
objCmd.Properties("Cache Results") = False
objCmd.CommandText=strQuery
set objRS=objCmd.Execute
do while not objRS.EOF
   WScript.Echo objRS.Fields("cn")
   WScript.Echo objRS.Fields("telephonenumber")
   WScript.Echo objRS.Fields("physicaldeliveryofficename")
   WScript.Echo objRS.Fields("mail")
    objRS.movenext
Loop
objRS.Close
objConn.Close

