@echo off
Title ATI Menu for Windows Vista/7/8 on HDD - DLC Corporation
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto NotRunMini
if exist %SystemRoot%\System32\CheckMini7 goto NotRunMini
if exist %SystemRoot%\System32\CheckMini8 goto NotRunMini

for /f "Tokens=*" %%a in ('net localgroup Administrators^|find /i "%username%"') do goto Start
start msgbox "You are not running with Admin account! Please log into the Admin account, and try again!" 0 "User Errors"
exit

:Start
if not exist "%PUBLIC%" (
goto WinXP
)

:Windows78
if not exist "%HomeDrive%\ATIB\MenuRemove.bat" (
goto NotMenu
)

Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry%  | Find /i "x86" 
if %ERRORLEVEL% == 0 (
    goto 32Bit
) else (
    goto 64Bit
)

:32Bit
set dd=%~dp0
RunAdmin32 "%dd%ATI_Win_78_Boot_Menu_UnInstall_Run.bat"
exit

:64Bit
set dd=%~dp0
RunAdmin64 "%dd%ATI_Win_78_Boot_Menu_UnInstall_Run.bat"
exit

:WinXP
if not exist "%HomeDrive%\ATIB\boot.ini" (
goto NotMenu
)

ATI_Win_XP_Boot_Menu_UnInstall.bat
exit

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit

:NotMenu
start msgbox "Menu is not installed, can not be remove." 0 "Menu Errors"
exit