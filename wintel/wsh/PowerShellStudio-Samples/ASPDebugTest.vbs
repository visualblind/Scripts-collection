'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ASPDebugTest.vbs
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


Option Explicit
Dim Debug

set Debug = CreateObject ("PrimalScript.ASPOutputDebug")

Debug.Initialize "localhost",500
if Debug.Error = 1 then
	WScript.Echo "Failed to allocate client socket!"
elseif Debug.Error = 2 then
	WScript.Echo "Failed to create client socket!"
elseif Debug.Error = 3 then
	WScript.Echo "Failed to connect"
end if	

Debug.OutputDebugString "Testing the ASP Debugger"
if Debug.Error = 4 then
	WScript.Echo "Failed to send on client socket"
end if

Debug.OutputDebugString "Testing second line"
if Debug.Error = 4 then
	WScript.Echo "Failed to send on client socket"
end if

Debug.OutputDebugString "ASP can now write to ports"
if Debug.Error = 4 Then
	WScript.Echo "Failed to send on client socket"
end if

Debug.OutputDebugString "On another machine"
if Debug.Error = 4 then
	WScript.Echo "Failed to send on client socket"
end if

Debug.OutputDebugString "On on localhost"
if Debug.Error = 4 then
	WScript.Echo "Failed to send on client socket"
end if

Debug.Close
Set Debug = nothing
