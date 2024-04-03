@echo off
Title DLC Boot 2015 Menu for Windows Vista/7/8 on HDD - DLC Corporation
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
if exist "%HomeDrive%\DLC1\MenuRemove.bat" (
goto ReadyInstall
)

cls
md %HomeDrive%\DLC1
attrib +h +s "%HomeDrive%\DLC1"
if exist "%HomeDrive%\Boot\BCD" (
goto SetupWithBootFolder
)
md %HomeDrive%\Boot
attrib +h +s "%HomeDrive%\Boot"

:SetupWithBootFolder
echo Please wait while copying the necessary files...
xcopy ..\..\..\DLC1\* %HomeDrive%\DLC1 /s /i /y

Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry%  | Find /i "x86" 
if %ERRORLEVEL% == 0 (
    goto 32Bit
) else (
    goto 64Bit
)

:32Bit
set dd=%~dp0
RunAdmin32 "%dd%Win_78_Boot_Menu_Install_Run.bat"
exit

:64Bit
set dd=%~dp0
RunAdmin64 "%dd%Win_78_Boot_Menu_Install_Run.bat"
exit

:WinXP
Win_XP_Boot_Menu_Install.bat
exit

:ReadyInstall
start msgbox "Old Menu installed, Please Remove it before Install New Version." 0 "Menu Errors"
exit

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit