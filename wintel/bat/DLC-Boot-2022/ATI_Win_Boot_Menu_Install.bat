@echo off
Title ATI Menu for Windows Vista/7/8 on HDD - DLC Corporation
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto NotRunMini
if exist %SystemRoot%\System32\CheckMini7 goto NotRunMini
if exist %SystemRoot%\System32\CheckMini8 goto NotRunMini

if not exist "..\..\Dos\ati.iso" (
goto NoModuleATI
)

for /f "Tokens=*" %%a in ('net localgroup Administrators^|find /i "%username%"') do goto Start
start msgbox "You are not running with Admin account! Please log into the Admin account, and try again!" 0 "User Errors"
exit

:Start
if not exist "%PUBLIC%" (
goto WinXP
)

:Windows78
if exist "%HomeDrive%\ATIB\MenuRemove.bat" (
goto ReadyInstall
)

md %HomeDrive%\ATIB
for %%x in (Dos Menu) do md %HomeDrive%\ATIB\%%x
attrib +h +s "%HomeDrive%\ATIB"
copy /y ..\..\Dos\ati.iso %HomeDrive%\ATIB\Dos

Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry%  | Find /i "x86" 
if %ERRORLEVEL% == 0 (
    goto 32Bit
) else (
    goto 64Bit
)

:32Bit
set dd=%~dp0
RunAdmin32 "%dd%ATI_Win_78_Boot_Menu_Install_Run.bat"
goto password
exit

:64Bit
set dd=%~dp0
RunAdmin64 "%dd%ATI_Win_78_Boot_Menu_Install_Run.bat"
goto password
exit

:password
cls
echo.
echo Do you want to create a password for Menu Boot?
echo.
SET agree=
SET /P agree=Do you want continue (Y/N = Yes/No)?:
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
copy /y menupass.lst %HomeDrive%\ATIB\Menu\menu.lst
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo.
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo password %password%
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo find --set-root --ignore-floppies /ATIB/Dos/ati.iso
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo map --mem /ATIB/Dos/ati.iso (0xff)
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo map --hook
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo root (0xff)
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo chainloader (0xff)
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo boot
start msgbox "Complete Integrated into the Windows Vista, 7, 8 Boot Menu" 0 "Complete Integrated"
exit

:finish
copy /y atimenu.lst %HomeDrive%\ATIB\Menu\menu.lst
start msgbox "Complete Integrated into the Windows Vista, 7, 8 Boot Menu" 0 "Complete Integrated"
exit

:WinXP
ATI_Win_XP_Boot_Menu_Install.bat
exit

:ReadyInstall
start msgbox "Old Menu installed, Please Remove it before Install New Version." 0 "Menu Errors"
exit

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit

:NoModuleATI
start msgbox "Please Integrate Module Acronis True Image before." 0 "No Module ATI"
exit