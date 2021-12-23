'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CopyEventLogs.vbs
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

scomputer="CHAOS"
sTargetParent="Q:\Logs"

CopyEventLog sComputer,sTargetParent

Function CopyEventLog (sComputer,sTargetParent)
' Each Eventlog file will be copied To the target folder
' with a name of COMPUTERNAME_LOGFILENAME_YYYYMMDDhhmm.[evt | evtx]
' The file extension will be the same
' File copy will fail if an existing file with the same name already exists

Dim oWMIService
sDate=Replace(Date(),"/","_")
 'connect to the WMI provider  
 Set oWMIService = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate,(Backup,Security)}!\\" & _
 sComputer & "\root\cimv2")
 

 Set cLogFiles = oWMIService.ExecQuery("Select * from Win32_NTEventLogFile") 
 For Each logfile In cLogFiles
    'strip out any spaces in the filename
    sLogname=Replace(logfile.FileName," ","")
    sTimeStamp=Year(Now) & Month(Now) & Day(Now) & Hour(Now) & Minute(Now) & Second(Now)
    
    sTarget=sTargetParent & "\" & sComputer & "_" & sLogName & "_" & sTimeStamp & "." & logfile.extension
    WScript.Echo "copying " & logfile.name & " to " & sTarget
    rc=logfile.copy(sTarget)
    If rc <>0 Then
        WScript.Echo "Failed to copy event log. Return code " & rc
    End If
 Next
 
 End Function
 
