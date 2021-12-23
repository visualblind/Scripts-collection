'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ActiveXposh.vbs
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
Dim ActiveXPosh

Const OUTPUT_CONSOLE = 0
Const OUTPUT_WINDOW = 1
Const OUTPUT_BUFFER = 2

Function CreateActiveXPosh()
	Dim success

	' Create the PowerShell connector object
	Set ActiveXPosh = CreateObject("SAPIEN.ActiveXPoSH")
	success = ActiveXPosh.Init(vbFalse) 'Do not load profiles
	If success <> 0 then
		WScript.Echo "Init failed"
	end if
	If ActiveXPosh.IsPowerShellInstalled Then
	 WScript.Echo "Ready to run PowerShell commands"
	Else
	 WScript.Echo "PowerShell not installed"
	End If
	'Set the output mode 
	ActiveXPosh.OutputMode = OUTPUT_CONSOLE
End Function

Function DownloadFile(URL,Destination)
	Dim Command
	Dim FSO
	
	'Download a file with PowerShell
	ActiveXPosh.Execute("$Client = new-object System.Net.WebClient")
	'Note that variables are preserved between calls
	' Construct a command
	Command = "$Client.DownloadFile('" & URL & "','" & Destination & "')"
	WScript.Echo "Downloading ..."
	ActiveXPosh.Execute(Command)
	
	Set FSO = CreateObject("Scripting.FileSystemObject")
	If FSO.FileExists(Destination) Then
		WScript.Echo "File transfer complete"
	Else
		WScript.Echo "File Transfer failed"
	End If
End Function

Function ListServices()
	Dim outtext
	' Set the output mode to buffer
	ActiveXPosh.OutputMode = OUTPUT_BUFFER
	ActiveXPosh.Execute("Get-WmiObject -class Win32_Service | Format-Table -property Name, State")
	
	' Get the output line by line and add it to a variable 
	For Each str In ActiveXPosh.Output 
	 	outtext = outtext & str
	 	outtext = outtext & VbCrLf
	Next
	
	' Alternatively you can get the output as a single String
'	outtext = ActiveXPosh.OutputString
	
	WScript.Echo outtext
	ActiveXPosh.ClearOutput() ' Empty the output buffer
End Function

' Create the actual Object
CreateActiveXPosh

Status = ActiveXPosh.GetValue("(Get-Service UPS).Status")
if(Status = "Stopped") then
   WScript.Echo "UPS Service is stopped"
else
   WScript.Echo "UPS Service is " & Status
end If


' List all running processes using PowerShell
ActiveXPosh.Execute("Get-Process")

' Check if WinWord is running using PowerShell
if ActiveXPosh.Eval("get-process winword") = vbTrue Then
	WScript.Echo "Microsoft Word is running"
Else
	WScript.Echo "Microsoft Word is not running"
End If

DownloadFile "http://support.sapien.com/bulletins/sb563.pdf","C:\Temp\sb563.pdf"

' Use  ListServices to show all services in this machine using PowerShell
ListServices

WScript.Echo ActiveXPosh.GetValue("$PSHOME")
Set ActiveXPosh = Nothing
