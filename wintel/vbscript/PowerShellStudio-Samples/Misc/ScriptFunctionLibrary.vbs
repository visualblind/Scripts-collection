' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: ScriptFunctionLibrary.vbs  
' 
' 	Comments: These functions are used in a variety of scripts And
' are meant to be called from a WSF file or copied and pasted
' into other scripts.
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

'//////////////////////////////////////////////////////
'Find out if a specified service exists. Returns TRUE If
'found.
'//////////////////////////////////////////////////////
Function ServiceExists(strServiceName,strComputer,strUsername,strPassword)
On Error Resume Next
Dim objLocator,objService,objRet
Const wbemFlagReturnImmediately=&h10
Const wbemFlagForwardOnly=&h20

'set default value of function to false
ServiceExists=False

strQuery="Select name from win32_service where name='" & strServiceName & "'"

Set objLocator=CreateObject("WbemScripting.SWbemLocator")
objLocator.Security_.ImpersonationLevel=3
objLocator.Security_.AuthenticationLevel=wbemAuthenticationLevelPktPrivacy
Set objService=objLocator.ConnectServer(strComputer,"root\cimv2",strUsername,strPassword)
If Err.Number<>0 Then 
	ServiceExists=False
	Exit Function
End If
Set objRet=objService.ExecQuery(strQuery,"WQL",wbemFlagForwardOnly+wbemFlagReturnImmediately)
For Each svc In objRet
	If UCase(svc.Name)=UCase(strServiceName) Then ServiceExists=TRUE
Next

End Function

'//////////////////////////////////////////////////////
'Find out if a specified service is running. 
'Returns TRUE If it is
'//////////////////////////////////////////////////////
Function ServiceRunning(strServiceName,strComputer,strUsername,strPassword)
On Error Resume Next
Dim objLocator,objService,objRet
Const wbemFlagReturnImmediately=&h10
Const wbemFlagForwardOnly=&h20

'set default value of function to false
ServiceRunning=False

strQuery="Select name,state from win32_service where name='" & strServiceName & "'"

Set objLocator=CreateObject("WbemScripting.SWbemLocator")
objLocator.Security_.ImpersonationLevel=3
objLocator.Security_.AuthenticationLevel=wbemAuthenticationLevelPktPrivacy
Set objService=objLocator.ConnectServer(strComputer,"root\cimv2",strUsername,strPassword)
If Err.Number<>0 Then 
	ServiceRunning=False
	Exit Function
End If
Set objRet=objService.ExecQuery(strQuery,"WQL",wbemFlagForwardOnly+wbemFlagReturnImmediately)
For Each svc In objRet
	If svc.state="Running" Then ServiceRunning=TRUE
Next

End Function

'//////////////////////////////////////////////////////
'Get current path script is running in
'//////////////////////////////////////////////////////
Function GetCurDir()
On Error Resume Next
	GetCurDir=Left(WScript.ScriptFullName,Len(WScript.ScriptFullName)_
	-Len(WScript.ScriptName))
End Function

'//////////////////////////////////////////////////////
'Generate a random number between two values
'//////////////////////////////////////////////////////
Function GetRand(iLower,iUpper)
Randomize
GetRand=Int((iUpper - iLower + 1) * Rnd + iLower)
End Function

'//////////////////////////////////////////////////////
'Functions to return padded timestamp that can be used 
'in log file names. Output will be like 20040826140008
'//////////////////////////////////////////////////////
Function GetLogTime()
    Dim strNow
    strNow = Now()
    GetLogTime = Year(strNow) _
        & Pad(Month(strNow), 2, "0", True) _
        & Pad(Day(strNow), 2, "0", True) _
        & Pad(Hour(strNow), 2, "0", True) _
        & Pad(Minute(strNow), 2, "0", True) _
        & Pad(Second(strNow), 2, "0", True)
End Function

Function Pad(strText, nLen, strChar, bFront)
Dim nStartLen
    If strChar = "" Then
        strChar = "0"
    End If
    nStartLen = Len(strText)
    If Len(strText) >= nLen Then
        Pad = strText
    Else
        If bFront Then
            Pad = String(nLen - Len(strText), strChar) _
                & strText
        Else
            Pad = strText & String(nLen - Len(strText), _
                strChar)
        End If
    End If
End Function

'///////////////////////////////////////////
'Object Exists Function
'//////////////////////////////////////////

Function ObjectExists(strADSPath)
On Error Resume Next
Dim objZTmp

ObjectExists=FALSE
set objZTmp=GetObject(strADSPath)
If Err.Number=0 Then ObjectExists=True

Set objZTmp=Nothing
End Function

'///////////////////////////////////////////
'User Object Exists Function
'//////////////////////////////////////////

Function UserExists(strDomain,strSAM)
On Error Resume Next
Dim objZTmp

ObjectExists=False
set objZTmp=GetObject("WinNT://"&strDomain&"/"&strSAM& ",user")
If Err.Number=0 Then ObjectExists=True
Err.Clear
Set objZTmp=Nothing
End Function


