' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: LISTSHARES.VBS 
' 
' 	Comments:
'	Usage: cscript //nologo listshares.vbs servername
'	Notes: Enumerate all shares as well as getting NTFS permissions for the root
'	of each share.  Logs output to servername-S.txt.  If the file already exists, it 
'	will be overwritten.
'	Script maps Z: to each share and then executes CACLS in order to capture
'	NTFS permissions.  Any existing connections to Z: will be removed.
'	This works for all shares, visible and hidden, but it won't display 
'	admin shares such as C$.

'	It is STRONGLY recommended to run this from a command prompt using cscript.

'	If you want to do a list of computers, create a text list of computers:
'	server01
'	server02
'	server03

'	At a prompt run the following command from the same directory as this script:

'	for /f %i in (servers.txt) do @cscript listshares.vbs %i

' 	This script requires WSH 5.6 to be installed on the computer running this
' 	script.  If you aren't sure what version you are running open a command prompt
' 	and run cscript //logo
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
dim strSrv, objShare
dim objNetwork, wshell
dim objFSO, objFile
dim objExec
iCounter=0
if Wscript.Arguments.Count <1 then
 wscript.echo VBCRLF& "OOPS! You failed to specify a server." & VBCRLF
 ShowUsage
 Wscript.quit
end if

if Wscript.Arguments.Count >0 then
  if Wscript.Arguments(0)="/?" then
	wscript.echo VBCRLF
	ShowUsage
 	wscript.quit
  end if
strSrv=Wscript.Arguments(0)
end if

'name of log file.  Default is computername-shares.txt
strLog=strSrv& "-Shares.txt"

Set wshell=Wscript.Createobject("Wscript.Shell")
Set objNetwork = WScript.CreateObject("WScript.Network")
Set objFSO=CreateObject("Scripting.FileSystemObject")
Set objFile=objFSO.CreateTextFile(strLog)

objFile.Writeline "Checking Server " & strSrv & " for Shares - " & NOW & vbcrlf

wscript.echo "Checking Server " & strSrv & " for Shares."
set objShare= GetOBJect("WinNT://" & strSrv &"/lanmanserver")
If err.number<>0 then
  objFile.WriteLine "Error #"&err.number& ": " & err.description
  objFile.WriteLine "There was a problem connecting to " &strSrv
Else
  WScript.echo "Server Name = " & strSrv
 For Each share in objShare
  iCounter=iCounter+1
  WScript.echo "Examining " & share.name
  objFile.WriteLine "Share Name = " & share.name
  objFile.WriteLine "  Share Path = " & share.path
  objFile.WriteLine "  Description = " & share.description
  MapIt strSrv,share.name
 Next
  objFile.WriteBlankLines(2)
  objFile.WriteLine "Enumerated " & iCounter & " shares."
End If

objFile.Close
wscript.Echo "See " & strLog & " for results of share audit."

wscript.quit

'//////////////////////////
'/      Map & Check       /
'//////////////////////////
'Map Drive
Sub MapIt(server,share)
On Error Resume Next
'uncomment for debugging
'wscript.echo "mapping " & "\\"&server&"\"&share

'remove any existing mappings to Z:
objNetwork.RemoveNetworkDrive "Z:"

objNetwork.MapNetworkDrive "Z:", "\\"&server&"\"&share
set objExec=wShell.Exec("cacls Z:\")
do while objExec.StdOut.AtEndOfStream <>True
 	 objFile.WriteLine objExec.StdOut.Readline
     WScript.Sleep 100
Loop

objNetwork.RemoveNetworkDrive "Z:"

End Sub

'//////////////////////////
'/      Show Usage        /
'//////////////////////////

Function ShowUsage
wscript.echo "Usage: " & Wscript.ScriptName
wscript.echo "Cscript listshares.vbs [servername]"
wscript.echo " Example: cscript listshares.vbs filesrv01" & VBCRLF
wscript.echo "Cscript listshares.vbs /? will display this help message"

End Function
