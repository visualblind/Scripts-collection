' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: MailboxReport.vbs
' 
' 	Comments: Create a mailbox utilization report for Exchange 2003.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE And INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY And/Or FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************
'
Dim SWBemlocator
Dim objWMIService
Dim colItems
Dim objFSO
Dim objFile
strTitle="Mailbox Report"
strComputer = InputBox("What Exchange server do you want to check?",strTitle,"TANK")
UserName = ""
Password = ""
strLog="MailboxReport.csv"
Set objFSO=CreateObject("Scripting.FileSystemObject")
Set objFile=objFSO.CreateTextFile(strLog,True)

'This query will fail with the Exchange WMI Provider
'strQuery="Select ServerName,StorageGroupName,StoreName,MailboxDisplayName,Size,TotalItems from Exchange_Mailbox"
strQuery="Select * from Exchange_Mailbox"
objFile.WriteLine "Server,StorageGroup,MailStore,User,Size(KB),TotalItems"
WScript.Echo "Examining " & strComputer
Set SWBemlocator = CreateObject("WbemScripting.SWbemLocator")
Set objWMIService = SWBemlocator.ConnectServer(strComputer,"\root\MicrosoftExchangeV2",UserName,Password)
Set colItems = objWMIService.ExecQuery(strQuery,,48)

For Each objItem in colItems
	objFile.writeline objItem.ServerName & "," &objItem.StorageGroupName &_
	"," & objItem.StoreName & "," & Chr(34) & objItem.MailboxDisplayName & Chr(34) &_
	"," & objItem.Size & "," & objItem.TotalItems
	
	'uncomment if you want to write to the screen
	'WScript.echo objItem.ServerName & "," &objItem.StorageGroupName &_
	'"," & objItem.StoreName & "," & CHR(34) & objItem.MailboxDisplayName & Chr(34) &_
	'"," & objItem.Size & "," & objItem.TotalItems
Next

objFile.close

WScript.Echo "See " & strLog & " for results."