'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CreateShortcut.vbs
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


L_Welcome_MsgBox_Message_Text   = "This script will create a shortcut to Notepad on your desktop."
L_Welcome_MsgBox_Title_Text     = "Windows Scripting Host Sample"
Call Welcome()

' ********************************************************************************
' *
' * Shortcut related methods.
' *

Dim WSHShell
Set WSHShell = WScript.CreateObject("WScript.Shell")


Dim MyShortcut, MyDesktop, DesktopPath

' Read desktop path using WshSpecialFolders object
DesktopPath = WSHShell.SpecialFolders("Desktop")

' Create a shortcut object on the desktop
Set MyShortcut = WSHShell.CreateShortcut(DesktopPath & "\Shortcut to notepad.lnk")

' Set shortcut object properties and save it
MyShortcut.TargetPath = WSHShell.ExpandEnvironmentStrings("%windir%\notepad.exe")
MyShortcut.WorkingDirectory = WSHShell.ExpandEnvironmentStrings("%windir%")
MyShortcut.WindowStyle = 4
MyShortcut.IconLocation = WSHShell.ExpandEnvironmentStrings("%windir%\notepad.exe, 0")
MyShortcut.Save

WScript.Echo "A shortcut to Notepad now exists on your Desktop."

' ********************************************************************************
' *
' * Welcome
' *
Sub Welcome()
    Dim intDoIt

    intDoIt =  MsgBox(L_Welcome_MsgBox_Message_Text,    _
                      vbOKCancel + vbInformation,       _
                      L_Welcome_MsgBox_Title_Text )
    If intDoIt = vbCancel Then
        WScript.Quit
    End If
End Sub
