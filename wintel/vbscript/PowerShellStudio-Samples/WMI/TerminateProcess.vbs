'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  TerminateProcess.vbs
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

strComputer = "." 
strprocess="searchindexer.exe"

Set objWMIService = GetObject("winmgmts:" &_
"{impersonationLevel=impersonate}!\\"&strComputer&"\root\cimv2")

Set colProcesses = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = '" & strProcess &"'")

If colProcesses.Count >0 Then
  Response = MsgBox ("The process " & strProcess & " is currently running." & vbNewLine & vbNewLine & "Would you like to stop this process now?",vbInformation + vbYesNo, "Process Example")
  If Response = vbYes Then
    For Each objProcess In colProcesses
       r=objProcess.Terminate
       WScript.Echo r
    Next
  End If
End If


