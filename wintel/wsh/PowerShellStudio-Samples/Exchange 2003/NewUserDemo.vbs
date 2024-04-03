' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: NewUserDemo.vbs
' 
' 	Comments: Create New User account and mailbox
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

Dim RootDSE,mydomain
strTitle="New User Demo"

set RootDSE=GetObject("LDAP://RootDSE")
set mydomain=GetObject("LDAP://"&RootDSE.get("DefaultNamingContext"))
myDomainADSPath=mydomain.ADSPath		'LDAP://DC=Mydomain,DC=local
myDomainPath=MID(mydomain.ADSPath,8)	'DC=MyDomain,DC=local

strUserName=InputBox("What is the name of the new user",strTitle,"John Doe")
strSAM=InputBox("What will the be the user's SAMAccount name?",strTitle,"jdoe")

Set objContainer=GetObject("LDAP://CN=Users," & myDomainPath)
Set objUser=objContainer.Create("user","CN="&strUserName)
objUser.SamAccountName=strSAM
objUser.SetInfo
objUser.AccountDisabled = False
objUser.SetPassword "P@ssw0rd"
objUser.SetInfo

strMailDN=SelectMailStore

MakeMail objUser,strMailDN

'///////////////////////////////////////////
'Create Mailbox function
'///////////////////////////////////////////
Sub MakeMail(objUser,strMailDN)
On Error Resume next
Err.Clear	'clear any errors that might have occurred previously
'you must have Exchange Administrator Tools installed or run this on the exchange server
 
 'strMailDN="CN=Executive Mail,CN=First Storage Group,CN=InformationStore,CN=ITSERVER1," &_
 '"CN=Servers,CN=First Administrative Group,CN=Administrative Groups,CN=HQ," &_
 '"CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=COMPANY,DC=LOCAL"
'WScript.Echo "Creating mailbox on " & strMailDN & " for " & objUser.SAMAccountName
'If strFlag="CREATE" then
objUser.CreateMailbox strMailDN
	If Err.Number <>0 Then
		f.WriteLine Now & " Error creating mailbox for " & objUser.ADSPath & " on " & strMailDN 
		f.WriteLine Now & " " & Err.Number & " " & Err.Description
	Else
		objUser.SetInfo
		WScript.Echo "Created mailbox for " & objUser.Name
	End If

End Sub

'//////////////////////////////////////////////////
Function SelectMailStore()
On Error Resume Next
Dim objRootDSE
Dim objConfiguration
Dim cat
Dim conn
Dim cmd
Dim RS
Dim objDict

Set objDict=CreateObject("scripting.dictionary")
Set objRootDSE = GetObject("LDAP://rootDSE")
x=1
strConfiguration = "LDAP://" & objRootDSE.Get("configurationNamingContext")
Set objConfiguration = GetObject(strConfiguration)

strQuery="Select name,cn,distinguishedname from '" & _
objConfiguration.ADSPath & "' Where objectclass='msExchPrivateMDB'"	

set cat=GetObject("GC:")
for each obj in cat
 set GC=obj
Next

AdsPath=GC.ADSPath

set conn=CreateObject("ADODB.Connection")
set cmd=CreateObject("ADODB.Command")
conn.Provider="ADSDSOObject"
conn.Open	

set cmd.ActiveConnection=conn
set RS=conn.Execute(strQuery)

do while not RS.EOF
	 DN=rs.Fields("distinguishedname")
	 CN=RS.Fields("cn")
	 NM=RS.Fields("name")
	objDict.Add x,DN
	strResults=strResults &"(" & x & ") " &DN & vbcrlf
	x=x+1
	 rs.movenext
Loop
rs.Close
conn.Close	
t=1

a=objDict.Items
	For i=0 To objDict.Count-1
	c=c & "(" & i+1 & ")" & a(i) & VbCrLf & vbcrlf
	'display available mailbox stores in groups of 4
		 If t<>4 And i<>objDict.count-1 Then
		  t=t+1
		Else
		 MsgBox c,vbOKOnly,"Available Mailbox Stores"
		 t=1
		 c=""
		End If
	 Next

iDN=Inputbox("Enter in the number of the mail store you want to use.","Select Mail Store","0")
	If iDN = "" Then 
		WScript.Echo "Nothing entered or you cancelled."
		WScript.Quit
	End If
	
If objDict.Exists(Int(iDN)) Then
	SelectMailStore=objDict.Item(Int(iDN))
Else
	rc=msgBox ("You selected an invalid number.  Try again.",vbOKCancel+vbExclamation,"Select Mail Store")
	if rc=vbCancel Then
		wscript.Quit
	Else
		Main()
	End If
End If

End Function