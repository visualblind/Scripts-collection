'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File: BrowseSchema.vbs
'
'	Comments: Connect to the specified ADSI object and return all of its
' 	mandatory and optional properties.
'
'   Disclaimer: This source code is intended only as a supplement to 
'		SAPIEN Development Tools and/or on-line documentation.  
'		See these other materials for detailed information 
'		regarding SAPIEN code samples.
'
'	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
'	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
'	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
'	PARTICULAR PURPOSE.
'
'**************************************************************************
'VERSION HISTORY
'   1.1 3/20/2007
'   1.0 2/1/2007

On Error Resume Next
Dim objNetwork
Set objNetwork=CreateObject("WScript.Network")
strTitle="ADSI Schema Browse"
strPrompt="Enter an ADSI path:"
strDefault="WinNT://" & objNetwork.ComputerName
strADSPath=InputBox(strPrompt,strTitle,strDefault)
If strADSPath="" Then WScript.Quit

Set objVar=GetObject(strADSPath)
If IsObject(objVar) Then
    strHeader="General Object properties for " & objVar.Name
    
    wscript.echo strHeader
    WScript.Echo String(Len(strHeader),"-")
    
    Set objClass = GetObject(objVar.Schema)
    Wscript.Echo "Class: " & objClass.Name
    Wscript.Echo "GUID: " & objClass.GUID
    Wscript.Echo "Implemented by: " & objClass.CLSID
    
    WScript.Echo VbCrLf
    
    strMandatoryHeader="Mandatory Properties in this Class (" &_
    UBound(objClass.MandatoryProperties)+1 & "): "
    Wscript.Echo strMandatoryHeader
    WScript.Echo String(Len(strMandatoryHeader),"-")
    For Each objProperty In objClass.MandatoryProperties
        Wscript.Echo "  " & objProperty & " :  " &_
         GetValue(objVar,objProperty)
    Next
    
    WScript.Echo VbCrLf
    
    strOptionalHeader="Optional Properties in this Class (" &_
    UBound(objClass.OptionalProperties)+1 & "): "
    Wscript.Echo strOptionalHeader
    WScript.Echo String(Len(strOptionalHeader),"-")
    
    For Each objProperty In objClass.OptionalProperties
       Wscript.Echo "  " & objProperty & " : " &_
        GetValue(objVar,objProperty)
    Next
Else
    WScript.Echo "Failed to get " & strADSPath
End if
    
wscript.quit
 
 Sub subA(paramA, param_B, paramC, param_D)
 	
 End Sub
 
  
 Function GetValue(objItem,str_Property)
 On Error Resume Next
 Dim objProperty
 
 WScript.Echo str
 objProperty=objItem.Get(str_Property)
 If TypeName(objProperty)<>"Empty" Then
     If IsArray(objProperty) Then
        if TypeName(objProperty)="Byte()" Then
            strProp="Byte array"
        Else
           wscript.echo "!!" & strProperty & " is an array!!"
            For x=0 To UBound(objProperty)-1
                strProp=strProp & "  " &objProperty(x) & VbCrLf
            Next
        End If
    Else
       strProp=objItem.Get(str_Property)
       If strProp="" Then strProp="Defined but no value"
    End If
 Else
    strProp="Not Defined"
 End If
   GetValue=strProp

End Function
