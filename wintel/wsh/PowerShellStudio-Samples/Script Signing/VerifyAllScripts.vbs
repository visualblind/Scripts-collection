'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  VerifyAllScripts.vbs
'
'	Comments: Verify scripts have been signed and are intact.
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
strDir=InputBox("Enter the script folder path:",_
"Verify Scripts","C:\scripts")
Set objSigner = CreateObject("Scripting.Signer")
Set objFSO=CreateObject("Scripting.FileSystemObject")
If objFSO.FolderExists(strDir) Then
    Set objFldr=objFSO.GetFolder(strDir)
Else
    WScript.Echo "Failed to find " & strDir
    WScript.Quit
End If

Set colFiles=objFldr.Files
For Each file In colFiles
    If file.type="VBScript Script File" Then
        if objSigner.VerifyFile(file) Then
            WScript.Echo "VERIFIED " & file
        Else
            WScript.Echo "FAILED  " & file
        End If
    End If
Next
