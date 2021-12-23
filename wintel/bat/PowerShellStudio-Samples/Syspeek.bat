REM **************************************************************************
REM 
REM 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
REM   This file is part of the PrimalScript 2011 Code Samples.
REM 
REM 	File: SysPeek.bat 
REM 
REM 	Comments:
REM		USAGE- syspeek [computer]
REM    DESC- Build HTML page of system resource usage for specified computer.  
REM    Default html filename is computernameInfo.htm and it is created in the same
REM    directory you run the script from.  
REM    If you don't specify a computer, script will default to local host.  
REM    Information gathered:
REM    	pagefile
REM    	memory
REM    	logical drives
REM    	services
REM    	processes
REM    IMPORTANT NOTES- This script uses a command line version of WMI that is only available
REM    on Windows XP and 2003 platforms.  Before you can run the script you must install WMIC.
REM    Open a command prompt and type 'WMIC' which will start the installation.  When it is
REM    finished you will have an interactive prompt (wmic:root\cli>). Type 'exit'.  You can now
REM    run this script.  The computer you are querying doesn't need WMIC but it must be WMI-enabled.
REM    You must have appropriate credentials on the target computer.  You can specify alternate
REM    credentials, but you will need to use the /USER and /PASSWORD global switches.  Run
REM    wmic /? at a command prompt to see help screens.
REM    For more information, read the excellent article in the March 2002 issue of Windows & .NET
REM    Magazine by Ethan Wilansky (InstantDoc 23854).
REM    You can build your own format files (.xsl) if you understand XML.  The files are
REM    found in %systemroot%\system32\wbem.  I've used one of the default files for demonstration.
REM 
REM   Disclaimer: This source code is intended only as a supplement to 
REM 				SAPIEN Development Tools and/or on-line documentation.  
REM 				See these other materials for detailed information 
REM 				regarding SAPIEN code samples.
REM 
REM 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
REM 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
REM 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
REM 	PARTICULAR PURPOSE.
REM 
REM **************************************************************************
@echo off

:Top
::script version used in output
set zver=v1.9

 if "%1"=="" goto :Local
 set zSrv=%1
 goto :Main

:Local
 set zSrv=%computername%

:Main
 echo Getting system resource information for "%zSrv%"

::Define file for html output
 set zOutput=%zSrv%-Info.htm

::delete file if it already exists
 if exist %zOutput% del %zOutPut% >NUL
::delete error log if it previously exists
 if exist %zSrv%-Error.log del %zSrv%-Error.log >NUL

::build a shell html file.  Not required but I wanted to try.
 echo ^<html^> >> %zOutput%
 echo ^<body^> >> %zOutput%
 echo ^<H3^>^<Font Face=Verdana Color=Blue^>^<P align=Center^>%zSrv%^<BR^> >>%zOutput%
 echo System Resources Information^</Font^>^</H3^>^</P^> >>%zOutput%
 echo ^<HR^> >>%zOutput%
 echo ^</html^> >> %zOutput%
 echo ^</body^> >> %zOutput%

::verify connectivity and WMI compatibility
wmic /node:"%zSrv%" os list brief 1>NUL 2>> %zSrv%-Error.log
if errorlevel=0 goto :Gather
echo ^<Font Color=Red^>^<B^> OOPS!! ^</P^>>> %zOutPut%
echo Can't verify connectivity to or WMI compatibility with "%zSrv%" ^</P^> >> %zOutPut%
for /f "tokens=*" %%i in (%zSrv%-Error.log) do @echo %%i ^<br^> >>%zoutPut%
echo ^</Font^>^</B^> ^</P^> >> %zOutPUt%
goto :Cleanup

:Gather
::start gathering information.  WMIC command must be on one line.
 echo   memory...
 echo ^<Font Color=Green^>^<H3^>^<B^>^<I^>Memory^</Font^>^</H3^>^</B^>^</I^> >> %zOutPut%
 wmic /node:"%zSrv%" /append:"%zOutPut%" memlogical get AvailableVirtualMemory, TotalVirtualMemory, TotalPhysicalMemory, TotalPageFileSpace /format:htable.xsl >NUL

 echo   pagefile...
 echo ^<Font Color=Green^>^<H3^>^<B^>^<I^>PageFile^</Font^>^</H3^>^</B^>^</I^> >> %zOutPut%
 wmic /node:"%zSrv%" /append:"%zOutPut%" pagefileset get name, initialsize, maximumsize /format:htable.xsl >NUL
 wmic /node:"%zSrv%" /append:"%zOutPut%" pagefile get Caption, CurrentUsage, PeakUsage, InstallDate /format:htable.xsl >NUL

 echo   logical drives...
 echo ^<Font Color=Green^>^<H3^>^<B^>^<I^>Drive Information^</Font^>^</H3^>^</B^>^</I^> >> %zOutPut%
 wmic /node:"%zSrv%" /append:"%zOutPut%" logicaldisk where drivetype=3 get name, size, freespace, compressed, filesystem /format:htable.xsl >NUL

 echo   process...
 echo ^<Font Color=Green^>^<H3^>^<B^>^<I^>Processes^</Font^>^</H3^>^</B^>^</I^> >> %zOutPut%
 wmic /node:"%zSrv%" /append:"%zOutPut%" process list brief /format:htable.xsl >NUL

 echo   service...
 echo ^<Font Color=Green^>^<H3^>^<B^>^<I^>Services^</Font^>^</H3^>^</B^>^</I^> >> %zOutPut%
 wmic /node:"%zSrv%" /append:"%zOutPut%" service where state="Running" get pathname, state, startmode, displayname, processid /format:htable.xsl >NUL

:Cleanup
 echo ^<I^>^<Font Size=-1^>^<BR^>%zver% >>%zOutput%
 date /t >>%zOutput%
 time /t >>%zOutput%
 echo - %username% ^</I^>>>%zOutput%

 echo Open %zOutPut% to view results

 if exist %zSrv%-Error.log del %zSrv%-Error.log >NUL
 
 set zSrv=
 set zOutput=
 set zVer=

::EOF