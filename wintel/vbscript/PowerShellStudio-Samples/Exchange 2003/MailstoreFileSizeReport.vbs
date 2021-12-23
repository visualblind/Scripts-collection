' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: MailStoreFileSizeReport.vbs 
' 
' 	Comments:  Returns the filepath and size for .edb and .stm files for 
'	each mailbox store on a specified Exchange 2003 server.
'	
'	This script has not been tested with Exchange 2000 but it should work.
'
'	You should use CScript to run this.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE And INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED Or IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

On Error Resume Next
Dim objRootDSE,objConfiguration
Set objRootDSE = GetObject("LDAP://rootDSE")
'connect to the configuration naming context
strConfiguration = "LDAP://" & objRootDSE.Get("configurationNamingContext")
Set objConfiguration = GetObject(strConfiguration)

strSrv=InputBox("Enter the name of your Exchange 2003 server?", _
"Get Mail Store Files","EXCHANGE01")
strSrv=UCase(strSrv)	'SERVERNAME MUST BE UPPERCASE

'you could query AD for storage group names but for simplicity we'll
'simply enter the name
strSG=InputBox("Enter the name of the storage group that holds the " &_
"mailbox store(s) you want to look at.","Get Mail Store Files", _
"First Storage Group")

'you can add alternate credentials for WMI connections if you wish
strUsername=""
strPassword=""

'return mailstore name and DN for each mailstore in the storage group separated by |
'each set of name and DN is separated by ;
strMailStores=GetMailStores(objConfiguration.ADSpath,strSrv,strSG)

'split into an array
MailStoreArray=Split(strMailStores,";")

WScript.Echo strSG & " mailbox store(s)"

'loop through array
For m=0 To UBound(MailStoreArray)-1
	'split each entry into it's name and DN components
	MailStoreNameArray=Split(MailStoreArray(m),"|")
	strMailStoreName=MailStoreNameArray(0)
	strMailStoreDN=MailStoreNameArray(1)
	
	WScript.Echo " " & strMailStoreName
	
	'return EDB and STM filepath separated by ;
	strMailFiles=GetMailStoreFiles(objConfiguration.ADSpath,strMailStoreDN)
	FileArray=Split(strMailFiles,";")
	strEDBPath=FileArray(0)
	strSTMPath=FileArray(1)
	
	'get filesize for EDB and STM file
	iEDBSize=GetFileSize(strSrv,strEDBPath,strUsername,strPassword)
	iSTMSize=GetFileSize(strSrv,strSTMPath,strUsername,strPassword)
	'replace \\ back with \ in filepaths
	strEDBPath=Replace(strEDBPath,"\\","\")
	strSTMPath=Replace(strSTMPath,"\\","\")
	
	'display file results
	wscript.Echo "  " & strEDBPath & " = " &_
	 FormatNumber((iEDBSize/1048756),2) & " MB"
	wscript.Echo "  " & strSTMPath & " = " &_
	 FormatNumber((iSTMSize/1048756),2) & " MB"
Next

Function GetMailStores(strPath,strSrv,strSG)
On Error Resume Next
strQuery="Select distinguishedname,name from '" & strPath &_
 "' WHERE objectclass='msExchPrivateMDB' "	

strResults=""
Set cat=GetObject("GC:")
For Each obj In cat
 Set GC=obj
Next

Set conn=CreateObject("ADODB.Connection")
Set cmd=CreateObject("ADODB.Command")
conn.Provider="ADSDSOObject"
conn.Open	

Set cmd.ActiveConnection=conn
Set RS=conn.Execute(strQuery)
Do While Not RS.EOF

 If InStr(rs.Fields("distinguishedname"),strSG) And _
 InStr(rs.Fields("distinguishedname"),strSrv) Then
 		strResults=strResults & rs.Fields("name") & "|" &_
 		rs.Fields("distinguishedname") & ";"
 End If
 rs.movenext
Loop
rs.Close
conn.Close	

GetMailStores=strResults

End Function


Function GetMailStoreFiles(strConfigPath,strDN)
On Error Resume Next

strQuery="Select distinguishedName,msExchEDBfile,msExchSLVFile,name FROM '" &_
 strConfigPath & "' WHERE objectclass='msExchPrivateMDB' AND distinguishedname='" &_
 strDN & "'"
 
Set cat=GetObject("GC:")
For Each obj In cat
 Set GC=obj
Next

Set conn=CreateObject("ADODB.Connection")
Set cmd=CreateObject("ADODB.Command")
conn.Provider="ADSDSOObject"
conn.Open	

Set cmd.ActiveConnection=conn
Set RS=conn.Execute(strQuery)

Do While Not RS.EOF
 strResults=RS.fields("msExchEDBfile") & ";" & RS.fields("msExchSLVFile")
 rs.movenext
Loop
rs.Close
conn.Close	

GetMailStoreFiles=strResults

End Function

Function GetFileSize(strSrv,strFile,UserName,Password)
On Error Resume Next

strFile=Replace(strFile,"\","\\") 'filepath must use \\ instead of \

Set SWBemlocator = CreateObject("WbemScripting.SWbemLocator")
SWBemlocator.Security_.AuthenticationLevel=WbemAuthenticationLevelPktPrivacy
Set objWMIService = SWBemlocator.ConnectServer(strSrv,"\root\cimV2",UserName,Password)
If Err.Number<>0 Then
 strData="Error connecting to " & strSrv & ". Error #" & Hex(err.Number) &_
 " " & Err.Description
 GetFileSize=strData
 Err.Clear
Else
 strQuery="Select name,filesize from CIM_DATAFILE where name='" & strFile & "'"
 Set colItems = objWMIService.ExecQuery(strQuery,,48)
 For Each file In colItems
  strResults=file.filesize
 Next
 GetFileSize=strResults

End If

End Function
