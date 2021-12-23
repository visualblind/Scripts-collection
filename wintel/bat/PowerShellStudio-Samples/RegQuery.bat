REM **************************************************************************
REM 
REM 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
REM   This file is part of the PrimalScript 2011 Code Samples.
REM 
REM 	File: ReqQuery.bat 
REM 
REM 	Comments:
REM 	This script will the registry for the specified key. 
REM 	The computer name and registry key value will be displayed. 
REM 	You can specify a computername as a runtime parameter.
REM 	If you don't specify a name, the script will query 
REM 	the local machine.
REM 	If you want to save results run
REM 	RegQueryList.bat > results.txt

REM		USAGE 
REM		RegQuery.bat [computername]
REM		If you don't specify a remote computer, the local computer will
REM		be queried.
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

REM enter the registry path. do not use quotes. Remote systems can query
REM either HKLM or HKU
set regPath=hklm\software\microsoft\windows NT\currentversion

REM Enter the registry key that you want the value of
set regKey=CSDVersion

if %1$==$ (
    set computer=%computername%
) else (
    set computer=%1
)
echo Reg Query "\\%computer%\%regpath%" /v %regkey%
FOR /F "tokens=*" %%a in ('Reg Query "\\%computer%\%regpath%" /v %regkey% ^| find /i "%regkey%"') do @echo %computer%  %%a
GOTO :OUT

:OUT
set regPath=
set regKey=
set computer=

:EOF
