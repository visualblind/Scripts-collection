'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  MonitorIPChange.vbs
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
On Error Resume Next

Dim objShl
Dim objFso
Dim strAdapter
Dim strOutPutFile
Dim strIPt1
Dim strIPt2
Dim intInterval
Dim blnStartup
Dim objTemplateFile
Dim strTemplateFile
Dim strTemplateContents
Dim objNetConfigFile
Dim strNetConfigFile
Dim strNetConfigFile_a
Dim strNetConfigContents
Dim strNetConfigFile_del
Dim strNetConfigFile_del_a

Set objShl=CreateObject("WScript.Shell")
Set objFso=CreateObject("Scripting.FileSystemObject")

'Set the adapter name here.  Best way to find this out is to
'manually check IPCONFIG and see which adapter has the IP
'you're interested in monitoring.  Or you can search through
'HKLM\System\CurrentControlSet\Services to find the entry
'with a subkey called Parameters\Tcpip\DhcpIPAddress=<YourCurrentLeasedIP>
'strAdapter will then be the name of the key one level below Services.
'This name could be a meaningful one (more likely on NT4 than Windows 2000) or
'could be a GUID.'
strAdapter="{61111D98-C890-4CF0-8D9E-39DB547CC1E9}"

'Set the output file into which a new IP address will be written.
strOutPutFile="C:\Temp\ip"

'Set the interval level here in seconds.  This controls how often the
'check is made for a new IP address.
intInterval=300			'Change this value if desired.
intInterval=intInterval*1000	'Don't change this value.  This converts to milliseconds.

'This indicates the script is just starting up.
'We always want the trigger to fire upon startup
'to make sure we know about the latest IP address we have.
blnStartup=True


'This loop will run forever (i.e., until the script is manually stopped).
Do While 1<2
	'Err.Number=0

	strIPt1=objShl.RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & strAdapter & "\Parameters\Tcpip\DhcpIPAddress")
	ChkErrorStatus
	If blnStartup=True Then
		'Have to define strIPt2 here so the triggered sub-routine works correctly.
		'When the script is just starting up, the IP has only been checked
		'once so there is no second value yet.
		strIPt2=strIPt1
		Trigger
	End If

	WScript.Sleep intInterval

strIPt2=objShl.RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & strAdapter & "\Parameters\Tcpip\DhcpIPAddress")
	ChkErrorStatus

	If strIPt1<>strIPt2 Then
		Trigger
		'Reset strIPt1 so the script can continue to detect future changes.
		strIPt1=strIPt2
	End If

	'Reset the startup flag to false.
	blnStartup=False
Loop



'+++++++++++++++++++++++++++Sub routines+++++++++++++++++++++++++++++++++++++

'This checks whether an error occurs during
'the reading of the IP address.  An error likely
'indicates the connection has been dropped or is not present.
Sub ChkErrorStatus()
	If Err.Number<>0 OR strIPt1="0.0.0.0" Then
		'If no IP was found, this script will be restarted after attempting
		'to get one so it can always have a good IP as a starting value.
		NoIP
		objShl.Run "cmd /c start wscript.exe " & chr(34) & WScript.ScriptFullName & chr(34),1,False
		WScript.Quit
	End If
End Sub


'This sub-routine gets called if there is no IP address at all found on
'the specfied adapter.  It's assumed a network connection
'must be made.  The action taken here might be different
'for different kinds of connections.  E.g., dialup connections
'may need to issue a rasdial or rasphone command.  Cable modems,
'being regular ethernet clients, may just need to renew their lease.
'This is really just a precaution and shouldn't happen too frequently.
Sub NoIP()
	objShl.Run "ipconfig /release " & strAdapter,1,True
	objShl.Run "ipconfig /renew " & strAdapter,1,True
End Sub


