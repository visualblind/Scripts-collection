'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CmdPromptExplorerMenu.vbs
'
'	Comments:
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


Dim WSHShell
Set WSHShell = WScript.CreateObject("WScript.Shell")

WSHShell.RegWrite "HKCR\Folder\Shell\MenuText\Command\", "cmd.exe /k cd " & chr(34) & "%1" & chr(34)
WSHShell.RegWrite "HKCR\Folder\Shell\MenuText\", "Cmd Prompt Here"

