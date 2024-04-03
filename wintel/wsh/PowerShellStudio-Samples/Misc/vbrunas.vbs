' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: VBRUNAS.VBS 
' 
' 	Comments:
'	USAGE:  cscript|wscript VBRUNAS.VBS Username Password Command
'	DESC: A RUNAS replacement to take password at a command prompt.
'	NOTES: This is meant to be used for local access.  If you want to run a command
'	across the network as another user, you must add the /NETONLY switch to the RUNAS 
'	command.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY And/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

On Error Resume Next
dim WshShell,oArgs,FSO

set oArgs=wscript.Arguments

 if InStr(oArgs(0),"?")<>0 then
   wscript.echo VBCRLF & "? HELP ?" & VBCRLF
   Usage
 end if

 if oArgs.Count <3 then
   wscript.echo VBCRLF & "! Usage Error !" & VBCRLF
   Usage
 end if

sUser=oArgs(0)
sPass=oArgs(1)&VBCRLF
sCmd=oArgs(2)

set WshShell = CreateObject("WScript.Shell")
set WshEnv = WshShell.Environment("Process")
WinPath = WshEnv("SystemRoot")&"\System32\runas.exe"
set FSO = CreateObject("Scripting.FileSystemObject")

if FSO.FileExists(winpath) then
 'wscript.echo winpath & " " & "verified"
else
 wscript.echo "!! ERROR !!" & VbCrLf & "Can't find or verify " & winpath &"." & VbCrLf &_
  "You must be running Windows 2000 for this script to work."

 wscript.quit
end if

rc=WshShell.Run("runas /user:" & sUser & " " & CHR(34) & sCmd & CHR(34), 2, FALSE)

Do until WshShell.AppActivate (WinPath) 
Wscript.Sleep 5 
WshShell.AppActivate (WinPath) 
loop 
WshShell.SendKeys sPass 

wscript.quit

'************************
'*  Usage Subroutine    *
'************************
Sub Usage()
On Error Resume Next
msg="Usage: cscript|wscript vbrunas.vbs Username Password Command" & VbCrLf & VbCrLf &_
 "You should use the full path where necessary and put long file names or commands" & vbcrlf &_
  "with parameters in quotes" & vbcrlf & VbCrLf & "For example:" & vbcrlf &_
   " cscript vbrunas.vbs domain\admin P@ssw0rd122 e:\scripts\admin.vbs" &_
    VbCrLf & vbcrlf &" cscript vbrunas.vbs domain\admin P@ssw0rd123 " & CHR(34) &_
     "c:\program files\scripts\admin.vbs 1stParameter 2ndParameter" & CHR(34)& vbcrlf &_
      vbcrlf & vbcrlf & "cscript vbrunas.vbs /?|-? will display this message."

wscript.echo msg

wscript.quit

end sub
