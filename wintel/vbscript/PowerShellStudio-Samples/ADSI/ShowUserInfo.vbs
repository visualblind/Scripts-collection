'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ShowUserInfo.vbs
'
'	Comments: Enumerate user and basic WinNT properties for each.
'	Output will be saved to a csv file.  You can specify
'	the location and name below.  The default location is the same
'	directory as the script.  Any existing versions of the file will
'	be overwritten.
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

On Error Resume Next
dim objUser
Dim objNetwork
Dim objFSO,objFile

Const ForReading=1
Const ForWriting=2
Const ForAppending=8

strLog="UserAudit.csv"

Set objFSO=CreateObject("Scripting.FileSystemObject")
Set objFile=objFSO.CreateTextFile(strLog,True)

Set objNetwork=CreateObject("wscript.network")
strDomain=objNetwork.UserDomain

Set objUser = GetObject("WinNT://" & strDomain)

UserCount=0
WScript.Echo "Processing users in " & UCase(strDomain)
objFile.WriteLine "Name,FullName,Description,PasswordExpires(Days),PassWordAge(Days),AccountExpires,HomeDrive,HomeDirectory"
objUser.Filter = Array("user")
	for each x In objUser
	UserCount=UserCount+1
	if x.UserFlags >=65536 then
		  strPasswordExpires="Never"
			else
	  	  strPassWordExpire=x.PasswordExpirationDate
	  	end If
	 if x.AccountExpirationDate="" then
		  strAccountExpires="Never"
			else
	  	  strAccountExpires=x.AccountExpirationDate
		end if 	
  	objFile.writeline x.name & "," & x.fullname & "," & x.description & "," & strPasswordExpires &_
  	"," & FormatNumber(x.PasswordAge/86400) & "," & strAccountExpires & "," &_
  	"," &x.HomeDirDrive& "," &x.HomeDirectory
	next 

wscript.echo "Enumerated " & UserCount & " users in the " & UCASE(strDomain) & " domain.  See " &_
strLog & " for details."
objFile.Close

wscript.quit

'EOF
