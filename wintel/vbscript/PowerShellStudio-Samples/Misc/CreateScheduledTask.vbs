' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: CreateScheduledTask.vbs 
' 
' 	Comments: This script must be run on an XP or Windows 2003 platform. 
' It can be used to create a scheduled job on any remote Windows 2000
' or later system.  This has not been tested on any versions of 
' Windows Vista.
' The script will prompt you for all the necessary parameters.
' This scirpt does not use all the SCHTASKS options. You may still need
' to tweak the job or modify this script to add the functionality you 
' need.
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

Dim objShell
Dim objNetwork

Set objShell=CreateObject("wscript.shell")
Set objNetwork=CreateObject("WScript.Network")

strTitle="Create Scheduled Task"
If InStr(GetOS,"2000") Then
	  strMsg="You do not appear to be running Windows XP or later." & VbCrLf &_
	  "You will have to manually create a scheduled task running under" & VbCrLf &_
	  "domain admin credentials." & VbCrLf & VbCrLf &_
	  "Create task: " & VbCrLf & strScript
	  MsgBox strMsg,vbOKOnly+vbExclamation,strTitle
Else
	'Create Schedule Task
	'schtasks only exists on XP and later operating systems.
	
	strMsg="Enter the computer where you will create the scheduled task:"
	strDefault=objNetwork.ComputerName
	strComputer=GetData(strMsg,strTitle,strDefault)
		
	strMsg="What user credentials will you use?"
  	strDefault=objNetwork.UserDomain & "\" & objNetwork.UserName
	strAdmin=GetData(strMsg,strTitle,strDefault)
	
	strMsg="What is the password for " & strAdmin & "?" &_
	"  Warning: This password will be displayed in this inputbox as clear text."
  	strDefault="Password"
	strAdminPassword=GetData(strMsg,strTitle,strDefault)
	
	strMsg="How often do you want to run this task?" & VbCrLf &_
	"Possible values are DAILY,WEEKLY,MONTHLY or ONCE."
  	strDefault="DAILY"
	strSchedule=GetData(strMsg,strTitle,strDefault)
	'add qualifiers if necessary
	strQualifier=""
	Select Case UCase(strSchedule)
	    Case "DAILY" strQualifier=""
	    Case "WEEKLY"
	        strMsg="What day(s) of the week do you want to run this task?" &_
	        VbCrLf & "Valid choices are MON,TUE,WED,THU,FRI,SAT,SUN " &_
	        "separated by commas."	        
	        strDefault="MON"
	        strDays=GetData(strMsg,strTitle,strDefault)
	        strQualifier=strQualifier & " /D " & strDays
	    Case "MONTHLY"
	    	strMsg="What month(s) you want to run this task?" &_
	        VbCrLf & "Valid choices are JAN,FEB,MAR,APR,MAY,JUN, " &_
	        "JUL,AUG,SEP,OCT,NOV,DEC separated by commas."	        
	        strDefault="JAN"
	        strMonths=GetData(strMsg,strTitle,strDefault)
	        strQualifier=strQualifier & " /M " & strMonths
	        strMsg="What day of the month do you want to run the job? You can only enter one day."
	        strDefault=1
	        strDay=GetData(strMsg,strTitle,strDefault)
	        strQualifier=strQualifier & " /D " & strDay
	    Case "ONCE" strQualifier=""
	    Case Else 
	        WScript.Echo "You entered an invalid schedule choice: " &_
	        strSchedule & ". Please try again."
	        WScript.quit
	End Select
		
	strMsg="Enter the job name:"
  	strDefault="MyScheduledJob"
	strTaskName=GetData(strMsg,strTitle,strDefault)
	
	strMsg="Enter the task to run and any parameters in quotes:"
  	strDefault="Notepad.exe"
	strTaskToRun=GetData(strMsg,strTitle,strDefault)
	
	strMsg="What time do you want to run this task? Please use HH:MM:SS format and 24 hour time."
  	strDefault="12:00:00"
	strStartTime=GetData(strMsg,strTitle,strDefault)
	
	strCmd="SCHTasks /Create /S " & strComputer & " /RU " & strAdmin &_
	 " /RP " & strAdminPassword & " /SC " & strSchedule &_
	  " /TN " & CHR(34) & strTaskName & Chr(34) & " /TR " & strTaskToRun &_
	   " /ST " & strStartTime & strQualifier
	
	strMsg=""
	set objExec=objShell.Exec(strCmd)
	 do while objExec.StdOut.AtEndOfStream <>True
	  	r=objExec.StdOut.Readline
	  	 strMsg=strMsg & r & VbCrLf
	      WScript.Sleep 100
	 Loop
	
	If strMsg="" Then 
	    strMsg="Scheduled task creation failed." & VbCrLf &_
	    strCmd
	    WScript.Echo strCmd
	    MsgBox strMsg,vbOKOnly+vbExclamation,strTitle

	    WScript.quit
	End if
	MsgBox strMsg,vbOKOnly+vbInformation,strTitle
	
	strMsg="Do you want to run job " & strTaskName & " now? " 
	
	rc=MsgBox(strMsg,vbYesNo+vbInformation+vbDefaultButton2,strTitle)
	If rc=vbYes Then 
		strMsg="Running " & strTaskName
		objShell.Exec "SCHTasks /Run /TN " & strTaskName
	Else
		strMsg=strTaskName & " will run at its schedule time."
	End If
	objShell.Popup strMsg,10,strTitle,vbOKOnly+vbInformation

End If

'///////////////////////////////////////////
'returns values like:
'Microsoft Windows XP Professional
'///////////////////////////////////////////
Function GetOS()
On Error Resume Next
Dim objWMI

Set objWMI=GetObject("winmgmts://.\root\cimv2").InstancesOf("win32_operatingsystem")

For Each OS In objWMI
  GetOS=OS.Caption
Next

End Function

Function GetData(strMsg,strTitle,strDefault)
On Error Resume Next

strData=InputBox(strMsg,strTitle,strDefault)
'abort if nothing entered
If Len(strData)=0 Then WScript.Quit

If strData="" Then 
	WScript.quit
Else
'trim off any spaces
	GetData=Trim(strData)
End If
End Function