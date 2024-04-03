//**************************************************************************
//
//	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
//   This file is part of the PrimalScript 2011 Code Samples.
//
//	File:  ASPDebugTest.js
//
//	Comments:
//
//   Disclaimer: This source code is intended only as a supplement to 
//				SAPIEN Development Tools and/or on-line documentation.  
//				See these other materials for detailed information 
//				regarding SAPIEN code samples.
//
//	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
//	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//	PARTICULAR PURPOSE.
//
//**************************************************************************

var Debug;

Debug = new ActiveXObject("PrimalScript.ASPOutputDebug");

Debug.Initialize("localhost",500);
if(Debug.Error == 1)
	WScript.Echo("Failed to allocate client socket!");
else if(Debug.Error == 2)
	WScript.Echo("Failed to create client socket!");
else if(Debug.Error == 3)
	WScript.Echo("Failed to connect");

Debug.OutputDebugString("Testing the ASP debugger");
if(Debug.Error == 4)
	WScript.Echo("Failed to send on client socket");
Debug.OutputDebugString("Testing second line");
if(Debug.Error == 4)
	WScript.Echo("Failed to send on client socket");
Debug.OutputDebugString("ASP can now write to ports");
if(Debug.Error == 4)
	WScript.Echo("Failed to send on client socket");
Debug.OutputDebugString("On another machine");
if(Debug.Error == 4)
	WScript.Echo("Failed to send on client socket");
Debug.OutputDebugString("Or on localhost");
if(Debug.Error == 4)
	WScript.Echo("Failed to send on client socket");
Debug.Close()
