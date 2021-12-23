'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  AddPrinters.vbs
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


' *******************************************************************
' ************** Section 1           ********************************
' ************** Begin Message Boxes ********************************
' *******************************************************************

' ***** The first two lines are the Welcome box text and title.

	L_Welcome_Message_Text = "With this Script, you can install all Network Printers at once, or one at a time. Do you wish to continue?"
	L_Welcome_Title_Text = "Welcome to the Printer Installation Script"

' ***** The next two lines setup text for the All_Printers install.

	L_AllPrinters_Message_Text = "Would you like to install ALL Network Printers at once?"
	L_AllPrinters_Title_Text = "Install ALL Printers?"

' ***** The next lines are text and title for each Printer.
' ***** Change these to reflect friendly names for your printers.
' ***** Copy this format for all your printers, changing the letter in "L_PrinterXXX_" for each.

	L_PrinterA_Message_Text = "Would you like to install Printer A?"
	L_PrinterA_Title_Text = "Printer A..."

	L_PrinterB_Message_Text = "Would you like to install Printer B?"
	L_PrinterB_Title_Text = "Printer B..."

' ***** This is the End Dialog.

	L_End_Message_Text = "Printer Installations Complete."
	L_End_Title_Text = "Printer Installation:  Finished"

' ***** This will start the actual routine.
	Call Welcome()

' *******************************************************************
' ************** Section 2           ********************************
' ************** Begin Welcome Sub   ********************************
' *******************************************************************

Sub Welcome()
	Dim intDolt

	intDolt	= MsgBox(L_Welcome_Message_Text,	_
			vbYesNo + vbInformation,	_
			L_Welcome_Title_Text )

' ***** Click yes and continue installation
' ***** Click no and skip to the end dialog

	If intDolt = vbYes Then
		Call All()
	End If
	Call Done()
End Sub

' *******************************************************************
' ************** Section 3                ***************************
' ************** Install_All_Printers Sub ***************************
' *******************************************************************

Sub All()
	Dim intDolt

	intDolt = MsgBox(L_AllPrinters_Message_Text,	_
	                 vbYesNo + vbQuestion,		_
                         L_AllPrinters_Title_Text )

' ***** Click yes and install all printers
' ***** Click no and skip to first printer sub

	If intDolt = vbNo Then
		Call PrinterA()
	End If

' ***** Set up the object

		Set WshNetwork = CreateObject("WScript.Network")

' ***** All network printers should be listed here
' ***** Follow this pattern:

		PrinterPath = "\\PRINTSERVER\PRINTER_SHARE"
		WshNetwork.AddWindowsPrinterConnection PrinterPath

		PrinterPath = "\\PRINTSERVER\PRINTER_SHARE"
		WshNetwork.AddWindowsPrinterConnection PrinterPath

' ***** Skip to the end of the routine

		Call Done()
End Sub

' *******************************************************************
' ************** Section 4                ***************************
' ************** Install_each_Printer Sub ***************************
' *******************************************************************
' ***** PrinterA

' ***** Be sure to change the Sub title for each printer sub
Sub PrinterA()
	Dim intDolt

' ***** Be sure to change the Message reference in each printer sub

	intDolt = MsgBox(L_PrinterA_Message_Text,	_
	                 vbYesNo + vbQuestion,		_
                         L_PrinterA_Title_Text )

' ***** Click yes to install
' ***** Click no the skip to next

	If intDolt = vbNo Then

' ***** Be sure to change the Call statement for each printer sub
		Call PrinterB()

	End If
		Set WshNetwork = CreateObject("WScript.Network")
		PrinterPath = "\\PRINTSERVER\PRINTER_SHARE"
		WshNetwork.AddWindowsPrinterConnection PrinterPath
		Call PrinterB()
End Sub




' *******************************************************************
' ***** PrinterB

Sub PrinterB()
	Dim intDolt

	intDolt = MsgBox(L_PrinterB_Message_Text,	_
	                 vbYesNo + vbQuestion,		_
                         L_PrinterB_Title_Text )

' ***** Click yes to install
' ***** Click no to skip to end of routine

	If intDolt = vbNo Then
		Call Done()

	End If
		Set WshNetwork = CreateObject("WScript.Network")
		PrinterPath = "\\PRINTSERVER\PRINTER_SHARE"
		WshNetwork.AddWindowsPrinterConnection PrinterPath
		Call Done()
End Sub


' *******************************************************************
' ************** Section 5           ********************************
' ************** END Sub             ********************************
' *******************************************************************
Sub Done()
	Dim intDolt

	intDolt = MsgBox(L_END_Message_Text,		_
	                 vbOKOnly + vbInformation,	_
                         L_END_Title_Text )
	If intDolt = vbOK Then

' ***** End routine
		WScript.Quit
	End If
End Sub
' *******************************************************************
' ***** End routine
WScript.quit
