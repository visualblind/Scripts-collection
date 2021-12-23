' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: RandPass.vbs 
' 
' 	Comments:
'	Usage:  cscript //nologo RandPass.vbs [password_length]|[?] [complexity] [uniqueness]

'	This script will generate a random password of X length.  It will build the password from 
'	seed 'strings of increasing complexity.
' 	1 - simple is the lower case alphabet, numbers 2-9 and !@#$%^&*() all randomly interspersed.
' 	2 - complex is the same as the previous with the addition of UPPER case letters.
' 	3 - insane is the same as the previous with the additional symbols of ,./?>;'[]}{\|~`:
'	The numbers 0 and 1 have been removed to avoid confusion with the letters O and L.
'	password_length should be a number between 4 and 127, although a limit of 14 is recommended for 
'	Win9x clients.  Default is 7
'	Complexity must be 1,2 or 3
'	Uniqueness value of 0 will make each password character unique.  A value of 1 [default] will allow repeated characters.
'	If you don't pass values at the command prompt, you will be prompted for each value.
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

On Error Resume Next
strDebug=1		'set to 0 to turn on Debugging statements
If strDebug=0 Then
wscript.echo "Debugging is ON"
End If

'Define the password seed strings
strSimple="ab*c@def!gh2ij3kl4m#n5op$6qr7st8u%v9w^x&y(z)"
strComplex="abc8defGHIJghijkl3mnoLMNpqr2st^&)uvwxyz9ABCDE4F7KO6PQRS*(TUVWXYZ!@#5$%_+-="
strInsane="abcd_+e-=fghi2jklmQR9Sn5opMNqrs3tuvIJw4x*(;yzABCD),>EFGH7K@#$%^L8OPTUVW./?XYZ!&'[]}{\|~`:"

If wscript.arguments.count >0 then
  if InStr(1,Wscript.arguments(0),"?",vbTextCompare)<>"0" then
	ShowHelp(1)
     	wscript.quit
  end if
End If

strTitle="Random Password Generator"

If Wscript.arguments.count < 1 Then
  strLength=InputBox("How long do you want the password to be?",strTitle,"7")
	If strLength="" then
 	Wscript.echo "No value entered or job cancelled."
 	wscript.quit
	End If
Else
  strLength=wscript.arguments(0)
End If

If Wscript.arguments.count < 2 Then
  strSeed=InputBox("How complex do you want it to be?" & VBCRLF & "1 - simple" & VBCRLF & "2 - complex" & VBCRLF & "3 - insane" & VBCRLF & "4 - Help",strTitle,1)
Select Case strSeed
  Case 1
    strSeed=strSimple
  Case 2
    strSeed=strComplex
  Case 3
    strSeed=strInsane
   Case 4
    ShowHelp(0) 
     wscript.quit
  Case Else
   Wscript.echo "Invalid selection.  Please try again."
   Wscript.quit
End Select

Else

strSeed=Wscript.Arguments(1)
Select Case strSeed
  Case 1
    strSeed=strSimple
  Case 2
    strSeed=strComplex
  Case 3
    strSeed=strInsane
   Case 4
    ShowHelp(0) 
     wscript.quit
  Case Else
   Wscript.echo "Invalid selection.  Please try again."
   Wscript.quit
End Select

End If

If Wscript.Arguments.Count < 3 Then
  askUnique=InputBox("Do you want all unique characters?  Enter 0 for Yes and 1 for No",strTitle,"1")

Select Case askUnique
 Case 1
 strUnique=1
 Case 0
 strUnique=0
 Case Else
 wscript.echo "Invalid response or operation cancelled"
 wscript.quit
End Select

Else

askUnique=Wscript.Arguments(2)
Select Case askUnique
 Case 1
 strUnique=1
 Case 0
 strUnique=0
 Case Else
 wscript.echo "Invalid response or operation cancelled"
 wscript.quit
End Select

End If

If strDebug=0 then
 wscript.echo "strUnique is set to " & strUnique
End If

Wscript.Echo "Password is " & strPass(strLength,strSeed,strUnique,strDebug)

wscript.quit

'\\\\\\\\\\\\\\\\\\\\\\
Function GenIt(MFactor)
Randomize
GenIt=INT(RND()*MFactor)+1
end Function
'\\\\\\\\\\\\\\\\\\\\\\

'\\\\\\\\\\\\\\\\\\\\\\
Function StrPass(strLength,strSeed,strUnique,strDebug)
'strLength is how long a password to generate
'strSeed is the source string to characters to build the password from
strPass=""

If strDebug=0 then
  wscript.echo "Building a " & strLength & " character password from:" & VBCRLF & strSeed & VBCRLF
End If

MFactor=Len(strSeed)

For x=1 to strLength
 strNum=GenIt(MFactor)
 strNext=Mid(strSeed,strNum,1)
	If strUnique=0 then
		If strDebug=0 then
		wscript.echo "Checking if " & strNext & " has already been used"
		End If
 	strPass=strPass & ChkNext(strNext,strPass,strSeed,strDebug)
	 Else
 	strPass=strPass&strNext
	End If
Next

End Function
'\\\\\\\\\\\\\\\\\\\\\\

'\\\\\\\\\\\\\\\\\\\\\\
Function ChkNext(strNext,strPass,strSeed,strDebug)
strTmp=strNext
MFactor=Len(strSeed)
	
If InStr(1,strPass,strNext,1) <>0 Then
	If strDebug=0 then
 	wscript.echo "Duplicate character"
	End If
 strNum=GenIt(MFactor)
	If strDebug=0 then
	wscript.echo "New number is " & strNum
	End If
 strNext=Mid(strSeed,strNum,1)
	If strDebug=0 then
 	wscript.echo "New character to check is " & strNext
	End If
 strTmp=ChkNext(strNext,strPass,strSeed,strDebug)
End if
	If strDebug=0 then
	wscript.echo "At end of function strTmp="&strTmp
	End If
ChkNext=strTmp
	If strDebug=0 then
	wscript.echo "ending ChkNext function"
	End If

End Function
'\\\\\\\\\\\\\\\\\\\\\\

'\\\\\\\\\\\\\\\\\\\\\\
Sub ShowHelp(Detail)

msg=VBCRLF & "RANDPASS.VBS HELP --" & VBCRLF & " This script will generate a random password of X length.  It will build the password from seed strings of increasing complexity." & VBCRLF & "1 - simple:" & VBCRLF & "    " & strSimple & VBCRLF & "2 - complex:" & VBCRLF & "    " & strComplex & VBCRLF & "3 - insane:" & VBCRLF & "    " & strInsane & VBCRLF & VBCRLF & "The numbers 0 and 1 have been removed to avoid confusion with the letters O and L." & VBCRLF

If Detail=0 then
wscript.echo msg
 else
 msg=msg & VBCRLF & " Password_length should be a number between 4 and 127, although a limit of 14 is " & VBCRLF & "recommended for Win9x clients.  Default is 7." & VBCRLF & " Complexity must be 1,2 or 3." & VBCLRF & " A uniqueness value of 0 will make each password character" & VBCRLF & "unique.  A value of 1 [default] will allow repeated characters." & VBCRLF & " If you don't pass values at the command prompt, you will be prompted for each value." & VBCRLF & VBCRLF & "Usage:  cscript //nologo RandPass.vbs [password_length]|[?] [complexity] [uniqueness]" & VBCRLF & "cscript randpass.vbs ? will display this help message." & VBCRLF
 wscript.echo msg
end if

wscript.quit

End Sub

'EOF7