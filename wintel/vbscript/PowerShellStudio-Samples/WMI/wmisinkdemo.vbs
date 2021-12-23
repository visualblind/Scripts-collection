' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: WMISINKDEMO.VBS 
' 
' 	Comments: Demo script showing how to make asynchronous calls in WMI.  This
'	is done by using a SINK object.  Your script can carry on the wmi connection
'	task in the background while the script continues to execute other tasks.
'
'	This script doesn't have an enormous amount of functionality in and of itself,
'	it is for demonstration purposes.  There is no error handling.  See additional
'	comments in the script for more information.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY And/Or FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

On Error Resume Next

Dim service
Dim SINK
Dim wshell

set wshell=CreateObject("wscript.shell")

'to make this more interesting you might code in a connection to a remote system.
'Set service=GetObject("Winmgmts://DC2")
Set service = GetObject("Winmgmts://.")
Set SINK = WScript.CreateObject("WbemScripting.SWbemSink","SINK_")

service.Security_.ImpersonationLevel = 3

'Call our primary routine
CheckIt

'The script has to continue long enough for the async operation to complete.
'One way to accomplish this is to use a msgbox.  If you click ok, the
'script will finish before the async operation completes and it won't 
'have anywhere to display its results.
MsgBox "Waiting for processor information.  Do not press OK until you " & _
"get your results or you won't see anything.",0+64,"WMI Sink Demo"

wshell.Popup "The script has now completed.",5,"WMI Sink Demo"

'Cancel SINK since we no longer need it around to receive information.
SINK.Cancel()

'Clean up.  Not required but good scripting practice
wscript.DisconnectObject(service)

wscript.quit

'//////////////////////////////////////////////////////////////
Sub CheckIt()
On error Resume Next
'This is our routine that makes an async call.  In this case we are
'looking for a wmi instance of "Win32_Processor.  Script execution
'continues while this is happening.  This is more apparent if you 
'are connecting to remote systems or are making a call that may
'take some time to complete.  Your script can continue while you 
'wait for this information.
service.InstancesOfAsync SINK, "Win32_processor"
End Sub

'//////////////////////////////////////////////////////////////
Sub SINK_OnCompleted(iHResult, objErrorObject, objAsyncContext)
On Error Resume Next
'This subroutine is called when the async operation is complete.
'You would run whatever code you want here.
    wshell.Popup "Asynchronous operation is done. You can close the other message box.",2,"WMI Sink Demo"
End Sub


'//////////////////////////////////////////////////////////////
Sub SINK_OnObjectReady(objObject, objAsyncContext)
On Error Resume Next
'Once the sink object is ready we can execute whatever code we want.  
  S=S & "Processor: " & objObject.Name & Vbcrlf
  S=S & "Speed: " & objObject.CurrentClockSpeed & vbCrlf
  S=S & "L2 Cache: " & objObject.L2CacheSize & vbCrlf
  S=S & "Processor Load: " & CStr(objObject.LoadPercentage) & "%" & vbCrlf
  S=S & "Status: " & objObject.Status

wshell.popup S,5,objObject.Path_.Server & " - Processor Load"


End Sub

'EOF



