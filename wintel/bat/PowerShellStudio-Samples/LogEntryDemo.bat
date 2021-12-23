REM **************************************************************************
REM 
REM 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
REM   This file is part of the PrimalScript 2011 Code Samples.
REM 
REM 	File: LogEntryDemo.bat 
REM 
REM 	Comments:
REM 
REM 	This script doesn't really do much other than demonstrate
REM 	how to use the LogEntry routine to create a 
REM 	log file with a timestamped entry for each line.
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

REM define path to log file
set myLog=e:\temp\log.txt

REM Delete the logfile if it already exists.
if exist %myLog% del %myLog% >NUL

Echo Working...
REM When sending something to the log routine, enclose the
REM message in quotes.
Call :LogEntry "Starting %0"
Call :LogEntry "Running DIR"
DIR %windir%\*.* /s >NUL
Call :LogEntry "Finished DIR"
Call :LogEntry "Sleeping for 30 seconds"
Sleep 30
Call :logEntry "Getting NETSTAT information"
REM Sending results of a NETSTAT command to the log. Notice
REM I'm enclosing the output in quotes. Otherwise, only the
REM first part of the output would be recorded.
for /f "tokens=*" %%t in ('netstat ^|find /i "TCP"') do @Call :LogEntry "%%t"
Call :LogEntry "Finishing logging and opening %myLog%"
REM Display the log
start Notepad %MyLog%
GOTO :EOF

:LogEntry
REM Output will be like: Wed 11/15/2006 05:27 PM "Starting LogEntryDemo.bat" 
for /f "tokens=*" %%i in ('echo %date%') do @for /f "tokens=*" %%j in ('echo %time:~0,8%') do @echo %%i%%j %1 >>%myLog%
GOTO :EOF

:EOF