'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CreateNewUser.vbs
'
'	Comments:Create a user account in Active Directory
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

'Create User

dim objContainer
dim objRoot
dim objUser

'user's first name
strFirst="William"
'user's last name
strLast="Shakespeare"
'the user's name
strUser=strFirst & " " & strLast
'the user's SAMAccount or logon name
strSAM="wshakes"
'Description
strDescription="System Administrator"
'Department
strDepartment="Information Systems"
'Telephone
strPhone="555-0001"
'the user's password
strPass="P@ssw0rd"

'get distinguished name of the domain
Set objRoot = GetObject("LDAP://RootDSE")
strDomainPath = objRoot.Get("DefaultNamingContext")

'enter the relative distinguished name of the OU or container
'that you want to create the user account in.  You do not need
'to specify the domain component

strContainer="CN=Users"
set objContainer=GetObject("LDAP://" & strContainer & "," & strDomainPath) 
'This code will is the minimum you need to create a 
'user object in Active Directory
set objUser=objContainer.Create ("User","cn=" & strUser)
objuser.Put "samAccountName",strSAM
'we need to write this information to Active Directory
objUser.SetInfo
'we can't set the password until after the user account has first
'been created.
objUser.SetPassword(strPass)
objUser.SetInfo

'Now that user object is created, let's set some properties
'the following is a sample of additional and optional attributes
'you can set

'If account should be disabled,then set the following to TRUE
objUser.AccountDisabled=False
objUser.GivenName=strFirst
objUser.SN=strLast
'set display name to be the same as the username
objUser.DisplayName=strUser
objUser.Department=strDepartment
objUser.Description=strDescription
objUser.TelephoneNumber=strPhone
objUser.UserPrincipalName=strSAM & "@mycompany.com"
objUser.SetInfo


