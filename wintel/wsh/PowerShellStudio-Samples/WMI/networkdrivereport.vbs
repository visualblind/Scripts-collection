' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: NETWORKDRIVEREPORT.VBS 
' 
' 	Comments:
'	Generate an HTML page showing free space in color-coded graphical format 
'	of logical drives from a text list of servers.
'	NOTES:  The target servers must be running Windows 2000/2003 or if NT, have the WMI 
'	core installed.  You must run this script under a domain admin account.
'	The server list should look like (without the apostrophe):
'	server01
'	dc1
'	file23

'	There is an option to mail the report as well.  By default the line calling the
'	routine is disabled.  You need to run the script on a server with SMTP installed
'	in order for this to work.  You might run to run this as a scheduled task on a server
'	on a weekly basis and email the report, or create it in an IIS virtual directory.

'	You are better off using cscript to run this.

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

Dim objService,objLocator
Dim objFSO, objOutFile,objFile1
Dim objNetwork

On Error Resume Next

'YOU MUST SPECIFY THE FOLLOWING VARIABLES 

'where do you want the file saved
htmFile="\\Server01\public\ServerFreeSpaceReport.htm"

'This is a text list of server names.  Do not use \\ before the server name
serverlist="servers.txt"

Const myGreen="008000"
Const myRed="FF0000"
Const myYellow="FFD700"

set objNetwork=CreateObject("wscript.network")
Set objFSO=CreateObject("Scripting.FileSystemObject")
Set objOutFile=objFSO.CreateTextFile(htmFile)
Set objFile1=objFSO.OpenTextFile(serverlist,1)

objOutfile.WriteLine "<HTML><HEAD><TITLE>Server Logical Drive Utilization</TITLE></HEAD>"
'objOutfile.WriteLine "<BODY BGCOLOR=" & CHR(34) & "FFFFF" & CHR(34)& ">"
objOutfile.WriteLine "<BODY BGCOLOR=FFFFF>"
objOutfile.WriteLine	"<H1>Server Utilization Report</H1></P>"

Do While objFile1.AtEndOfStream<>True
strServer=objFile1.ReadLine

 If strServer<>"" Then
 wscript.Echo "Checking " & strServer
'reinitialize
    PerFree=""
	Graph=""
	Size=""
	Free=""

 objOutfile.WriteLine "<BR>" & UCASE(strServer) & " Drive Utilization<BR><HR>"

'Create locator
    Set objLocator = CreateObject("WbemScripting.SWbemLocator")
    If Err.Number then
	 objOutfile.WriteLine "Error " & err.number & " [0x" & CStr(Hex(Err.Number)) & "] occurred in creating a locator object.<BR>"
	  If Err.Description <> "" Then
            objOutfile.WriteLine "Error description: " & Err.Description & ".</p>"
      End If
        Err.Clear
     End If

	'Connect to the namespace which is either local or remote
	'Uncomment next line for debugging
	'wscript.echo "Connecting to " & "("&strServer&",root\cimv2)"

 Set objService = objLocator.ConnectServer (strServer,"root\cimv2")
ObjService.Security_.impersonationlevel = 3
  If Err.Number then
	objOutfile.WriteLine "Error " & err.number & " [0x" & CStr(Hex(Err.Number)) &"] occurred in connecting to server " & UCASE(strServer) & ".<BR>"
	objOutfile.WriteLine "Make sure you are using valid credentials that have administrative rights on this server.</P>"
        If Err.Description <> "" Then
            objOutfile.WriteLine "Error description: " & Err.Description & ".</P>"
        End If
        Err.Clear
   Else
   
 	objOutfile.WriteLine "<Table Border=0 CellPadding=5>"
 	For Each item In objService.InstancesOf("Win32_LogicalDisk")
	 	If item.DriveType=3 Then 	'get local drives only
			PerFree=FormatPercent(item.FreeSpace/item.Size,2)
			Graph=FormatNumber((item.Freespace/1048576)/(item.Size/1048576),2)*100
			Size=FormatNumber(item.Size/1048576,0) & " MB"
			Free=FormatNumber(item.FreeSpace/1048576,0) & " MB"
	
			objOutfile.WriteLine "<TR>"
			objOutfile.WriteLine "<TD>" &item.DeviceID & "\ </TD>"
			objOutfile.WriteLine "<TD>Size: " & Size & "</TD>"
			objOutfile.WriteLine "<TD>Free: " & Free & "</TD>" 
			objOutfile.WriteLine "<TD><B><Font Size=+1 Color=" & GraphColor(graph) & ">" & String(Graph,"|") & "</Font></B></TD>"
			objOutfile.WriteLine "<TD>" & PerFree & " Free</TD></TR>"
	    End If
Next
	objOutfile.WriteLine "</Table>"
	End If
 End If
Loop
objFile1.Close

objOutfile.WriteLine("</P><Font Size=-1><B><I> Created " & NOW & " by " & objNetwork.UserName & "</I></B></Font>")
objOutfile.WriteLine("</BODY></HTML>")

objOutfile.Close

'comment out the next line if you will run this unattended
wscript.Echo VBCRLF & "See " & htmfile & " for results"

'uncomment the next line if you want to send the report.
'SendMail

'**********************************
'*  Send email copy of report     *
'**********************************
Sub SendMail()
On Error Resume Next
'You must have SMTP installed on the workstation or server executing this script in 
'order for mail to work.

dim objMsg,objFSO,file

CONST strFile="\\IT01\web\freespacereport.htm"
set objMsg=CreateObject("CDO.Message")
set objFSO=CreateObject("Scripting.FileSystemObject")
set objFile=objFSO.OpenTextFile(strFile,1)
objMsg.To	="me@jcompany.com"
objMsg.Subject="Free Space Report"
objMsg.From= "NetworkGuardian@company.com"

do while objFile.AtEndOfStream<>True
	objMsg.HTMLBody=objMsg.HTMLBody & objFile.ReadLine
Loop
objFile.Close

objMsg.Send

End Sub

'**********************************
'*  Set color for graph function  *
'*   depending on free space      *
'**********************************
Function GraphColor(graph)
On Error Resume Next
	If Graph > 30 Then
	 GraphColor=myGreen
	 Exit Function
	End If
	If Graph < 10 Then
	 GraphColor=myRed
	Else
	 GraphColor=myYellow
	End If
End Function

'**********************************
'*  Check Response subroutine     *
'**********************************
Sub CheckResponse(response)
	If response="" Then
		wscript.Echo "You didn't enter anything in the last input box or you cancelled the script."
		wscript.Quit
	End If		
End Sub

'EOF