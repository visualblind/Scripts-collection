' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: SGReport.vbs
' 
' 	Comments: Requires Exchange 2003 Management console to be installed.
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
strTitle="Storage Group Report"
strServer=InputBox("What is the name of the Exchange Server?",strTitle,"TANK")

SGReport strServer
WScript.Quit

Sub SGReport(strServer)
Dim iServer
Dim iSGs
Dim iMBS

Set iServer=CreateObject("CDOEXM.ExchangeServer")
Set iSGs=CreateObject("CDOEXM.StorageGroup")
Set iMBs=CreateObject("CDOEXM.MailboxStoreDB")
iServer.DataSource.Open strServer

arrSGs=iServer.StorageGroups

For i=0 To UBound(arrSGs)
	strSGUrl=arrSGs(i)
	'WScript.Echo strSGUrl
	iSGs.DataSource.Open "LDAP://" & iServer.DirectoryServer & "/" & strSGUrl
	strData=strData & iSGs.Name & VbCrLf
	strData=strData & vbTab & "LogPath: " &iSGs.LogFilePath & VbCrLf
	strData=strData & vbTab & "SystemPath:" & iSGs.SystemFilePath & VbCrLf
	strData=strData & "  MailBox Stores:" & VbCrLf
	arrMBStores=iSGs.MailboxStoreDBs
	For j=0 To UBound(arrMBStores)
		iMBS.DataSource.open "LDAP://" & arrMBStores(j)	
		strData=strData & vbTab & iMBS.Name & VbCrLf
	Next
Next

WScript.Echo strData


End sub