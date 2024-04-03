' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: DeleteComputers.vbs 
' 
' 	Comments:
'	This script will read in a list of computer names, find the
' computer in Active Directory, and then delete the computer account.  An
' audit log of activity is also generated.  By default the line of code
' that does the actual deletion is commented out so that you can test.  
' You can activate the line when you are ready.  WARNING: THIS SCRIPT
' WILL DELETE OBJECTS IN ACTIVE DIRECTORY.

' NOTES: You will be prompted for names and location of text file of 
' server names and audit log. The computer list should be Netbios 
' computer names.  The default filename for the log file uses a 
' time stamp in the file name to help with uniqueness.

' This script also permits you to create a pre-deletion report showing
' the FQDN of each computer that will be deleted. 

' You need access to a Global Catalog server when running this script.
' It can be run from any Windows 2000 SP3 or later workstation in the 
' domain with appropriate domain level credentials or delegated
' permissions.
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

On Error Resume next

Dim wshnetwork
Dim fso,fsource,faudit

Const ForReading=1
Const ForWriting=2
Const ForAppending=8

Set wshnetwork=CreateObject("wscript.network")
Set fso=CreateObject("Scripting.FileSystemObject")

'this is used to generate a time stamp for the name of the log file
tmpTime=Day(now) & Month(Now) & Year(Now) & Hour(Now) & Minute(Now)

'define source file name and path
strSource=InputBox("Enter in the filename and path for the source list of computers to be delete.","Delete Computer Accounts",".\obsolete.txt")
		If strSource="" Then
			WScript.Echo "Nothing entered or you cancelled"
			WScript.Quit
		Else
			If fso.FileExists(strSource) Then
				Set fsource=fso.OpenTextFile(strSource,ForReading)
			Else
  				WScript.Echo "Failed to open " & strSource
  				WScript.Quit
			End If
		End If

rc=InputBox("Do you want to TEST or DELETE computer accounts?" & vbcrlf & "1 = TEST" & vbcrlf &_
"2 = DELETE","Delete Computer Accounts",1)
Select Case rc
	Case 1 strFlag="TEST"
	strLog=InputBox("Enter in the filename and path for the test results.  Any previous versions of the file will be overwritten.","Delete Computer Accounts",".\TEST_DeleteComputers_" & tmpTime & ".log")
		If strLog="" Then
			WScript.Echo "Nothing entered or you cancelled"
			WScript.Quit
		Else
			Set faudit=fso.CreateTextFile(strLog)
			If Err.Number<>0 Then
				WScript.Echo "Couldn't create " & strLog & "!  Please verify location and permissions."
				WScript.Quit
			End if
		End If

	Case 2 strFlag="DELETE"
	'give the user a second chance
			rc=MsgBox("Are you SURE you want to delete computer accounts in Active Directory?",vbyesno,"Delete Computer Accounts")
			If rc=VBYes then
			strLog=InputBox("Enter in the filename and path for the deletion audit.  Any previous versions of the file will be overwritten.","Delete Computer Accounts",".\DeleteComputers_" & tmpTime & ".log")
				If strLog="" Then
					WScript.Echo "Nothing entered or you cancelled"
					wscript.Quit
				Else
					Set faudit=fso.CreateTextFile(strLog)
					If Err.Number<>0 Then
						WScript.Echo "Couldn't create " & strLog & "!  Please verify location and permissions."
						WScript.Quit
					End If
				end If
			Else
				WScript.Quit
			End if
	Case Else 
			WScript.Echo "Invalid response.  Please run the script again."
			WScript.Quit	
End Select

Dim objPC

Do While fsource.AtEndOfStream<>True
	r=fsource.ReadLine
	strDN=GetDN(r)
	If strFlag="TEST" Then
		faudit.WriteLine Now & vbtab & strDN
	Else
		If InStr(strDN,"NotFound")=False then
			Set objPC=GetObject("LDAP://" & strDN)
			'uncomment the lines in the following IF-Then-Else
			'to do the actual deletion and audit it accordingly
			'objPC.DeleteObject(0)
 			'	If Err.number=0 then
 					faudit.WriteLine Now & vbtab & wshnetwork.UserName & " DELETED " & strDN
 			'	Else
 			'		faudit.WriteLine Now & vbtab & wshnetwork.UserName & " FAILED DELETION " & strDN
 			'		faudit.WriteLine Now & vbtab & "Error " & Err.Number & " " & Err.Description
 			'	End if
			Set objPC=Nothing
		Else
			faudit.WriteLine Now & vbtab & strDN
		End If
	End if
Loop

fsource.Close

WScript.Echo "Finished. See " & strLog & " for details."

faudit.Close

Set fso=Nothing
Set fsource=Nothing
Set faudit=Nothing
Set objPC=Nothing
Set wshnetwork=Nothing

WScript.Quit

'******************************************************************************************************************
Function GetDN(strPC)

On Error Resume Next
Dim RootDSE,myDomain,cat
Dim conn,cmd,RS

GetDN=UCase(strPC) & " NotFound"

set RootDSE=GetObject("LDAP://RootDSE")
set myDomain=GetObject("LDAP://"&RootDSE.get("DefaultNamingContext"))

strQuery="Select CN,distinguishedname from '" & _
myDomain.ADSPath & "' Where objectclass='computer'" & _
" AND CN='" & strPC & "'"

set cat=GetObject("GC:")
for each obj in cat
 set GC=obj
next

AdsPath=GC.ADSPath

set conn=Createobject("ADODB.Connection")
set cmd=CreateObject("ADODB.Command")
conn.Provider="ADSDSOObject"
conn.Open	

set cmd.ActiveConnection=conn
set RS=conn.Execute(strQuery)
do while not RS.EOF
 GetDN=rs.Fields("distinguishedname")
 rs.movenext
loop
rs.Close
conn.Close	

End Function

'EOF