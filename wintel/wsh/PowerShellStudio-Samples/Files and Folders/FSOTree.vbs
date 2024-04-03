'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  FSOTree.vbs
'
'	Comments: Create a folder tree with file sizes indicated at each level.
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

strFolder="C:\"
nTabLevel=0
Set objFSO=CreateObject("Scripting.FileSystemObject")
Set objFolder=objFSO.GetFolder(strFolder)
WScript.Echo objFolder
Call ProcessSubFolders(nTabLevel,objFolder)

Sub ProcessSubFolders(nTabLevel,objFolder)
   nTabLevel = nTabLevel +1

Set colSubs=objFolder.SubFolders
For Each folder In colSubs
    WScript.Echo String(nTabLevel," ") & "|" & String(nTabLevel,"_") & folder.name &_
     " (" & FormatNumber(folder.size/1024,2) & " KB)"
    ProcessSubFolders ntabLevel,folder
Next

nTabLevel=nTabLevel-1
End Sub
