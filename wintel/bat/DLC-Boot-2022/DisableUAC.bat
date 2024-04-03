@echo off
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto NotRunMini
if exist %SystemRoot%\System32\CheckMini7 goto NotRunMini
if exist %SystemRoot%\System32\CheckMini8 goto NotRunMini

if not exist "%PUBLIC%" (
goto error
)

for /f "Tokens=*" %%a in ('net localgroup Administrators^|find /i "%username%"') do goto Start
start msgbox "You are not running with Admin account! Please log into the Admin account, and try again!" 0 "User Errors"
exit

:Start
Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry%  | Find /i "x86" 
if %ERRORLEVEL% == 0 (
    goto 32Bit
) else (
    goto 64Bit
)

:32Bit
set dd=%~dp0
RunAdmin32 "%dd%DisableUAC_Run.bat"
exit

:64Bit
set dd=%~dp0
RunAdmin64 "%dd%DisableUAC_Run.bat"
exit

:error
start msgbox "Your OS is not Windows Vista or Windows 7/8." 0 "OS Errors"
exit

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit