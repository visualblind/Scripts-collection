' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: EnumerateForestGroups.vbs 
' 
' 	Comments:
' Given a user's UPN, display all groups, including nested groups
' that the user belongs to.  This requires access to a Global Catalog to
' resolve the UPN and then connectivity to a domain controller for the domain
' the user belongs to as well as any domain controllers for any other groups 
' in other domains.   This script uses the PopUp method to display
' results of the query.  If there are more than 12 groups you may need to modify
' the script to display the results as pages or rewrite the script to send output
' to a text file or the console.
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
Dim wshShell
Set wshShell=CreateObject("WScript.Shell")
strTitle="Enumerate Groups"

'constants for popup icons
Const StopSign=16
Const Question=32
Const Exclamation=48
Const Information=64

'prompt for UPN
strUPN=InputBox("What is the UPN of the user you want to query?",strTitle,"Someone@somewhere.com")
If strUPN="" Then
	 wshShell.Popup "Nothing entered or you cancelled",20,strTitle,vbOKOnly+Exclamation
	WScript.Quit
Else
	UserDN=GetDN(strUPN)
End If

If UserDN<>"NOTFOUND" Then
	strMsg="Group memberships for " & UserDN & vbcrlf
	EnumerateMembership(UserDN)
Else
	strMsg=strUPN & " was not found in the global catalog."
End If
wshShell.Popup strMsg,20,strTitle,vbOKOnly+Information


'//////////////////////////////////////////////////////////////
Sub EnumerateMembership(grpADSpath)
	On Error Resume Next
	Set objGroup = GetObject("LDAP://" & grpADSPath)
	If Err.number<>0 Then 
		wshShell.Popup grpADSPath & " not found",20,strTitle,vbOKOnly+Exclamation
		WScript.Quit
	Else
		objGroup.GetInfo
	End If
	
	arrMembersOf = objGroup.GetEx("memberOf")
	
	'uncomment for debugging
	'WScript.Echo objGroup.name & " is a member of:"
	
	For Each strMemberOf in arrMembersOf
	  If strMemberOf="" Then
	    Exit sub	'if we don't find any groups on the first pass, then bail out
	  Else
	    strMsg=strMsg & strMemberOf & vbcrlf
	  	EnumerateMembership(strMemberOf)
	  End If
	
	Next

End Sub

'//////////////////////////////////////////////////////////////

Function GetDN(strUPN)
	Dim oConnection 
	Dim oRecordset 
	Dim strQuery 
	Dim oCont 
	Dim oGC 
	Dim strADsPath '
	
	'Find the Global Catalog server
	'This assumes the script will be executed within an AD domain.
	Set oCont = GetObject("GC:")
	For Each oGC In oCont
	strADsPath = oGC.ADsPath
	Next
	Set oConnection = CreateObject("ADODB.Connection")
	Set oRecordset = CreateObject("ADODB.Recordset")
	oConnection.Provider = "ADsDSOObject" 'The ADSI OLE-DB provider
	oConnection.Open "ADs Provider"
	strQuery = "<" & strADsPath & ">;(&(objectClass=user)(objectCategory=person)(userprincipalName=" & strUPN & "));userPrincipalName,cn,distinguishedName;subtree"
	'WScript.Echo strQuery
	Set oRecordset = oConnection.Execute(strQuery)
	If oRecordset.EOF And oRecordset.BOF Then
		GetDN="NOTFOUND"
	Else
		While Not oRecordset.EOF
			'WScript.Echo oRecordset.Fields("distinguishedname")
			 GetDN=oRecordset.Fields("distinguishedName")
			oRecordset.MoveNext
		Wend
	End If

End Function

'EOF
