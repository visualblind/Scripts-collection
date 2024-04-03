'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  SMTPQueueMonitor.vbs
'
'	Comments:
'	This script will query SMTP queues on an Exchange 2003 server
'	and display queue sizes and message counts in an Internet
'	Explorer Window.  Any pending messages will be enumerated.

'	The window will refresh by default every 60
'	seconds.  You can modify this by editing the iREFRESH constant
'	and specifiying a value in milliseconds.

'	The script will prompt you for a server name and alternate credentials.
'	This tool is designed to be run from a Windows XP desktop.  It uses WMI.
'	Exchange management tools do not need to be installed.

'	This version of the tool will only monitor queues.  There are no features To
'	clear queues or messages.

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
dim objIE
dim objLocator
dim objWMIService
dim colQueues
Dim objNetwork

Const wbemFlagReturnImmediately=&h10
Const wbemFlagForwardOnly=&h20
'refresh interval in Milliseconds
Const iREFRESH=60000

strTitle="SMTP Queue Monitor"
strNamespace="root\MicrosoftExchangeV2"
strQuery="Select * from Exchange_SMTPQueue"
strUsername=""
strPassword=""

Set objNetwork=CreateObject("WScript.Network")
strSrv=InputBox("What Exchange 2003 server do you want to monitor?",strTitle,"EXCHANGE01")
If strSrv="" Then WScript.Quit

If UCase(strSrv)<>UCase(objNetwork.ComputerName) Then
	strUsername=InputBox("Enter in alternate credentials (ie domain\admin) or leave " &_
	"BLANK to use current credentials.",strTitle,objNetwork.UserDomain & "\Administrator")
		If strUsername<>"" Then
			strPassword=InputBox("Enter alternate credential password for " &_
			strUsername & ". This input box " &_
			"will display the password in clear text.",strTitle,"P@ssw0rd")
		End if
End If

Set objIE = CreateObject("InternetExplorer.Application")
objIE.navigate "about:blank"
objIE.ToolBar = False
objIE.AddressBar = False
objIE.Top = 25
objIE.Left = 25
objIE.Width = 450
objIE.Height = 450
objIE.Visible = True
objIE.menubar = False
objIE.StatusBar = False
objIE.Document.Body.Title = strTitle

blnRunning=True

'check if IE is running.  If not, then exit
Do While  blnRunning 
	t=objIE.Document.Body.Title
	If Err.Number=0 then
		RunQuery
		WScript.Sleep iREFRESH
	Else
		blnRunning=False
	End If
Loop

WScript.Quit

Sub RunQuery()
On Error Resume Next

strHTML="<Font Face=Verdana Size=2>Querying SMTP Queues on " & UCase(strSrv) & "</Font><br>"
objIE.document.body.innerHTML= strHTML

Set objLocator = CreateObject("WbemScripting.SWbemLocator")
objLocator.Security_.ImpersonationLevel=3
objLocator.Security_.AuthenticationLevel=WbemAuthenticationLevelPktPrivacy
Set objWMI=objLocator.ConnectServer(strSrv,strNamespace,strUsername,strPassword)
Set colQueues=objWMI.ExecQuery(strQuery,"WQL",wbemForwardOnly+wbemFlagReturnImmediately)

strHTML="<table border=0 align=Center><TR><TD Align=Center><Font Face=Verdana size=2>" & UCase(strSrv) &_
 " " & strTitle & "</Font></TD></TR></Table><br>"
strHTML=strHTML & "<table border=0 width=100%>"
strHTML=strHTML & "<TR>"
strHTML=strHTML & "<TD Align=Center><Font Face=Verdana Size=2>Link Name</TD>" &_
"<TD Align=Center><Font Face=Verdana Size=2>Size (bytes)</TD>" &_
"<TD Align=Center><Font Face=Verdana Size=2>Message Count</TD><TD></TD>"
strHTML=strHTML & "</TR>"
'get Size,LinkName,MessageCount
For Each queue In colQueues
objIE.Document.body.InsertAdjacentHTML "BeforeEnd","<Font Face=Verdana Size=2>&nbsp;Analyzing " &_
 Queue.LinkName & "</Font><br>"
	strHTML=strHTML & "<TR>"
	strHTML=strHTML & "<TD><Font Face=Verdana Size=2>" & queue.LinkName & "</TD>"
	strHTML=strHTML & "<TD><Font Face=Verdana Size=2>" & queue.Size & "</TD>"
	strHTML=strHTML & "<TD><Font Face=Verdana Size=2>" & queue.MessageCount & "</TD>"
	strHTML=strHTML & "</TR>"
	strEnumQuery="Select * from Exchange_QueuedSMTPMessage where LinkID='" & queue.LinkID &_
	 "' AND LinkName='"  & queue.LinkName & "' AND ProtocolName='SMTP' AND queueID='" &_
	 queue.QueueID & "' AND queueName='" & queue.QueueName & "' and VirtualServerName='" &_
	 queue.VirtualServername & "' AND VirtualMachine='" & queue.VirtualMachine & "'"
	'WScript.Echo strEnumQuery
	Set colMsgs=objWMI.ExecQuery(strEnumQuery,"WQL",wbemForwardOnly+wbemFlagReturnImmediately)
	For Each msg In colMsgs
	strHTML=strHTML & "<TR>"
	strHTML=strHTML & "<TD>&nbsp</TD>"
	strHTML=strHTML & "<TD colspan=2><Font Face=Verdana Size=1>"
	strHTML=strHTML & " From: " & msg.Sender & "<br>"
	strHTML=strHTML & " To: " & msg.recipients& "<br>"
	strHTML=strHTML & " Size (bytes):" & msg.Size& "<br>"
	strHTML=strHTML & " Received: " & ConvWMITime(msg.Received)& "<br>"
	strHTML=strHTML & " Submitted: " & ConvWMITime(msg.Submission)& "<br>"
	strHTML=strHTML & "</fond></TD><TR>"
	next
Next

strHTML=strHTML & "</Table>"
strHTML=strHTML & "<br><Font size=1><I>Reported " & Now & "</I></Font>"
objIE.document.body.innerHTML= strHTML

End sub

'////////////////////////////////////
'Convert WMI Time stamp
'///////////////////////////////////
Function ConvWMITime(wmiTime)
On Error Resume Next

yr = left(wmiTime,4)
mo = mid(wmiTime,5,2)
dy = mid(wmiTime,7,2)
tm = mid(wmiTime,9,6)

ConvWMITime = mo&"/"&dy&"/"&yr & " " & FormatDateTime(left(tm,2) & _
":" & Mid(tm,3,2) & ":" & Right(tm,2),3)
End Function

