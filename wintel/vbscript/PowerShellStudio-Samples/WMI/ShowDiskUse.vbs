'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ShowDiskUse.vbs
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

On Error Resume Next
Dim strComputer
Dim objWMIService
Dim propValue
Dim objItem
Dim SWBemlocator
Dim UserName
Dim Password
Dim colItems

strComputer = "."
UserName = ""
Password = ""
Set SWBemlocator = CreateObject("WbemScripting.SWbemLocator")
Set objWMIService = SWBemlocator.ConnectServer(strComputer,"root\CIMV2",UserName,Password)
'only return sizes about fixed local disks
Set colItems = objWMIService.ExecQuery("Select * from Win32_LogicalDisk where drivetype=3")
For Each objItem in colItems
	WScript.Echo "DeviceID: " & objItem.DeviceID
	WScript.Echo "FreeSpace: " & FormatNumber((objItem.FreeSpace/1048576),2) & " MB"
	WScript.Echo "Size: " & FormatNumber((objItem.size/1048576),2) & " MB"
	iUsed=objItem.Size - objItem.Freespace
	WScript.Echo "Used: " & FormatNumber((iUsed/1048576),2) & " MB"
	WScript.Echo VbCrLf
Next