'\\\\\\\\\\\\\\\\\\\\\\
'ChkEngine Function
' return whether Cscript or wscript were used to execute a script
'\\\\\\\\\\\\\\\\\\\\\\
Function ChkEngine()
'returns either cscript.exe or wscript.exe
ON ERROR RESUME NEXT

strEngine=Wscript.FullName

if Err.Number <>0 then
 wscript.echo "Error!"
  wscript.echo "Error (" & Err.Number & ") Description: " &_
   Err.Description
  wscript.quit
end if

PosX=InStrRev(strEngine,"\",-1,vbTextCompare)
ChkEngine=LCase(Mid(strEngine,PosX+1))

End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
' Get user's distinguishedname
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Function GetDN(samAccount)
'Given NT4 account name, find the distinguished name for the user account
On Error Resume Next
Dim conn,cmd,RS
Set conn=CreateObject("ADODB.Connection")
Set cmd=CreateObject("ADODB.Command")

GetDN="NotFound"

Set RootDSE=GetObject("LDAP://RootDSE")
Set myDomain=GetObject("LDAP://"&RootDSE.get("DefaultNamingContext"))

strQuery="Select sAMAccountname,distinguishedname from '" & _
myDomain.AdsPath & "' Where objectcategory='person' AND objectclass='user'" & _
" AND sAMAccountName='" & samAccount & "'"

set cat=GetObject("GC:")
for each obj In cat
 set GC=obj
Next

conn.Provider="ADSDSOObject"
conn.Open "Active Directory Provider"
cmd.ActiveConnection=conn
cmd.Properties("Page Size") = 100
cmd.Properties("asynchronous")=True
cmd.Properties("Timeout") =30
cmd.Properties("Cache Results") = false
cmd.CommandText=strQuery

set RS=cmd.Execute 

do While not RS.EOF
 GetDN=rs.Fields("distinguishedname")
 rs.movenext
Loop
rs.Close
conn.Close	

End Function

'///////////////////////////////////////////
'Convert UTC time to standard time
'//////////////////////////////////////////

Function UndoZulu(strDate,offset)
On Error Resume Next
yr=Left(strDate,2)
mo=Mid(strDate,3,2)
dy=Mid(strDate,5,2)
hr=Mid(strDate,7,2)
mn=Mid(strDate,9,2)
sc=Mid(strDate,11,2)

dCreated=CDate(mo&"/"&dy&"/"&yr & " " & hr & ":" &mn & ":" & sc)
'wscript.Echo strDate & " is " & dCreated & " UTC"
UndoZulu=DateAdd("h",iOffset, dCreated)

End Function

'///////////////////////////////////////////
'Convert standard time stamp to UTC format
'//////////////////////////////////////////

Function ConvertToUTC(strDate,iOffset)
On Error Resume Next
strUTC=Right(Year(strDate),2)&Pad(Month(strDate),2,"0",True) &_
 Pad(Day(strDate),2,"0",True) & Pad(Hour(strDate),2,"0",True) &_
 Pad(Minute(strDate),2,"0",True) & Pad(Second(strDate),2,"0",True)
'ConvertToUTC=DateAdd("h",strUTC,iOffSet)
ConvertToUTC=strUTC

End Function

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

'///////////////////////////////////////////
'Ping target system using WMI. Requires XP
' or Windows 2003 locally
'//////////////////////////////////////////
Function TestPing(strName)
On Error Resume Next
'this function requires Windows XP or 2003
Dim cPingResults, oPingResult
strPingQuery="SELECT * FROM Win32_PingStatus WHERE Address = '" & strName & "'"

Set cPingResults = GetObject("winmgmts://./root/cimv2").ExecQuery(strPingQuery)
For Each oPingResult In cPingResults
	If oPingResult.StatusCode = 0 Then
		TestPing = True
	Else
		TestPing = False
	End If
Next
End Function

'///////////////////////////////////////////
'returns values like:
'Microsoft Windows XP Professional
'///////////////////////////////////////////
Function GetOS()
On Error Resume Next
Dim objWMI

Set objWMI=GetObject("winmgmts://").InstancesOf("win32_operatingsystem")

For Each OS In objWMI
  GetOS=OS.Caption
Next

End Function

'///////////////////////////////////
'Use IE Password prompt
'to securely get a password
'//////////////////////////////////
Function GetIEPassword()
Dim ie
On Error Resume Next
set ie=Wscript.CreateObject("internetexplorer.application")
ie.width=400
ie.height=150
ie.statusbar=True
ie.menubar=False
ie.toolbar=False

ie.navigate ("About:blank")
ie.visible=True
ie.document.title="Password prompt"

strHTML=strHTML & "<Font color=RED><B>Enter password: <br><input id=pass type=Password></B></Font> &nbsp"
strHTML=strHTML & "<input type=checkbox id=Clicked size=1>click box when finished"

ie.document.body.innerhtml=strHTML

Do While ie.busy<>False
	wscript.sleep 100
Loop

'loop until box is checked
 Do While ie.Document.all.clicked.checked=False
	WScript.Sleep 250
Loop

GetIEPassword=ie.Document.body.all.pass.value

ie.Quit
set ie=Nothing
End Function

'///////////////////////////////////
' Sub Verbose
' Outputs status messages if /verbose argument supplied
' This is used as a named parameter in WSF files
'///////////////////////////////////
Sub Verbose(sMessage)
	If WScript.Arguments.Named.Exists("verbose") Then
		WScript.Echo sMessage
	End If
End Sub

'///////////////////////////////////
' Sub Send mail
' send mail using local SMTP
'///////////////////////////////////
Sub SendMailLocal(strTo,strCC,strFrom,strBody,strSubject,strFile)
On Error Resume Next
'You must have SMTP installed on the workstation executing this script in 
'order for mail to work.

Dim objMsg
set objMsg=CreateObject("CDO.Message")

objMsg.To=strTo
objMsg.CC= strCC
objMsg.Subject =strSubject
objMsg.From= strFrom
objMsg.BodyPart=strBody
objMsg.AddAttachment strFile


objMsg.Send
'uncomment the following section if running interactively
' if err.number<>0 Then
'  wscript.echo "Failed to send report by email to " & objMsg.To
' else
'  wscript.echo "Successfully mailed report to "  & objMsg.To
' end If


End Sub
'///////////////////////////////////
' Send mail using CDO
'///////////////////////////////////
Sub SendMail(strSMTPServer,strTo,strFrom,strSubject,strBody,strFiles)
Dim objMail,objConfig,objFields
On Error Resume Next
'strFiles is a comma separated list of filenames including path to attach such as
'"c:\files\report.htm"
'strTo="me@company.com,"
'strFrom="tinkerbell@neverland.net"
'strSubject="Testing"
'strBody="This is something for you to read."
'strSMTPServer="mail.company.com"

Trace "Sending mail to: " & strTo
Trace "Mail from: " & strFrom
Trace "Subject: " & strSubject
Trace "Body: " & strBody
Trace "SMTPServer: " & strSMTPServer

Set objMail = CreateObject("CDO.Message")
Set objConfig = CreateObject("CDO.configuration")
Set objFields = objConfig.Fields
With objFields
.Item("http://schemas.microsoft.com/cdo/configuration/SendUsing")= 2
'set the next line to the SMTP server on the network
.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")= strSMTPServer
.Item("http://schemas.microsoft.com/cdo/configuration/SMTPServerPort")= 25
.Update
End With

With objMail
Set .Configuration = objConfig
.To=strTo
.From=strFrom
.Subject=strSubject
.TextBody=strBody
arrFiles=Split(strFiles,",")
For f=0 To UBound(arrFiles)
'if multiple files selected then attach each one
	strFile=arrFiles(f)
	.AddAttachment("File://" & strFile)
next
.Send

End With


End Sub

'///////////////////////////////////
' Ping the OS using WMI
' This will query WMI and attempt to return the
' operating system name. If successful
' this indicates the server OS is running
' which may not be true of a simple
' ICMP ping
'///////////////////////////////////
Function WMIPing(strSrv)
'function returns TRUE if successful contact was made.
On Error Resume Next
Dim oWMI,oRef

Const ReturnImmediately=&h10
Const ForwardOnly=&h20

strQuery="Select CSName,Status FROM Win32_OperatingSystem"

Set oWMI=GetObject("Winmgmts://"&strSrv &"\root\cimv2")
If Err.Number Then
WMIPing=False
Exit Function
'uncomment next lines For debugging
'  strErrMsg= "Error connecting to WINMGMTS on " & strSrv & vbCrlf
'  strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
'        If Err.Description <> "" Then
'            strErrMsg = strErrMsg & "Error description: " & Err.Description & "."
'        End If
'  Err.Clear
'  wscript.echo strErrMsg
'  wscript.quit
End If

Set oRef=oWMI.ExecQuery(strQuery,"WQL",ForwardOnly+ReturnImmediately)
If Err.Number Then
WMIPing=False
Exit Function
'uncomment next lines for debugging
'strErrMsg= "Error executing query " & vbCrlf & strQuery & " on " & strSrv & vbCrlf
'  strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
'        If Err.Description <> "" Then
'            strErrMsg = strErrMsg & "Error description: " & Err.Description & "."
'        End If
'  Err.Clear
'  wscript.echo strErrMsg
'
'    wscript.quit
End If

for each item in oRef
	If item.Status="OK" Then
		WMIPing=True
	Else
		WMIPing=False
	End If
Next

End Function

Sub TraceCMD(strMsg)
'send a trace message using wscript.echo.
'Run script with CSCRIPT to generate a scrolling console

On Error Resume Next

	If blnTraceCMD=True Then WScript.Echo Now & " " & strMsg

End Sub

'EOF