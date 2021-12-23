' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: DumpOUs.vbs 
' 
' 	Comments:
'	This script enumerate ALL OUs in your domain and lists specified object class within each OU,
'	such as users, groups or computers.  The default is ALL type of objects.
'	This script only enumerates OUs.  It will not look in the default USERS container.
'	You would need to modify the script.
'	This script will work best when used with CSCRIPT.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY And/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************
On error Resume Next
Dim Root,Domain

strFlag="ALL"

Select Case UCASE(wscript.arguments(0))
	Case "USER"		strFlag="USER"
	Case "GROUP"	strFlag="GROUP"
	Case "COMPUTER"	strFlag="COMPUTER"
	Case "ALL"		strFlag="ALL"
	Case "?"		ShowHelp
				Wscript.quit
	Case Else
		wscript.echo vbCrlf & UCASE(wscript.arguments(0)) & _
		 " is an invalid parameter!" & vbCrlf
		ShowHelp
		Wscript.quit
End Select

Set Root = GetObject("LDAP://RootDSE")
DomainPath = Root.Get("DefaultNamingContext")
Set Domain = GetObject("LDAP://" & DomainPath)

strMsg="OU listings for " & strFlag & " in " & Domain.ADSPath
wscript.echo strMsg & vbCrlf & String(LEN(strMsg),"-") & vbCrlf

EnumOU Domain.ADSPath,strFlag

Set domain=Nothing
Set Root=Nothing

wscript.quit

'*************************************************************************************
Sub EnumOU(objADSPath,objClass)
On error Resume Next

Dim objOU,objPath

Set objPath = GetObject(objADSPath)
objPath.Filter=Array("organizationalUnit")

For Each item in objPath
  wscript.echo item.Name & " (" & item.ADSPath & ")"
  
  If objClass <> "ALL" Then
	  set objOU=GetObject(item.ADSPath)
	  objOU.Filter=array(objClass)
	  for Each obj In objOU
	  'modify to display as much information as you want
	   wscript.echo "  " & obj.sAMAccountName & " (" & obj.Class & ")"
	  Next
	 'Iterate through
	  EnumOU item.ADSPath,objClass
  Else
  	  'display all objects in the OU
	  set objOU=GetObject(item.ADSPath)
	  for Each obj In objOU
	   wscript.echo "  " & obj.sAMAccountName & " (" & obj.Class & ")"
	  Next
	 'Iterate through
	  EnumOU item.ADSPath,objClass
  End If
Next

Set objPath=Nothing
set objOU=Nothing

End Sub

'*************************************************************************************
'Display help information
Sub ShowHelp()
On Error Resume Next
Dim strMsg

strMsg=UCASE(wscript.ScriptName) & vbCrlf
strMsg=strMsg & "Usage - cscript " & LCASE(wscript.ScriptName) & _
 " [user|group|computer|all|?]" & vbCrlf & vbCrlf
strMsg=strMsg & "Description:  This script enumerate OUs In your domain and lists " & _
vbCrlf & "specified object class within each OU, such as users, groups or computers." & _
vbCrlf & "The default is ALL type of objects." & vbCrlf & vbCrlf
strMsg=strMsg & "Notes:  This script only enumerates OUs.  It will not look in the " & _
vbCrlf & "default USERS container." & vbCrlf & vbcrlf
strMSg=strMsg & "This script will work best when used with CSCRIPT."

wscript.echo strMsg

End Sub

'EOF