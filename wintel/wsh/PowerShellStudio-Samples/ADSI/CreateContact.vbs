'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CreateContact.vbs
'
'	Comments:
'	this creates a simple contact in Active Directory.  
'	If you have Exchange 2000/2003, you must mail-enable
'	the contact
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

'Create Contact

On Error Resume Next

dim objOU
dim objContact

strFirst="Roy"
strLast="Biv"
strMail="roy@vendor.com"

'get a connection to the container you want to create the contact in.  You
'can hard code or use a RootDSE reference to the root
set objOU=GetObject("LDAP://OU=contacts,dc=company,dc=local")
Set objContact=objOU.Create("contact","CN=" & strFirst & " " & strLast)
objContact.FirstName=strFirst
objContact.lastName=strLast
objContact.DisplayName=strFirst & " " & strLast
objContact.Mail=strMail
objContact.SetInfo

