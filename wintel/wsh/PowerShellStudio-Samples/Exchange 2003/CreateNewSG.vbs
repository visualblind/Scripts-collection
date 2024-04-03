' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: CreateNewSG.vbs
' 
' 	Comments: This script requires Exchange 2003 Management console to be installed.
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
'CreateNewSG.vbs
strTitle="Create New Storage Group"
strServer=InputBox("What is the name of the Exchange Server?",strTitle,"SERVER")
strNewSG=InputBox("What is the name of the new storage group?",strTitle,"ScriptingAnswers")

CreateNewStorageGroup strNewSG,strServer
WScript.Echo "Done!"

WScript.quit

Sub CreateNewStorageGroup(strSGName,strComputerName)
                                      
  On Error Resume Next
  Dim iServer      
  Dim iStGroup     
  Dim strTemp      

Set iServer=CreateObject("CDOEXM.ExchangeServer")
Set iStGroup=CreateObject("CDOEXM.StorageGroup")

  ' Set the name of the StorageGroup
  iStGroup.Name = strSGName

  ' Bind to the Exchange Server
  iServer.DataSource.Open strComputerName
 
   For Each sg In iServer.StorageGroups
    strTemp = sg	
    Exit For
  Next
   'cut out the Storage Group name from URL
  strTemp = Mid(strTemp, InStr(2, strTemp, "CN"))
  ' Build the URL to the StorageGroup
  strSGUrl = "LDAP://" & iServer.DirectoryServer & "/CN=" & strSGName & "," & strTemp
  WScript.Echo "Creating " & strSGUrl
  ' Save the StorageGroup
  iStGroup.DataSource.SaveTo strSGUrl

End Sub
