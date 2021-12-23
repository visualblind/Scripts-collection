//**************************************************************************
//
//	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
//   This file is part of the PrimalScript 2011 Code Samples.
//
//	File:  RestoreMSE.js
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

var shell = new ActiveXObject("WScript.Shell");

var JITDebugRoot = "HKCR\\CLSID\\{834128A2-51F4-11D0-8F20-00805F2Cd064}";
var JITDebugLocalServer32 = JITDebugRoot + "\\LocalServer32\\";

var LocalServer32;
var JITDebugProgID = JITDebugRoot + "\\ProgID\\";
var JITDebugVersionIndependentProgID = JITDebugRoot + "\\VersionIndependentProgID\\";

LocalServer32 = "C:\\Winnt\\System32\\mdm.exe";
shell.RegWrite(JITDebugProgID, "MDM.SESSPROV.1");
shell.RegWrite(JITDebugVersionIndependentProgID, "MDM.SESSPROV");
shell.RegWrite(JITDebugLocalServer32, LocalServer32);

