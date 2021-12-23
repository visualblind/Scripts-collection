REM **************************************************************************
REM 
REM 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
REM   This file is part of the PrimalScript 2011 Code Samples.
REM 
REM 	File: ReqQueryList.bat 
REM 
REM 	Comments:
REM 	This script will enumerate the specified list of computers and 
REM 	use REG.EXE (should be available on XP and later) to remotely
REM 	query the registry. The computer name and registry key value
REM 	will be displayed. 
REM 
REM 	If you want to save results run
REM 	RegQueryList.bat > results.txt
REM 
REM   	Disclaimer: This source code is intended only as a supplement to 
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

REM Enter the filename and path of the text list of computers to check
set serverlist=e:\temp\servers.txt

REM enter the registry path. Do not use quotes. Remote systems can query
REM either HKLM or HKU
set regPath=hklm\software\microsoft\windows NT\currentversion

REM Enter the registry key that you want the value of
set regKey=CSDVersion

if exist %serverlist% GOTO :MAIN
echo Failed to find %serverlist%
GOTO :OUT

:MAIN
for /f %%i in (%serverlist%) do @ CALL :QUERY %%i
GOTO :OUT

:QUERY
REM skip any blank lines
if %1==$ (
    GOTO :EOF
) else (
    set computer=%1
)
FOR /F "tokens=*" %%a in ('Reg Query "\\%computer%\%regpath%" /v %regkey% ^| find /i "%regkey%"') do @echo %computer%  %%a
GOTO :EOF

:OUT
set regPath=
set regKey=
set computer=
set serverlist=

:EOF
