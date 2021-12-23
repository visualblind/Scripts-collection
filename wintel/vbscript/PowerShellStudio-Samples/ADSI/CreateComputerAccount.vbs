'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CreateComputerAccount.vbs
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

'Create Computer Object
On Error Resume Next
dim objDomain
dim objPC

Const ADS_UF_PASSWD_NOTREQD            = &h0020 
Const ADS_UF_WORKSTATION_TRUST_ACCOUNT = &h1000 

'name of new computer object
strCName="XP001"

'connect to the top level container you want to create the computer
Set objDomain = GetObject("LDAP://CN=Computers,DC=Hogwarts,DC=local")
Set objPC = objDomain.Create("computer", "CN=" & strCName)
objPC.sAMAccountName=strCName & "$"
objPC.userAccountControl=ADS_UF_PASSWD_NOTREQD Or ADS_UF_WORKSTATION_TRUST_ACCOUNT 
objPC.SetInfo

