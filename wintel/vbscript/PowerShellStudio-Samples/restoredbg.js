//**************************************************************************
//
//	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
//   This file is part of the PrimalScript 2011 Code Samples.
//
//	File:  restoredbg.js
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

var DebuggerLocationKey = "HKCR\\TypeLib\\{5B54B110-CF10-11D0-BF8B-0000F81E8509}\\1.0\\0\\win32\\";

var JITDebugRoot = "HKCR\\CLSID\\{834128A2-51F4-11D0-8F20-00805F2Cd064}";
var JITDebugLocalServer32 = JITDebugRoot + "\\LocalServer32\\";

var LocalServer32;
var JITDebugProgID = JITDebugRoot + "\\ProgID\\";
var ProgID = "ScriptDebugSvc.ScriptDebugSvc.1";
var JITDebugVersionIndependentProgID = JITDebugRoot + "\\VersionIndependentProgID\\";
var VersionIndependentProgID = "ScriptDebugSvc.ScriptDebugSvc";

var debuglocation;
try
{
	 LocalServer32 = shell.RegRead(DebuggerLocationKey);
}
catch(e)
{
	if (e.description == "Unable to open registry key \"" + DebuggerLocationKey + "\" for reading.")
	{
		WScript.Echo("Error locating Script Debugger - is it installed?");
	}
	else
	{
		WScript.Echo("Error: " + e.description);
	}
	WScript.Quit();
}
shell.RegWrite(JITDebugLocalServer32, LocalServer32);
shell.RegWrite(JITDebugProgID, ProgID);
shell.RegWrite(JITDebugVersionIndependentProgID, VersionIndependentProgID);

