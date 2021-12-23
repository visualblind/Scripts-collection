'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CreateNewGroup.vbs
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

'Create Group
dim objDomain
dim objGrp

'name of new group
strCName="New Interns"
'SAMAccount name of new group.  This is the pre-Windows 2000 name
strSAM="NewInterns"

'these constants determine what type of group to create
Const ADS_GROUP_TYPE_GLOBAL_GROUP 			= &h00000002
Const ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP  	= &h00000004
Const ADS_GROUP_TYPE_LOCAL_GROUP         	= &h00000004
Const ADS_GROUP_TYPE_UNIVERSAL_GROUP     	= &h00000008
Const ADS_GROUP_TYPE_SECURITY_ENABLED    	= &h80000000

'connect to the top level container you want to create the group in
Set objDomain = GetObject("LDAP://CN=Users,DC=mycompany,DC=local")
Set objGroup = objDomain.Create("group", "CN=" & strCName)

objGroup.sAMAccountName=strSAM
'if you want to security enable the group you must OR ADS_GROUP_TYPE_SECURITY_ENABLED
'like the next line.  Otherwise you will only have a distribution group
objGroup.GroupType=ADS_GROUP_TYPE_GLOBAL_GROUP or ADS_GROUP_TYPE_SECURITY_ENABLED
objGroup.Description="New Summer Interns"
objGroup.SetInfo

