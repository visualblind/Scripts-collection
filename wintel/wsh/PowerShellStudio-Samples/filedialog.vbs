' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: filedialog.vbs
' 
' 	Comments:
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

Dim obj
Dim numFiles
Dim counter

Set obj = WScript.CreateObject("Primalscript.FileDialog")
obj.HideReadOnly = vbTrue
obj.Title = "Try to open that file"
obj.InitialDir = "C:\Program Files"
obj.InitialFileName = "desktop.ini"
obj.Filter = "Chart Files (*.xlc)|*.xlc|Worksheet Files (*.xls)|*.xls|Data Files (*.xlc;*.xls)|*.xlc; *.xls|All Files (*.*)|*.*||"
obj.FilterIndex = 4
obj.ShowHelp = vbTrue
obj.AllowMultiSelect = vbTrue
obj.FileOpenDialog
numFiles = obj.NumFilesSelected

WScript.Echo "Selected Files"
WScript.Echo numFiles
For counter = 0 To numFiles - 1
	WScript.Echo obj.SelectedFiles(counter)
Next

obj.Title = "Try to save that file"
obj.FileSaveDialog