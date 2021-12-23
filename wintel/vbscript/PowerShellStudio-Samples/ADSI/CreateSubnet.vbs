' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: CreateSubnet.vbs 
' 
' 	Comments:  Create AD sites from a CSV list.
'
' 	CSV file has entries for SubnetRDN,SiteobjectRDN,Description,Location
' Example:
'   Subnet,Siteobject,Description,Location
'	cn=192.168.1.0/26,Default-First-Site-Name,Atlanta Office,USA/GA/Atlanta
'
' 	You can leave location blank but be sure to have a trailing comma after
' 	Description.  Description might also be an office name. A header line is assumed.
' 	The first line of the file will be skipped.
'
'	The site must already exist. You need to be a member of the Enterprise
' 	Admins group to run this script or have delegated permissions.
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
Dim objFSO, objFile
Dim objNetwork
Const ForReading=1

'set to TRUE to enable command line tracing.  You must use CSCRIPT To
'run the script.
blnDebug=False

'name and path of CSV file
strCSV="NewSubnets.csv"

Trace "Starting " & WScript.ScriptFullName
Trace "Source file="  & strCSV

strTitle="Create New AD Subnets"
Trace "Creating script objects"

Set objNetwork=CreateObject("WScript.Network")

Trace "Running script as " & objNetwork.UserDomain &_
"\" & objNetwork.UserName

Set objFSO=CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists(strCSV) Then
	Trace "Opening " & strCSV & " for reading"
	Set objFile=objFSO.OpenTextFile(strCSV,ForReading)
	objFile.SkipLine
	Do While objFile.AtEndOfStream<>True
		r=objFile.ReadLine
		tmpArray=Split(r,",")
		Trace "Calling AddSubnet " & "CN=" & tmpArray(0) &_
		"," & "CN=" & tmpArray(1) & "," & tmpArray(2) &_
		"," & tmpArray(3)
		AddSubnet "CN=" & tmpArray(0),"CN=" & tmpArray(1),tmpArray(2),tmpArray(3)
	Loop
	Trace "Closing " & strCSV
	'close the file
	objFile.Close
	MsgBox "Finished creating subnets.",vbOKOnly+vbInformation,strTitle
Else
'file not found
	Trace "Could not find " & strCSV
	MsgBox strCSV & " not found.",vbOKOnly+vbCritical,strTitle
End If

Trace "End script."
WScript.Quit

Sub AddSubnet(strSubnetRDN,strSiteObjectRDN,strDescription,strLocation)
On Error Resume Next
'strSubnetRDN     = "cn=192.168.1.0/26"
'strSiteObjectRDN = "cn=Ga-Atl-Sales"
'strDescription   = "Atlanta Office"
'strLocation      = "USA/GA/Atlanta"
Dim objRootDSE,objSubnetsContainer,objSubnet
 
Set objRootDSE = GetObject("LDAP://RootDSE")
Trace "Getting configurationNamingContext"
strConfigurationNC = objRootDSE.Get("configurationNamingContext")
Trace strConfigurationNC.ADSPath
 
strSiteObjectDN = strSiteObjectRDN & ",cn=Sites," & strConfigurationNC
Trace "SiteDN: " &  strSiteObjectDN

strSubnetsContainer = "LDAP://cn=Subnets,cn=Sites," & strConfigurationNC
Trace "Getting subnets container" 

Set objSubnetsContainer = GetObject(strSubnetsContainer)

Trace "Creating " & strSubnetRDN 
Set objSubnet = objSubnetsContainer.Create("subnet", strSubnetRDN)
Trace "Putting " & strSiteObjectDN
objSubnet.Put "siteObject", strSiteObjectDN
Trace "Putting " & strDescription
objSubnet.Put "description", strDescription
Trace "Putting " & strLocation
objSubnet.Put "location", strLocation
Trace "Calling SetInfo"
objSubnet.SetInfo
Trace "Returned Error# " & Err.Number & " " & Err.Description
Err.Clear

End Sub

Sub Trace(strMsg)
On Error Resume Next
	'You MUST use CSCRIPT to execute the 
	'script so that information is echoed to the command console.  
	'Only use in interactive debugging and development.

	if blnDebug Then WScript.Echo Now & " [TRACE] " & strMsg
End Sub