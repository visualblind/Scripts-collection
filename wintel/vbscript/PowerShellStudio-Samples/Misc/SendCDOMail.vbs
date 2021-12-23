' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: SendCDOMail.vbs 
' 
' 	Comments:
' 	This quick script lets you send an smtp message using CDO without having SMTP
'	installed locally. You need to configure the name of a properly configured internal
'	SMTP server. In the script. You could incorporate this into other scripts to generate
'	email notifications. Be sure to maintain the right number of quotes in the addressing
'	parameters.

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

Dim objMail,objConfig,objFields
Set objMail = CreateObject("CDO.Message")
Set objConfig = CreateObject("CDO.configuration")
Set objFields = objConfig.Fields
With objFields
.Item("http://schemas.microsoft.com/cdo/configuration/SendUsing")= 2
'set the next line to the SMTP server on the network
.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")= "mail01"
.Item("http://schemas.microsoft.com/cdo/configuration/SMTPServerPort")= 25
.Update
End With
With objMail
Set .Configuration = objConfig
.To = """Peter Pan"" <ppan@neverland.org>"
.CC = """Peter"" <peterpan@yahoo.com>"
.From = """TinkerBell"" <ppan890@hotmail.com>"
.Subject = "This is a test " & NOW
.TextBody = "This is a test message sent originally at " & Now & VbCrLf & "Have a nice day!"
.Send
End With

'EOF