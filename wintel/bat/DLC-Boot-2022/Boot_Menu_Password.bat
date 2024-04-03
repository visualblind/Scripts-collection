@echo off
mode con lines=30 cols=85
Title Creat Password Menu for USB DLC Boot 2015 - DLC Corporation
REM if "%COMPUTERNAME:~0,6%"=="MiniXP" goto NotRunMini
REM if exist %SystemRoot%\System32\CheckMini7 goto NotRunMini

:MAINMENU
cls
xecho "================================================================================" /a:0E
echo.
xecho "Tool creat Boot Menu Password DLC Boot 2015" /x:12 /nolf /a:0C
echo.
echo.
xecho "================================================================================" /a:0E

echo.
echo Disk List on Your Computer
echo.
xecho "Letter" /x:1 /nolf /a:0E & xecho "___" /nolf /a:0 & xecho "Label" /nolf /a:0B & xecho "________" /nolf /a:0 & xecho "Type" /nolf /a:0D & xecho "___" /nolf /a:0 & xecho "Disk Type" /nolf /a:0C & xecho "___" /nolf /a:0 & xecho "Size" /a:0A
for /f "tokens=3*" %%a in ('echo list volume ^| diskpart ^|find /i "Partition"') do (
set %%a=%%a
echo  %%a:       %%b   )
for /f "tokens=3*" %%a in ('echo list volume ^| diskpart ^|find /i "remov"') do (
set %%a=%%a
echo  %%a:       %%b   )
REM xecho "Disk Type" /nolf /a:0A & xecho "_________" /nolf /a:0 & xecho "Letter" /nolf /a:0B & xecho "____" /nolf /a:0 & xecho "Label" /a:0D
REM wmic logicaldisk get DESCRIPTION,DEVICEID,VOLUMENAME
echo.
xecho "================================================================================" /a:0A
echo.
echo  Type name Disk with a character, 
set /p drive=(Ex: D,E,F,G,H,I,J,K,...) and Enter:

del /f /q /a  %tmp%\TestDisk.txt >nul 2>nul
wmic logicaldisk get DESCRIPTION,DEVICEID,VOLUMENAME > %tmp%\TestDisk.txt
IF /I '%drive%'=='' goto MAINMENU
find /c /i "%drive%:" "%tmp%\TestDisk.txt" > NUL 2>NUL
if %ERRORLEVEL% == 0 (
del /f /q /a  %tmp%\TestDisk.txt >nul 2>nul
goto proceed
)
cls
echo.
echo  Disk Name errors. Please press any key for try again.
pause >nul
goto MAINMENU
echo.

:proceed
cls
echo.
:agree
cls
echo.
echo Are you sure %drive%:\ is Your Disk?
echo.
SET agree=
SET /P agree=Do you want continue with %drive%:\ (Y/N = Yes/No)?:
echo.
IF /I NOT '%agree%'=='Y' IF /I NOT '%agree%'=='N' goto agree
IF /I '%agree%'=='Y' (
goto yes
)
goto MAINMENU

:yes
cls
echo Kiem tra kha nang ghi xoa cua phan vung >%drive%:\Check.DLC
if not exist "%drive%:\Check.DLC" (
goto readonly
)
del %drive%:\Check.DLC

if not exist "%drive%:\DLC1\Boot\PassBackground.jpg" (
goto notdlcboot
)
cls
if exist "%drive%:\dlc" (
goto grub4dospass
)
if exist "%drive%:\syslinux.cfg" (
goto syslinuxpass
)

:syslinuxpass
attrib -r -h -s "%drive%:\syslinux.cfg"
del /a /f /q %drive%:\syslinux.cfg
cls
echo.
echo  Type Password you want: 
set /p password=(Ex: 123) and Enter:
IF /I '%password%'=='' (
goto syslinuxpass
)
cls
copy /y syslinuxpass.cfg %drive%:\syslinux.cfg

(
echo.
echo menu passwd %password%
echo kernel /DLC1/Boot/menu.c32
echo APPEND /DLC1/Menu/en/USB/syslinux.cfg
)>>%drive%:\syslinux.cfg

attrib +h "%drive%:\syslinux.cfg"
start msgbox "Complete Create Boot Menu Password. Click OK for Exit Program..." 0 "Creat Boot Menu Password"
exit

:grub4dospass
del /a /f /q %drive%:\DLC1\Menu\menu.lst
cls
echo.
echo  Type Password you want: 
set /p password=(Ex: 123) and Enter:
IF /I '%password%'=='' (
goto grub4dospass
)
cls
copy /y menupass.lst %drive%:\DLC1\Menu\menu.lst

(
echo.
echo password %password%
echo find --set-root /DLC1/Menu/en/USB/menu.lst
echo configfile /DLC1/Menu/en/USB/menu.lst
)>>%drive%:\DLC1\Menu\menu.lst

start msgbox "Complete Create Boot Menu Password. Click OK for Exit Program..." 0 "Creat Boot Menu Password"
exit

:notdlcboot
echo Drive %drive%:\ not install DLC Boot
echo Press any key for Exit...
pause >nul
exit

:readonly
echo Drive %drive%:\ Read Only
echo Press any key for Exit...
pause >nul
exit

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit