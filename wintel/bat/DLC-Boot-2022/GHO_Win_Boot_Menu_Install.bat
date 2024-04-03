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
if exist "%HomeDrive%\GHOS\MenuRemove.bat" (
goto ReadyInstall
)

md %HomeDrive%\GHOS
for %%x in (Boot Dos Menu) do md %HomeDrive%\GHOS\%%x
attrib +h +s "%HomeDrive%\GHOS"
copy /y ..\..\Boot\memdisk %HomeDrive%\GHOS\Boot
copy /y ..\..\Dos\Ghost.ima %HomeDrive%\GHOS\Dos

Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry%  | Find /i "x86" 
if %ERRORLEVEL% == 0 (
    goto 32Bit
) else (
    goto 64Bit
)

:32Bit
set dd=%~dp0
RunAdmin32 "%dd%GHO_Win_78_Boot_Menu_Install_Run.bat"
goto password
exit

:64Bit
set dd=%~dp0
RunAdmin64 "%dd%GHO_Win_78_Boot_Menu_Install_Run.bat"
goto password
exit

:password
cls
echo.
SET agree=
SET /P agree=Do you want to create a password for Menu Boot (Y/N = Yes/No)?:
echo.
IF /I NOT '%agree%'=='Y' IF /I NOT '%agree%'=='N' goto password
IF /I '%agree%'=='Y' (
goto makepass
)
goto finish

:makepass
cls
echo.
echo  Type Password you want: 
set /p password=(Ex: 123) and Enter:
IF /I '%password%'=='' (
goto makepass
)
cls
copy /y menupass.lst %HomeDrive%\GHOS\Menu\menu.lst
(
echo.
echo password %password%
echo kernel /GHOS/Boot/memdisk ima raw
echo initrd /GHOS/Dos/Ghost.ima
)>>"%HomeDrive%\GHOS\Menu\menu.lst"
start msgbox "Complete Integrated into the Windows Vista, 7, 8 Boot Menu" 0 "Complete Integrated"
exit

:finish
copy /y ghomenu.lst %HomeDrive%\GHOS\Menu\menu.lst
start msgbox "Complete Integrated into the Windows Vista, 7, 8 Boot Menu" 0 "Complete Integrated"
exit

:WinXP
GHO_Win_XP_Boot_Menu_Install.bat
exit

:ReadyInstall
start msgbox "Old Menu installed, Please Remove it before Install New Version." 0 "Menu Errors"
exit

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit