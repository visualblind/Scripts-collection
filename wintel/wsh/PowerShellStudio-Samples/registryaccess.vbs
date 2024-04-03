'===========================================================================
'
' VBScript Source File -- Created with SAPIEN Technologies PrimalScript 2011
'
' NAME: RegistryAccess.vbs
'
' AUTHOR: Alexander Riedel , SAPIEN Technologies, Inc.
' DATE  : 8/2/2009
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
'===========================================================================

'Some constants to make things easier
Const HKLM = "HKEY_LOCAL_MACHINE"
Const HKCU = "HKEY_CURRENT_USER"
Const HKU =  "HKEY_USERS"
Const HKCC = "HKEY_CURRENT_CONFIG"
Const HKCR = "HKEY_CLASSES_ROOT"

Const REG32BIT = 1
Const REG64BIT = 2


' ***************************************************************************************************
'Declare a registry access object
' ***************************************************************************************************
Dim RegObj
Set RegObj = CreateObject("SAPIEN.RegistryAccess")
' ***************************************************************************************************

' ***************************************************************************************************
' Example 1: Check if a specific key/value exists
' ***************************************************************************************************
if RegObj.IsKey(HKCR,"SystemFileAssociations\text\shell\Edit with PrimalXML") = True Then 
	WScript.Echo "PrimalXML is associated with text files"
else
	WScript.Echo "PrimalXML is NOT associated with text files"
End If
If RegObj.IsValue(HKLM,"SOFTWARE\SAPIEN Technologies, Inc.\PrimalScript\2009","Path") = True Then
	WScript.Echo "PrimalScript 2011 is installed on this machine"
Else
	WScript.Echo "PrimalScript 2011 is not installed on this machine"
End If
' ***************************************************************************************************


' ***************************************************************************************************
' Example 2: Open an existing key and retrive the content of a specific value
' ***************************************************************************************************
If RegObj.OpenKey(HKCR,".xml",False) = True Then
	WScript.Echo("The settings for the .XML file extension are:")
	WScript.Echo("The content type is: " & RegObj.GetValue("Content Type"))
	WScript.Echo("The perceived type is: " & RegObj.GetValue("PerceivedType"))
	' Getting  the default value of the key uses an empty string
	WScript.Echo("The default value of this key is: " & RegObj.GetValue("")) 
Else
	WScript.Echo(".XML is not defined as extension")
End If
RegObj.CloseKey
' ***************************************************************************************************


' ***************************************************************************************************
' Example 3: List the values of a key
' ***************************************************************************************************
If RegObj.OpenKey(HKLM,"SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine",False) = True Then
	WScript.Echo( vbCrLf & "Some information about the PowerShell engine from the registry")
	valueArray = RegObj.GetValueList()
	For Each value In valueArray
		WScript.Echo(value & " = " & RegObj.GetValue(value))
	Next
Else
	WScript.Echo("PowerShell is not installed")
End If
RegObj.CloseKey
' ***************************************************************************************************


' ***************************************************************************************************
' Example 4: Create a key if it does not exist and set a value.
' ***************************************************************************************************
'Specifying True as the third parameter creates the key if it does not exist.
If RegObj.OpenKey(HKCR,".xml",True) = True Then 
	' Supported value types are REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ and REG_DWORD
	RegObj.SetValue "Content Type","text/xml","REG_SZ"
	RegObj.SetValue "PerceivedType","text","REG_SZ" 
	' Use the FullKeyPath property to get the path of a registry key, e.g. for output
	WScript.Echo(vbCrLf & "Values set for " & RegObj.FullKeyPath & vbCrLf)
Else
	' So we could not open the key and also not create it
	' Print the error message
	WScript.Echo(RegObj.ErrorDescription)
End If
RegObj.CloseKey
' ***************************************************************************************************


' ***************************************************************************************************
' Example 5: Connect to a remote machine's registry and retrieve a key setting
' ***************************************************************************************************
If RegObj.ConnectRegistry("\\Vista64","HKCR", "User", "password") = False Then
	WScript.Echo "Connect failed"
	WScript.Echo RegObj.ErrorDescription
	'The message "Error 53: The network path was not found." usually
	'indicates that the Remote Registry Service on the remote computer is not
	'running. With Vista and Windows 7 this service is not started by default.
Else
	'List the Text file associations on the remote machine
	If RegObj.GotoSubKey("SystemFileAssociations\text\shell") = True Then
		Keys = RegObj.GetKeyList() ' Get a list of the verbs registered
		WScript.Echo "Enumerating sub keys for file associations with perceived type text"
		For Each key In Keys
			WScript.Echo "Verb: " + key
			'Open a new key to the command subkey. This creates a new object
			Set SubKey = RegObj.GetSubKey(key + "\command", vbFalse)
			DefaultValue = SubKey.GetValue("")
			WScript.Echo "Command line: " + DefaultValue
			SubKey.CloseKey ' If you are not re-using the object to open another key, call CloseKey
		Next
	Else
		WScript.Echo "GotoSubkey failed"
		WScript.Echo RegObj.ErrorDescription
	End If
end If
RegObj.CloseKey

' ***************************************************************************************************


' ***************************************************************************************************
' Example 6: Access the 64 bit part of the registry under a 64 bit OS from a 32 bit script.
' ***************************************************************************************************
'List the Text file associations
Sub EnumerateTextAssociations()
	If RegObj.OpenKey(HKCR,"SystemFileAssociations\text\shell",False) = True Then
		Keys = RegObj.GetKeyList() ' Get a list of the verbs registered
		WScript.Echo "Enumerating sub keys for file associations with perceived type text"
		For Each key In Keys
			WScript.Echo "Verb: " + key
			'Open a new key to the command subkey. This creates a new object
			Set SubKey = RegObj.GetSubKey(key + "\command", vbFalse)
			DefaultValue = SubKey.GetValue("")
			WScript.Echo "Command line: " + DefaultValue
			SubKey.CloseKey ' If you are not re-using the object to open another key, call CloseKey
		Next
		RegObj.CloseKey
	End If
End Sub

'Set registry view to 32 bit (default)
RegObj.RegistryView = REG32BIT
EnumerateTextAssociations
'Set registry view to 64 bit
RegObj.RegistryView = REG64BIT
EnumerateTextAssociations
' ***************************************************************************************************


' ***************************************************************************************************
' Example 7: Create a backup and restore a specific key in the registry.
' ***************************************************************************************************
RegObj.OpenKey HKCR,"SystemFileAssociations",False
'Now we can save all the file associations to a file
RegObj.SaveKey "\\Orion\share\SysFileAssoc.dat"
'Note that the backup file is a binary file, not a .REG text file.
RegObj.CloseKey

'We can easily restore a key buy opening the key again
RegObj.OpenKey HKCR,"SystemFileAssociations",True ' Create the key if it does not exist
RegObj.RestoreKey "\\Orion\share\SysFileAssoc.dat", True 
'Specifying Force=True restores even if keys are open
RegObj.CloseKey
' ***************************************************************************************************
