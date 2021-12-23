'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  GetDomainDistinguishedName.vbs
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

'Get Domain Distinguished Name

On Error Resume Next
dim objRoot
dim objDom
Set objRoot = GetObject("LDAP://RootDSE")

'this will return something like dc=MyCompany,dc=local
strDomainPath = objRoot.Get("DefaultNamingContext")

Set ObjDom = GetObject("LDAP://" & strDomainPath)

'this will return something like LDAP://dc=MyCompany,dc=local
strDomainDN=objDom.ADSpath
'this will return something like dc=Mycompany
strDomainName=objDom.Name

wscript.Echo "The distinguished name of your domain is " & strDomainDN

