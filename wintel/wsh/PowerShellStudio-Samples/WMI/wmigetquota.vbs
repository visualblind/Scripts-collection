' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: WMIGETQUOTA.VBS 
' 
' 	Comments:
'	USAGE: cscript wmigetquota.vbs [servername]
'	DESC: Get Disk Quota information from the specified server.
'	If you don't specify a server, the script defaults to the local server. 
' 	If you specify a remote server, you must run this script under 
'	credentials that have admin rights On the target server.
'	Otherwise, you need to modify the script to use the SWBEMLocator object
'	so you can specify alternate credentials.
'
'	NOTES: THIS SCRIPT USES THE WMI DISK QUOTA PROVIDER WHICH IS ONLY AVAILABLE
'	ON WINDOWS XP AND WINDOWS SERVER 2003. 
'
'	Output is in CSV format:
'	ServerName,Volume Name,Domain\User,Status,Disk Space Used,Quota Limit,Quota Warning
'
'	If you want to save the output, use command line redirection:
'
'	cscript wmigetquota.vbs File01 >> File01Quota.csv
'
'	It is important you use >> so that each entry is appended to the file.
'
'	Strongly recommend you use CSCRIPT to run this.
'
'	Enhancement suggestions if you feel inclined:
'		Add date/time stamp to output
'		Save results to file using FileSystemObject
'		Output to html
'		Output to Excel
'		Calculate user's percentage available of their quota
'		Filter output to only show users at a certain level
'		Add code to email Administrators and/or users when quota usage reaches
'		a certain level.
'		Modify to allow alternate credentials
'
'   Disclaimer: This source code is intended only as a supplement To 
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
Dim objSvc, objRet
'If Limit or Warning limit is set to the following constant
'that indicates No Limit has been set
Const iLimit="18446744073709551615"

If wscript.Arguments.Count=0 Then
 dim wshnet
 set wshnet=CreateObject("Wscript.Network")
 strSrv=wshnet.ComputerName
 set wshnet=Nothing
Else
 strSrv=UCASE(wscript.Arguments(0))
End If

s=VBCRLF

set objSvc=GetObject("WinMgmts://" & strSrv)
if err.number <>0 then
  s=s & "OOPS!! There was an error connecting to " & strSrv & VBCRLF & _
	"Error# " & err.number & VBCRLF & _
	"Error Desc. (if available): " & VBCRLF & _
	vbtab & err.description & VBCRLF & _
	"Error Src (if available): " & VBCRLF & _
	vbtab & err.source
  wscript.echo s
  wscript.quit
end if	

Set objRet=objSvc.InstancesOf("win32_DiskQuota")

if err.number <>0 then
  s=s & "OOPS!! There was an error getting Disk Quota information from " & strSrv & VBCRLF & _
	"Error# " & err.number & VBCRLF & _
	"Error Desc. (if available): " & VBCRLF & _
	vbtab & err.description & VBCRLF & _
	"Error Src (if available): " & VBCRLF & _
	vbtab & err.source
  wscript.echo s
  wscript.quit
end if	

wscript.echo "Server,Volume,User,Status,DiskUsed,Limit,Warning"
For Each x In objRet

	If x.Limit=iLimit Then
	  strLimit="No Limit"
	Else
	  strLimit=ConvBtoMB(x.Limit)
	End If
	
	If x.WarningLimit=iLimit  Then
	  strWarnLimit="No Limit"
	Else
	  strWarnLimit=ConvBtoMB(x.WarningLimit)
	End If
	
wscript.echo strSrv & "," & RIGHT(x.QuotaVolume,4) & "," & _
 ConvName(x.User) & "," & x.Status & "," & ConvBtoMB(x.DiskSpaceUsed) & _
  "," & strLimit & "," & strWarnLimit
Next

set objSvc=Nothing
set objRet=Nothing

wscript.quit

'////////////////////////////////////////////////////////////////////////

'Functions
Function ConvBtoMB(iBytes)
'Convert number of bytes to megabytes
On Error Resume Next
'Add "" to result so that long numbers can contain commas and
'not cause misformatting when opening a csv file in Excel
ConvBtoMB=CHR(34) & FormatNumber(iBytes/1048576,2)& "MB" & CHR(34)
End Function

Function ConvName(strWMIUser)
'Convert WMI name string to domain\user
On Error Resume Next
a=InStr(strWMIUser,",")
b=Left(strWMIUser,a)
'win32_Account.Domain= is 22 characters long
'Get domain component
strDom=MID(strWMIUser,22,a-22)
'parse out ""
strDom=MID(strDom,2,LEN(strDom)-2)
c=InStr(22,strWMIUser,"=")
strUsr=MID(strWMIUser,c+2)
strUsr=LEFT(strUsr,LEN(strUsr)-1)
ConvName=strDom & "\" & strUsr
End Function

'EOF