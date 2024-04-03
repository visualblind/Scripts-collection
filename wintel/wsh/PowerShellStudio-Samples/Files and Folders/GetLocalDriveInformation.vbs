'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  GetLocalDriveInformation.vbs
'
'	Comments: get local drive utilization
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

dim objFSO,collDrv
dim fs,d

set objFSO=wscript.CreateObject("Scripting.FileSystemObject")
set collDrv=objFSO.Drives
  for each drv in collDrv
	if drv.DriveType=2 then		'check fixed drives only
   		Set fs = CreateObject("Scripting.FileSystemObject")
    		Set d = fs.GetDrive(fs.GetDriveName(drv))
		t = FormatNumber(d.TotalSize/(1024*1024), 0)
    		f = FormatNumber(d.FreeSpace/(1024*1024), 0) 
		u = 100-FormatNumber(f/t,2)*100 
	 	s= s & drv & "  " & drv.VolumeName & " (" & drv.FileSystem & ")" & vbtab &_
	 	 t & " MB Total"& vbtab & f & " MB Free" & vbtab &  u & "% Utilized" & vblf
	end if
  next

wscript.echo s