'Modify this Sub-routine to include actions you want to perform
'when the IP address changes.
Sub Trigger()
	'Echo the new IP to a text file.
	objShl.Run "cmd /c echo " & strIPt2 & ">" & strOutPutFile,0,True

	If not blnStartup=True AND strIPt2<>"0.0.0.0" Then
		'This section contains some commands you want to issue when
		'your IP address changes.  This If-then block specifically
		'addresses what happens when the script has been running for a
		'while and detects a change -- i.e., the script is NOT just
		'starting up and the IP address is NOT all zeroes.

		'For example, if you're running Routing and Remote Access, you may
		'need to update your INPUT/OUTPUT filters to accomodate the new IP.  But you
		'only want to do this when your "new" IP is not all zeroes.
		'For this, you can create some template files of your RRAS config using netsh.exe.
		'Then just modify the template, output to new file, and use netsh to reimport
		'the settings.

		'At the end of this If-then block are more generic actions always to be taken.

		'''Update the RRAS config.  EXAMPLE ONLY.
		strNetConfigFile="C:\Tools\Scripts\netcfg.txt"
		strNetConfigFile_a="C:\Tools\Scripts\netcfg_a.txt"
		strNetConfigFile_del="C:\Tools\Scripts\netcfg_del.txt"
		strNetConfigFile_del_a="C:\Tools\Scripts\netcfg_del_a.txt"

		'Read in the template files, replace the old IP with the new,
		'Then reimport the settings.

		'Add new filters with the new IP.
		Set objNetConfigFile=objFso.OpenTextFile(strNetConfigFile,1,False)
		strNetConfigContents=objNetConfigFile.ReadAll
		objNetConfigFile.Close

		strNetConfigContents=Replace(strNetConfigContents,"dstaddr=0.0.0.0","dstaddr=" & strIPt2)
		Set objNetConfigFile=objFso.OpenTextFile(strNetConfigFile_a,2,True)
		objNetConfigFile.WriteLine strNetConfigContents
		objNetConfigFile.Close

		'Delete old filters with the old IP.
		Set objNetConfigFile=objFso.OpenTextFile(strnetConfigFile_del,1,False)
		strNetConfigContents=objNetConfigFile.ReadAll

		strNetConfigContents=Replace(strNetConfigContents,"dstaddr=0.0.0.0","dstaddr=" & strIPt1)
		objNetConfigFile.Close
		Set objNetConfigFile=objFso.OpenTextFile(strnetConfigFile_del_a,2,True)
		objNetConfigFile.WriteLine strNetConfigContents
		objNetConfigFile.Close

		'Import the new settings using netsh.  You can change the 1's to O's if
		'you don't want to see the shell opening for each command.
		objShl.Run "cmd /c net stop RemoteAccess",1,True
		objShl.Run "cmd /c netsh -f " & strNetConfigFile_a,1,True
		objShl.Run "cmd /c netsh -f " & strNetConfigFile_del_a,1,True
		objShl.Run "cmd /c net start RemoteAccess",1,True

		'Delete the newly written config files after they're imported.
		'You'll always rely on the templates only.
		objFso.DeleteFile strNetConfigFile_a,True
		objFso.DeleteFile strNetConfigFile_del_a,True
	End If


	'These steps are always taken when an IP change occurs.

	'Updates an HTML file, which is kept on a free public site, that is used for redirection
	'of HTTP clients to your leased IP.
	'This template could be a text file that looks something like this:
	'	<html>
	'	<head>
	'	<META HTTP-EQUIV="refresh" content="1;url=http://$address$">
	'	</head>
	'	</html>

	strTemplateFile="C:\Tools\Scripts\home"
	Set objTemplateFile=objFso.OpenTextFile(strTemplateFile,1,False)
	strTemplateContents=objTemplateFile.ReadAll
	strTemplateContents=Replace(strTemplateContents,"$address$",strIPt2)
	objTemplateFile.Close
	Set objTemplateFile=objFso.OpenTextFile("C:\Temp\home",2,True)
	objTemplateFile.WriteLine strTemplateContents
	objTemplateFile.Close
	Set objTemplateFile=Nothing

	'This issues a batch file to be carried out.  It may contain commands, e.g.,
	'to FTP a file with your updated IP to a public site that is always accessible.
	'This way, if your IP changes without your knowledge and you want to access your IP
	'from the Internet, you go to the public site to find out your IP.
	'This script might look like this:
	'	cmd /c ftp -n -s:C:\Tools\Scripts\ftp.txt
	'Ftp.txt contains a list of commands for FTP to execute.  These would depend on the exact
	'steps you'd need to carry out in order to FTP your file -- e.g.,
	'	open <site>
	'	user <username>
	'	<password>
	'	put C:\temp\ip ip
	'	put C:\temp\home home
	'	bye
	objShl.Run "C:\Tools\Scripts\FTPup.cmd",1,True
End Sub
