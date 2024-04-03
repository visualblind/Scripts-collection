'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  AddUserToGroup.vbs
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

'Add User to a Group

dim objGrp

strGrpDN="LDAP://CN=AllWizards,OU=Wizards,DC=TheShire,DC=Local"
strUserDN="LDAP://CN=Gandalf Grey,OU=Wizards,DC=TheShire,DC=Local"

'connect to the group object in Active Directory
set objGrp=GetObject(strGrpDN)
'once we have a connection then use the ADD method specifying
'the distinguished name of the user object to add
objGrp.Add(strUserDN)