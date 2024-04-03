@echo off
SETLOCAL enableDelayedExpansion

for /f "tokens=2*" %%a in ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\OEM\User Experience Improvement Program\Version" /v Framework') do set "version=%%~b"

rem echo %version%
if %errorlevel% EQU 0 (
if !version! == 1.00.3002 exit /b 0
if !version! == 1.00.8100 exit /b 0
if !version! == 1.02.3004 exit /b 0
if !version! == 1.02.3005 exit /b 0
if !version! == 1.02.3006 exit /b 0
if !version! == 1.02.3009 exit /b 0
if !version! == 2.00.3002 exit /b 0
if !version! == 2.01.3002 exit /b 0
if !version! == 2.02.3000 exit /b 0
)
exit /b 1