' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: VoiceDemo.vbs
' 
' 	Comments:
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************
Dim objSPVoice,colVoices

Set objSPVoice=CreateObject("SAPI.SpVoice")

objSPVoice.Speak "Hello world! Thank you for trying Primal Script."

Set colVoices=objSPVoice.GetVoices()
WScript.Echo "Found " & colVoices.Count & " voice(s) installed:"
For x=0 To colVoices.Count-1
Set objSPVoice.Voice=objSPVoice.GetVoices.Item(x)
WScript.Echo objSPVoice.Voice.GetDescription
    objSPVoice.speak "I am item " & x & ", " & objSPVoice.Voice.GetDescription
    objSPVoice.Speak "To be, or not to be. That, is the question."
Next
