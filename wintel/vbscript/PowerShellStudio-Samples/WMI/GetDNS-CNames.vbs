' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: GetDNS-CNames.vbs 
' 
' 	Comments:
'	sample script showiung how to use the MicrosoftDNS namespace in WMI.
'	The target server must be running Windows 2003.
'	Use Cscript to run this from a command line because it displays a lot
'	of information.
' 
'   Disclaimer: This source code is intended only as a supplement To 
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
Dim strComputer
Dim objWMIService
Dim propValue
Dim objItem
Dim SWBemlocator
Dim UserName
Dim Password
Dim colItems

'Specify the name of the Windows 2003 DNS/DC
strComputer = "DNS01"
'Alternate credentials if you need them
UserName = ""
Password = ""
Set SWBemlocator = CreateObject("WbemScripting.SWbemLocator")
Set objWMIService = SWBemlocator.ConnectServer(strComputer,"\root\MicrosoftDNS",UserName,Password)
Set colItems = objWMIService.ExecQuery("Select * from MicrosoftDNS_CNAMEType",,48)
For Each objItem in colItems
	WScript.Echo "Caption: " & objItem.Caption
	WScript.Echo "ContainerName: " & objItem.ContainerName
	WScript.Echo "Description: " & objItem.Description
	WScript.Echo "DnsServerName: " & objItem.DnsServerName
	WScript.Echo "DomainName: " & objItem.DomainName
	WScript.Echo "InstallDate: " & objItem.InstallDate
	WScript.Echo "Name: " & objItem.Name
	WScript.Echo "OwnerName: " & objItem.OwnerName
	WScript.Echo "PrimaryName: " & objItem.PrimaryName
	WScript.Echo "RecordClass: " & objItem.RecordClass
	WScript.Echo "RecordData: " & objItem.RecordData
	WScript.Echo "Status: " & objItem.Status
	WScript.Echo "TextRepresentation: " & objItem.TextRepresentation
	WScript.Echo "Timestamp: " & objItem.Timestamp
	WScript.Echo "TTL: " & objItem.TTL
Next
