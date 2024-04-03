' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: ChangeLocalAdmin.vbs 
' 
' 	Comments:
'	USAGE: cscript changelocaladmin.vbs servername newpassword
'	DESC: Change local administrator password on specified server.
'	NOTES:You should use CSCRIPT to run this.  You must have domain admin rights
'	to run this script.

'	If you want to execute this for multiple computers, create a text file of 
'	computer names like this (without the apostrophe):

'		Server01
'		Server02
'		Server03

'	Put the text file and script in the same directory.  Open a command prompt.
'	type FOR /F %i in (servers.txt) do @changelocaladmin.vbs %i NewP@ssword123

'	This will read the text file passing the computer name as the first parameter
'	to the script.  You'll supply the new password as the second parameter.
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
dim strServer,strPass
dim objUser

if Wscript.Arguments.Count <2 then
 wscript.echo VBCRLF& "OOPS! You failed to specify a server and/or password." & VBCRLF
 ShowUsage
 Wscript.quit
end if

if Wscript.Arguments.Count >0 then
  if Wscript.Arguments(0)="/?" then
	wscript.echo VBCRLF
	ShowUsage
 	wscript.quit
  end if
strServer=Wscript.Arguments(0)
strPass=wscript.Arguments(1)
end if

set objUser=GetObject("WinNT://" & strServer & "/administrator,user")
if err.number<>0 then
 wscript.echo "Error connecting to " & strServer
 wscript.echo "Error " & err.number & " " & err.description
 wscript.quit
end if
objUser.SetPassword strPass
objUser.SetInfo
if err.number<>0 then
 wscript.echo "Error setting new Administrator password on " & strServer
 wscript.echo "Error " & err.number & " " & err.description
 wscript.quit
end if

set objUser=Nothing
wscript.quit
'//////////////////////////
'/      Show Usage        /
'//////////////////////////

Function ShowUsage
wscript.echo "Usage: " & Wscript.ScriptName
wscript.echo "Cscript changelocaladmin.vbs servername newpassword"
wscript.echo " Example: cscript changelocaladmin.vbs filesrv01 P@ssw0rd12i" & VBCRLF
wscript.echo "Cscript changelocaladmin.vbs /? will display this help message"

End Function