'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  FolderReport.vbs
'
'	Comments:
'
'   Disclaimer: This source code is intended only as a supplement to 
'		SAPIEN Development Tools and/or on-line documentation.  
'		See these other materials for detailed information 
'		regarding SAPIEN code samples.
'
'	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
'	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
'	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
'	PARTICULAR PURPOSE.
'
'**************************************************************************

strSource="c:\"
iGrandTotalCount=0
iGrandTotalSum=0

Set objFSO=CreateObject("Scripting.FileSystemObject")
Set objFolder=objFSO.GetFolder(strSource)

Call ProcessFiles(objFolder)

WScript.Echo "Total count = " & iGrandTotalCount &_
 " files (" & iGrandTotalSum & " bytes)"

Sub ProcessFiles(objFolder)
Set colFiles=objFolder.Files
iSum=0

For Each file In colFiles
   iSum=iSum+file.size
Next

'increment grand total counters
iGrandTotalSum=iGrandTotalSum+iSum
iGrandTotalCount=iGrandTotalCount+colFiles.Count

wscript.Echo objFolder & " = " & colFiles.Count &_
 " files (" & iSum & " bytes)"

'process Subfolders
Call ProcessSubFolders(objFolder)

End Sub

Sub ProcessSubFolders(objFolder)
Set colSubs=objFolder.SubFolders
For Each folder In colSubs
    ProcessFiles(folder)
Next

End Sub
