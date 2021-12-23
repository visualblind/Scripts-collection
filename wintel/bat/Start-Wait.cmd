@ECHO OFF
 
:: NAME
::	Start-Wait.cmd
::
:: SYNOPSIS
::	Suspend script activity as long as the specified program and its sub
::	process are running
::
:: SYNTAX
::	Start-Wait program subprocess
::	Start-Wait "program arguments" subprocess
::
:: DETAILED DESCRIPTION
::	The Start-Wait.cmd batch file suspends script activity as long as the
::	specified program and its sub process are running. You can use it in a
::	batch script to wait for a setup program to complete completely.
::
:: AUTHOR
::	Frank-Peter Schultze
::
:: DATE
::	17:02 04.04.2008
 
SETLOCAL ENABLEDELAYEDEXPANSION
 
IF "%1"=="/?" (
	TYPE "%~f0" | findstr.exe /R "^:: "
	GOTO :END
)
 
SET Program=%~1
IF NOT DEFINED Program (
	ECHO %~n0 : Cannot bind argument to parameter 'Program' because it is empty.
	GOTO :END
)
 
SET SubProcess=%2
IF NOT DEFINED SubProcess (
	ECHO %~n0 : Cannot bind argument to parameter 'SubProcess' because it is empty.
	GOTO :END
)
 
SET IGNOREPIDS=
 
::-----	First, get all PIDs that we don't want to check later by mistake
FOR /F "tokens=2 skip=3" %%i IN (
	'tasklist.exe /FI "USERNAME eq %USERDOMAIN%\%USERNAME%" /FI "IMAGENAME eq %SubProcess%"'
) DO (
	SET IGNOREPIDS=!IGNOREPIDS! %%~i
)
 
::-----	Start the program and wait for its termination
START /WAIT %Program%
 
::-----	Now, get the PID of the sub process that we need to check
FOR /F "tokens=2 skip=3" %%i IN (
	'tasklist.exe /FI "USERNAME eq %USERDOMAIN%\%USERNAME%" /FI "IMAGENAME eq %SubProcess%"'
) DO (
	ECHO #%IGNOREPIDS%# | find.exe "%%~i" >NUL || CALL :TASKWAIT %SubProcess% %%~i
)
 
:END
ENDLOCAL
EXIT /B
 
::
:TASKWAIT
::
ECHO Sleep 5s . . .
ping.exe -n 6 -w 1000 127.0.0.1 >NUL
tasklist.exe /FI "USERNAME eq %USERDOMAIN%\%USERNAME%" /FI "IMAGENAME eq %1" /FI "PID eq %2" >NUL | find.exe "%1" >NUL && GOTO %0
ECHO %1 stopped.
EXIT /B