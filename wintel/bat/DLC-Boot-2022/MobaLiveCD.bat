@echo off
Title Run Moba Live CD - DLC Corporation
pushd "%~dp0"
for /f "Tokens=*" %%a in ('net localgroup Administrators^|find /i "%username%"') do goto Start
start msgbox "You are not running with Admin account! Please log into the Admin account, and try again!" 0 "User Errors"
exit

:Start
if not exist "%PUBLIC%" (
goto WinXP
)

:Windows78
Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry%  | Find /i "x86" 
if %ERRORLEVEL% == 0 (
    goto 32Bit
) else (
    goto 64Bit
)

:32Bit
set dd=%~dp0
RunAdmin32 "%dd%MobaLiveCD.exe"
exit

:64Bit
set dd=%~dp0
RunAdmin64 "%dd%MobaLiveCD.exe"
exit

:WinXP
start "" /D"\" "MobaLiveCD.exe"
exit