'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CreateOU.vbs
'
'	Comments:
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

'Create OU
On Error Resume Next

dim objDomain
dim objOU

'name of OU to create
strCName="OnScript Users"

'get a connection to the container you want to create the OU in.  You
'can hard code or use a RootDSE reference to the root
set objDomain=GetObject("LDAP://OU=Students,DC=myschool,dc=local")
set objOU=objDomain.Create("organizationalUnit","OU=" & strCName)
objOU.Description="SAPIEN Users OU"

objOU.SetInfo

