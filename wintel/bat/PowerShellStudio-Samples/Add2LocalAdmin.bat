REM **************************************************************************
REM 
REM 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
REM   This file is part of the PrimalScript 2011 Code Samples.
REM 
REM 	File: Add2LocalAdmin.bat 
REM 
REM 	Comments:
REM 	SYNTAX: Add2LocalAdmin groupname|useraccount
REM  	DESC:  Add specified group or user to local administrators group.
REM  	If groupnames have spaces,be sure to enclose group in " "
REM 	For example: add2localAdmin "MYDOMAIN\Tech Support"
REM 	NOTES: You can use this as a computer startup script to add specified domain groups
REM 	or users to the local Administrators group.  
REM 	You could modify to add groups to Power Users group
REM 	instead.  
REM 	A hidden audit log is written to C:\
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

if %1$==$ GOTO :NOPARAM

set _audit=c:\~grpaudit.log

::specify group(s) to be added.  
set _ADDME=%1

date /t >>%_audit% & time /t >>%_audit%

net localgroup administrators |find /i "%_ADDME%" >NUL

if %errorlevel%==1 GOTO :NOTFOUND
if %errorlevel%==0 GOTO :FOUND
GOTO :OUT

:FOUND
REM echo Found %_ADDME%
GOTO :OUT

:NOTFOUND
REM echo %_ADDME% Not Found
echo Adding %_ADDME% to local administrators group >>%_audit%
NET LOCALGROUP ADMINISTRATORS %_ADDME% /Add >>%_audit%
NET LOCALGROUP ADMINISTRATORS >>%_audit%
echo ************************************************************* >>%_audit%
Attrib +H %_audit%
GOTO :OUT

:NOPARAM
echo.
echo Missing parameter!
echo USAGE: Add2LocalAdmin group|user
echo Examples:  
echo  add2localadmin company\IT
echo  add2localadmin domain\juser
echo.
echo If group names have spaces,be sure to enclose group in " "
echo For example: 
echo  add2localAdmin "MYDOMAIN\Tech Support"
echo.
GOTO :OUT

:OUT
set _audit=
set _ADDME=

::EOF