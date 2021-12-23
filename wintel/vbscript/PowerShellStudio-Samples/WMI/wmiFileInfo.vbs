' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: WMIFileInfo.vbs 
' 
' 	Comments: Get detailed file information including owner and DACL via WMI
'	on specified file.
'
'	This script works on local drives as well as any network drives that have been mapped to a drive
'	letter.  UNC paths will not work.
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
Dim oWmi
Dim oRef

On Error Resume Next

f=InputBox("Enter the full path and file name","File Info","c:\boot.ini")
If f="" Then
  wscript.echo "Nothing entered or you cancelled"
  wscript.quit
End If

strFile=Replace(f,"\","\\")

strQuery="Select CSName,Name,CreationDate,LastAccessed,LastModified,Encrypted," & _
"Hidden,Status,System,Compressed,EightdotThreeFileName,FileSize,AccessMask,Version, " & _
"Manufacturer FROM CIM_DATAFILE WHERE Name='" & strFile & "'"

Set oWmi=GetObject("winmgmts:")
If Err.Number Then
  strErrMsg= "Error connecting to WINMGMTS" & vbCrlf
  strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
        If Err.Description <> "" Then
            strErrMsg = strErrMsg & "Error description: " & Err.Description & "." & vbCrlf
        End If
  Err.Clear
  wscript.echo strErrMsg
  wscript.quit
End If

Set oRef=oWmi.ExecQuery(strQuery) 
If Err.Number Then
  strErrMsg= "Error connecting executing query!" & vbCrlf
  strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
        If Err.Description <> "" Then
            strErrMsg = strErrMsg & "Error description: " & Err.Description & "." & vbCrlf
        End If
  Err.Clear
  wscript.echo strErrMsg
  wscript.quit
End If

For Each item In oRef
 flag="y"
 strResults="File Information Report" & vbCrlf
 strResults=strResults & "System: " & item.CSNAME & vbCrlf
 strResults=strResults & "File: " & UCASE(item.Name) & vbCrlf
 strResults=strResults & "ShortName: " & UCASE(item.EightDotThreeFileName) & vbCrlf
 strResults=strResults & "Size: " & item.FileSize & " bytes" & vbCrlf
 strResults=strResults & "Created: " & ConvWMITime(item.CreationDate) & VbCrLf
 strResults=strResults & "Version: " & item.Version & VbCrLf
 strResults=strResults & "Vendor: " & item.Manufacturer & vbcrlf
 strResults=strResults & "Last Modified: " & ConvWMITime(item.LastModified) & vbTab & _
 "Last Accessed: " & ConvWMITime(item.LastAccessed) & vbCrlf
 strResults=strResults & vbCrlf & "Attributes" & vbCrlf
 strResults=strResults & String(LEN("Attributes"),"-") & vbCrlf
 strResults=strResults & "Encrypted:" & item.Encrypted & String(2," ") & "Hidden:" & item.Hidden & _
 String(2," ") & "Compressed:" & item.Compressed & String(2," ") & "System:" & _
 item.System & String(2," ") & "Status: " & item.Status & vbCrlf & vbCrlf
Next

 If flag="y" Then
  	GetOwner(strFile)
  	wscript.echo strResults & vbCrlf & Now
 Else
 	wscript.echo "File " & UCASE(f) & " not found"
 End If 

Set oWMI=Nothing
Set oRef=Nothing

wscript.quit


'************************************************************************************
' Convert WMI Time Function
'************************************************************************************
Function ConvWMITime(wmiTime)
On Error Resume Next

yr = left(wmiTime,4)
mo = mid(wmiTime,5,2)
dy = mid(wmiTime,7,2)
tm = mid(wmiTime,9,6)

ConvWMITime = mo & "/" & dy & "/" & yr & " " & FormatDateTime(left(tm,2) & _
":" & Mid(tm,3,2) & ":" & Right(tm,2),3)

End Function

'************************************************************************************
' Get File Owner Subroutine
'************************************************************************************
Sub GetOwner(strFile)
Dim objOwner
Dim objFile
Dim objDescriptor
Dim objDACL
On Error resume next
strFileQuery="Select * from Win32_LogicalFileSecuritySetting WHERE Path='" & _
strFile & "'"

Set objFile=oWMI.ExecQuery(strFileQuery)

For Each item In objFile
strHead=item.Caption
 strResults=vbCrlf & strResults & strHead & vbCrlf & String(LEN(strHead),"-") & vbCrlf
	r=item.GetSecurityDescriptor(objDescriptor)
	Select Case r
	Case 2 strResults = strResults & "Access denied" & vbCrlf 
	Case 8 strResults = strResults & "Unknown failure" & vbCrlf
	Case 9 strResults = strResults & "Privilege missing" & vbCrlf 
	Case 21 strResults = strResults & "Invalid parameter" & vbCrlf
	Case Else
		Set objOwner=objDescriptor.Owner
		strResults=strResults & "Owner: " & objOwner.Name & vbCrlf 
		objDACL=objDescriptor.DACL
		strResults=strResults & "DACL:" & vbCrlf
		For Each ACE In objDACL
		Set Trustee = ACE.Trustee
    		strResults=strResults & " * " & Trustee.Domain & "\" & Trustee.Name & vbCrlf
		 If ACE.AceType=0 Then 
		 	strResults=strResults & "    Allowed Permissions -" & vbCrlf
		 Else
		 	strResults=strResults & "    Denied Permissions -" & vbCrlf
		 End If
	     		
	    		strResults=strResults & "    " & AccessMaskDecode(ACE.AccessMask) & vbCrlf
		Next
	End Select
Next

Set objOwner=Nothing
Set objFile=Nothing
Set objDescriptor=Nothing
Set objDACL=Nothing

End Sub

'************************************************************************************
' Decode Access Control Masks Function
'************************************************************************************
Function AccessMaskDecode(objMask)
Dim z
If objMask And 1048576 Then z=z & "Synchronize,"
If objMask And 524288 Then z=z & "WriteOwner,"
If objMask And 262144 Then z=z & "WriteACL,"
If objMask And 131072 Then z=z & "ReadSecurity,"
If objMask And 65536 Then z=z & "Delete,"
If objMask And 256 Then z=z & "WriteAttrib,"
If objMask And 128 Then z=z & "ReadAttrib,"
If objMask And 64 Then z=z & "DeleteDir,"
If objMask And 32 Then z=z & "Execute,"
If objMask And 16 Then z=z & "WriteExtAttrib,"
If objMask And 8 Then z=z & "ReadExtAttrib,"
If objMask And 4 Then z=z & "Append,"
If objMask And 2 Then z=z & "Write,"
If objMask And 1 Then z=z & "Read"
AccessMaskDecode=z

Set z=Nothing
End Function

'EOF
