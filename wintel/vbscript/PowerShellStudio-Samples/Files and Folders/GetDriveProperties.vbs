'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  GetDriveProperties.vbs
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

'Get Drive Properties
On Error Resume Next

dim objFSO
dim objDrv

'drive we want to know about
strDrv="c:\"

set objFSO=CreateObject("Scripting.FileSystemObject")
'get reference to drive
set objDrv=objFSO.GetDrive(strDrv)

'list properties

'if volume name isn't defined then state that
if objDrv.VolumeName="" then
	wscript.Echo "Volume Name:" & vbtab & "NOT DEFINED"
else
	wscript.Echo "Volume Name:" & vbtab & objDrv.VolumeName
end if
wscript.Echo "Serial Number:" & vbtab & objDrv.SerialNumber

Select Case objDrv.DriveType
	Case 0  strType="Unknown"
	Case 1  strType="Removable"
	Case 2  strType="Fixed"
	Case 3  strType="Remote"
	Case 4  strType="CDROM"
	Case 5  strType="RamDisk"
	Case Else	strType="Unknown"
end Select

wscript.Echo "Drive Type:" & vbtab  & strType
wscript.Echo "Is Ready:" & vbtab & objDrv.IsReady
wscript.Echo "File System:" & vbtab & objDrv.FileSystem
wscript.Echo "Total Size (bytes):" & vbtab & objDrv.TotalSize
wscript.Echo "Available Space (bytes):" & vbtab & objDrv.AvailableSpace
wscript.Echo "Free Space (bytes):" & vbtab & objDrv.FreeSpace

