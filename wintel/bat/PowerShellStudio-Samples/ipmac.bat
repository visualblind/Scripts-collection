REM **************************************************************************
REM 
REM 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
REM   This file is part of the PrimalScript 2011 Code Samples.
REM 
REM 	File: IPMAC.BAT 
REM 
REM 	Comments: Build a comma delimited file of computername,user,IPAddress,MAC address.
REM 	Usage - ipmac [computername]
REM   To build a list, execute this command at a prompt -
REM     for /f %i in (computerlist.txt) do @ipmac %i 1>>ipmac.csv 2>>errors.txt
REM
REM   Your comma delimited file will be saved to ipmac.csv and any errors will be captured
REM   in errors.txt.  You may need to parse out the "Can't Verify" errors with the command -
REM     find /v /i "can't verify" ipmac.csv|find /v "---" >ipmacrev.csv
REM
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

::OSCHECK
if not "%OS%"=="Windows_NT" GOTO NOTNT

::SYNCHECK
if %1$==$ GOTO NOPARAM
if /i {%1}=={/?} GOTO HELP

:MAIN
set tmp1=%TEMP%\$iptmp1.tmp
set tmp2=%TEMP%\$iptmp2.tmp
set mactmp=
set mac=
set usrtmp=

if exist %tmp1% del %tmp1% >NUL
if exist %tmp2% del %tmp2% >NUL

for /f "delims== tokens=2" %%i in ('nbtstat -a %1^|find "MAC Address"') do @set mactmp=%%i
for %%i in (%mactmp%) do @set mac=%%i

for /f %%i in ('nbtstat -a %1^|find "<03>"^|find /i /v "%1"') do @set usrtmp=%%i

for /f "tokens=3" %%i in ('ping -n 1 %1^|find "Pinging"') do @echo %%i >%tmp1%

REM if ping failed we don't want to continue
if NOT exist %tmp1% GOTO ERR  

for /f "delims=[" %%i in (%tmp1%) do @echo %%i >%tmp2%

for /f "delims=]" %%i in (%tmp2%) do @echo %1,%usrtmp%,%%i,%mac%

if exist %tmp1% del %tmp1% >NUL
if exist %tmp2% del %tmp2% >NUL

set tmp1=
set tmp2=
set mactmp=
set mac=
set usrtmp=

GOTO OUT

:ERR
ECHO Can't verify %1
GOTO OUT

:NOTNT
ECHO.
ECHO %0
ECHO This program requires Windows NT or Windows 2000
GOTO OUT

:NOPARAM
ECHO.
Echo Missing Parameter

:HELP
echo.
echo   IPMAC.BAT
echo   usage: ipmac [computername]
echo   example:  ipmac flintsone
echo.
echo   Do NOT use \\ before the computername.
echo   ipmac /? will display this help message
echo.

:OUT

