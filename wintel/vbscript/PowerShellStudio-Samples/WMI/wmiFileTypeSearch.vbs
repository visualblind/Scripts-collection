' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: WMIFileTypeSearch.vbs 
' 
' 	Comments: Search for all instances of a specified file type using WMI
'	and save output to a CSV file.  
'
'	NOTES:  Script captures FileName, Size (in bytes), Created Date, Last Modified
'	Date and Last Accessed Date.  Of course you can query for other properties as well.
'	You could easily rewrite the script to take variables as parameters. You 
'	could then use this as a computer startup script to do a little inventory.
'
'	This script works on local drives as well as any network drives that have been 
'	mapped to a drive letter.
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

On error Resume Next

Dim oWmi
Dim oRef
Dim fso,f

strTitle="File Type Search"
strType=InputBox("What type of file do you want to look for? Do NOT use a period.",strTitle,"vbs")
	If strType="" Then 
		wscript.echo "Nothing entered or you cancelled"
		wscript.quit
	End If	
strDrive=InputBox("What local drive do you want to search?  Do NOT use a trailing \",strTitle,"c:")
	If strDrive="" Then
		wscript.echo "Nothing entered or you cancelled"
		wscript.quit
	End If	

'trim strDrive just in case the user added a \
strDrive=Left(strDrive,2)

strOutput=InputBox("Enter full path and filename for the CSV file.  Existing files will " & _
"be overwritten.",strTitle,"c:\" & strType & "-query.csv")
	If strOutput="" Then
	wscript.echo "Nothing entered or you cancelled"
		wscript.quit
	End If	

strQuery="Select Name,CreationDate,LastAccessed,LastModified," & _
"FileSize,Extension,Drive FROM CIM_DATAFILE WHERE Extension='" & strType & _
 "' AND Drive='" & strDrive & "'"

Set fso=CreateObject("Scripting.FileSystemObject")
	If fso.FileExists(strOutput) Then fso.DeleteFile(strOutput)
Set f=fso.CreateTextFile(strOutput)
	If Err.Number Then
		wscript.echo "Could not create output file " & strOutput
		wscript.quit
	End If
	
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

wscript.echo "Working ...."
f.Writeline "FilePath,Size(bytes),Created,LastAccessed,LastModified"

For Each file In oRef
	f.Writeline file.Name & "," & file.FileSize & "," & ConvWMITime(file.CreationDate) & _
	 "," & ConvWMITime(file.LastAccessed) & "," & ConvWMITime(file.LastModified)
Next

f.Close

wscript.echo "Finished.  See " & strOutput & " for results"

Set oWmi=Nothing
Set oRef=Nothing
Set fso=Nothing
Set f=Nothing

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

'EOF