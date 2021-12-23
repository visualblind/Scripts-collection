'==========================================================================
'
' VBScript Source File -- Created with SAPIEN Technologies PrimalScript 2011
'
' NAME: 
'
' AUTHOR: Alexander Riedel , SAPIEN Technologies, Inc.
' DATE  : 9/12/2007
'
' COMMENT: 
'
'==========================================================================

Dim oftp

Set oftp = CreateObject("Primalscript.FTPTransfer")
oftp.Passive = 1 ' set the passive flag if needed
' oftp.Port =  ' Set whatever port you are using if not the default ftp port
if oftp.Connect("ftp.microsoft.com","","") = 0 Then
	WScript.Echo oftp.Status
else
	WScript.Echo "Starting download"
	If oftp.Get("/developr/visual_c/readme.txt","C:\ms_readme.txt") = 0 Then
		WScript.Echo oftp.Status
	Else
		WScript.Echo "Download complete"
	End If
	oftp.Disconnect
end If

