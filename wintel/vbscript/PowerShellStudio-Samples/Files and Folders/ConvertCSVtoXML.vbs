' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: ConvertCSVtoXML.vbs 
' 
' 	Comments:
' 
' `	Usage: cscript|wscript ConvertCSVtoXML.vbs
'	Notes: You will be prompted to find the CSV file to convert and a
'	name of an xml file to create.  This script requires Windows XP.
'	The script assumes the first line of the csv file is for headings.
'	Using ADODB, the script parses out the headings and creates an
'	<ITEM> tag for each line of the csv file.  Within each <ITEM>
'	tag are child tags for each heading.  If no value is found for
'	a heading in a particular line, then the XML text for that heading
'	is set to '.'.  Otherwise, the tag doesn't get closed properly.
'	The OpenFile dialog box doesn't have a csv filter, but if you
'	type in *.csv and click Open, the dialog box will refresh And
'	present a filtered view.
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
'
On Error Resume Next
'convert CVS file to XML format
Dim objFSO
dim objXML
Dim objRoot
Dim objNode
Dim objAttrib
Dim objChildNode
Dim objConnection, objRecordset,objFields

Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adCmdText = &H0001

strSource=OpenFilePath()	'You must return a full filename and path for the source CSV file.
strXMLFile=SaveAs("demo.xml")	'Specify the name of the XML file to create.

Set objConnection = CreateObject("ADODB.Connection")
Set objRecordset = CreateObject("ADODB.Recordset")

Set objFSO=CreateObject("Scripting.FileSystemObject")

'verify csv file exists just in case someone manually typed in a filename and path.
If objFSO.FileExists(strSource) Then
	tmpArray=Split(GetFilePath(strSource),",")
	strPathtoTextFile = tmpArray(0)
	strFile=tmpArray(1)
	'if path component not defined then exit script
	If strPathtoTextFile=" " Then
		WScript.Echo "Can't determine path to " & strSource & "."
		WScript.Quit
	End If
	
	objConnection.Open "Provider=Microsoft.Jet.OLEDB.4.0;" & _
          "Data Source=" & strPathtoTextFile & ";" & _
          "Extended Properties=""text;HDR=YES;FMT=Delimited"""

	objRecordset.Open "SELECT * FROM " & strFile, _
          objConnection, adOpenStatic, adLockOptimistic, adCmdText

	'Create XML document
	SET objXML = CreateObject("Microsoft.XMLDOM")
	set objRoot=objXML.createNode("element","Main","")
	objXML.appendChild(objRoot)
	set objAttrib=objXML.createAttribute("Created") 
	objXML.documentElement.setAttribute "Created",Now
	set objAttrib=objXML.createAttribute("Source") 
	objXML.documentElement.setAttribute "Source",strSource
	
	Set objFields=objRecordset.Fields
	Do Until objRecordset.EOF
	'Create an "Item" tag for each entry in the file
	Set objNode=objXML.createNode("Element","Item","")
		objRoot.appendChild(objNode)
		
	For z=0 To objFields.Count-1
		strHeading=objFields.Item(z).name 
		'WScript.Echo "Adding element for " & strHeading
		Set objChildNode=objXML.createNode("Element",strHeading,"")
		'if value in CSV is blank 
		If IsNull(objRecordset.Fields(strHeading)) Then 
			strText="." 'we'll use a . so that the tag closes
		Else
			strText=objRecordset.Fields(strHeading)
		End If
		'set the value of the child node
		objChildNode.text=strText
		objNode.appendChild objChildNode
	Next
	objRecordset.MoveNext
	Loop
	objConnection.Close
	'commit XML changes to disk
	objXML.save(strXMLfile)

	'display a summary message
	WScript.Echo "Converted " & strSource & " to " & strXMLFile
Else
	'display error message and quit script
    WScript.Echo "Failed to find " & strSource
	WScript.quit
End If

WScript.Quit

'//////////////////////////////////////////////
'parse filename from path function
'//////////////////////////////////////////////
Function GetFilePath(strFile)
'returns an csv array of path component and file component
On Error Resume Next
strTmp=StrReverse(strFile)
strFileName=Left(strTmp,InStr(strTmp,"\")-1)
strFileName=StrReverse(strFileName)
strPath=Mid(strTmp,InStr(strTmp,"\"))
strPath=StrReverse(strPath)
GetFilePath=strPath & "," & strFileName

End Function

'//////////////////////////////////////////////
'Present OpenFile dialog box and return filename
'with path
'//////////////////////////////////////////////

Function OpenFilePath()

On Error Resume Next
Dim objDialog
Set objDialog=CreateObject("SAFRCFileDlg.FileOpen")

objDialog.OpenFileOpenDlg
srcFile=objDialog.FileName

OpenFilePath=srcFile
End Function

'//////////////////////////////////////////////
'Present the SaveAs dialogbox and return 
'filename with path
'//////////////////////////////////////////////

Function SaveAs(strFile)
'requires Windows XP or later
Dim objDialog
Set objDialog=CreateObject("SAFRCFileDlg.FileSave")

objDialog.filename=strFile
objDialog.OpenFileSaveDlg
SaveAs=objDialog.FileName

End function