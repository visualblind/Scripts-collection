'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  GetUserProperties.vbs
'
'	Comments: sample showing how to display some user properties
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

'Get User Properties


dim objUser
strUserDN=("LDAP://CN=Jim Shortz,CN=Users,DC=Company,DC=Local")

set objUser=GetObject(strUserDN)

strResults="User properties for " & objUser.DisplayName & vbcrlf
strResults=strResults & "Department:" & vbtab & objUser.Department & vbcrlf
strResults=strResults & "Description:" & vbtab & objUser.Description & vbcrlf
strResults=strResults & "Phone:" & vbtab & objUser.TelephoneNumber & vbcrlf

wscript.Echo strResults
