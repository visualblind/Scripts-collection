@echo off
rem
rem ****************************************************************************
rem
rem    Copyright (c) Microsoft Corporation. All rights reserved.
rem    This code is licensed under the Microsoft Public License.
rem    THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
rem    ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
rem    IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
rem    PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
rem
rem ****************************************************************************
rem
rem CMD script to add a user to the SQL Server sysadmin role
rem
rem Input:  %1 specifies the instance name to be modified. Defaults to SQLEXPRESS.
rem         %2 specifies the principal identity to be added (in the form "<domain>\<user>").
rem            If omitted, the script will request elevation and add the current user (pre-elevation) to the sysadmin role.
rem            If provided explicitly, the script is assumed to be running elevated already.
rem
rem Method: 1) restart the SQL service with the '-m' option, which allows a single connection from a box admin
rem            (the box admin is temporarily added to the sysadmin role with this start option)
rem         2) connect to the SQL instance and add the user to the sysadmin role
rem         3) restart the SQL service for normal connections
rem
rem Output: Messages indicating success/failure.
rem         Note that if elevation is done by this script, a new command process window is created: the output of this
rem         window is not directly accessible to the caller.
rem
rem
setlocal
set sqlresult=N/A
if .%1 == . (set /P sqlinstance=Enter SQL instance name, or default to SQLEXPRESS: ) else (set sqlinstance=%1)
if .%sqlinstance% == . (set sqlinstance=SQLEXPRESS)
if /I %sqlinstance% == MSSQLSERVER (set sqlservice=MSSQLSERVER) else (set sqlservice=MSSQL$%sqlinstance%)
if .%2 == . (set sqllogin="%USERDOMAIN%\%USERNAME%") else (set sqllogin=%2)
rem remove enclosing quotes
for %%i in (%sqllogin%) do set sqllogin=%%~i
@echo Adding '%sqllogin%' to the 'sysadmin' role on SQL Server instance '%sqlinstance%'.
@echo Verify the '%sqlservice%' service exists ...
set srvstate=0
for /F "usebackq tokens=1,3" %%i in (`sc query %sqlservice%`) do if .%%i == .STATE set srvstate=%%j
if .%srvstate% == .0 goto existerror
rem
rem elevate if <domain/user> was defaulted
rem
if NOT .%2 == . goto continue
echo new ActiveXObject("Shell.Application").ShellExecute("cmd.exe", "/D /Q /C pushd \""+WScript.Arguments(0)+"\" & \""+WScript.Arguments(1)+"\" %sqlinstance% \""+WScript.Arguments(2)+"\"", "", "runas"); >"%TEMP%\addsysadmin{7FC2CAE2-2E9E-47a0-ADE5-C43582022EA8}.js"
call "%TEMP%\addsysadmin{7FC2CAE2-2E9E-47a0-ADE5-C43582022EA8}.js" "%cd%" %0 "%sqllogin%"
del "%TEMP%\addsysadmin{7FC2CAE2-2E9E-47a0-ADE5-C43582022EA8}.js"
goto :EOF
:continue
rem
rem determine if the SQL service is running
rem
set srvstarted=0
set srvstate=0
for /F "usebackq tokens=1,3" %%i in (`sc query %sqlservice%`) do if .%%i == .STATE set srvstate=%%j
if .%srvstate% == .0 goto queryerror
rem
rem if required, stop the SQL service
rem
if .%srvstate% == .1 goto startm
set srvstarted=1
@echo Stop the '%sqlservice%' service ...
net stop %sqlservice%
if errorlevel 1 goto stoperror
:startm
rem
rem start the SQL service with the '-m' option (single admin connection) and wait until its STATE is '4' (STARTED)
rem also use trace flags as follows:
rem     3659 - log all errors to errorlog
rem     4010 - enable shared memory only (lpc:)
rem     4022 - do not start autoprocs
rem
@echo Start the '%sqlservice%' service in maintenance mode ...
sc start %sqlservice% -m -T3659 -T4010 -T4022 >nul
if errorlevel 1 goto startmerror
:checkstate1
set srvstate=0
for /F "usebackq tokens=1,3" %%i in (`sc query %sqlservice%`) do if .%%i == .STATE set srvstate=%%j
if .%srvstate% == .0 goto queryerror
if .%srvstate% == .1 goto startmerror
if NOT .%srvstate% == .4 goto checkstate1
rem
rem add the specified user to the sysadmin role
rem access tempdb to avoid a misleading shutdown error
rem
@echo Add '%sqllogin%' to the 'sysadmin' role ...
for /F "usebackq tokens=1,3" %%i in (`sqlcmd -S np:\\.\pipe\SQLLocal\%sqlinstance% -E -Q "create table #foo (bar int); declare @rc int; execute @rc = sp_addsrvrolemember '$(sqllogin)', 'sysadmin'; print 'RETURN_CODE : '+CAST(@rc as char)"`) do if .%%i == .RETURN_CODE set sqlresult=%%j
rem
rem stop the SQL service
rem
@echo Stop the '%sqlservice%' service ...
net stop %sqlservice%
if errorlevel 1 goto stoperror
if .%srvstarted% == .0 goto exit
rem
rem start the SQL service for normal connections
rem
net start %sqlservice%
if errorlevel 1 goto starterror
goto exit
rem
rem handle unexpected errors
rem
:existerror
sc query %sqlservice%
@echo '%sqlservice%' service is invalid
goto exit
:queryerror
@echo 'sc query %sqlservice%' failed
goto exit
:stoperror
@echo 'net stop %sqlservice%' failed
goto exit
:startmerror
@echo 'sc start %sqlservice% -m' failed
goto exit
:starterror
@echo 'net start %sqlservice%' failed
goto exit
:exit
if .%sqlresult% == .0 (@echo '%sqllogin%' was successfully added to the 'sysadmin' role.) else (@echo '%sqllogin%' was NOT added to the 'sysadmin' role: SQL return code is %sqlresult%.)
endlocal
pause

