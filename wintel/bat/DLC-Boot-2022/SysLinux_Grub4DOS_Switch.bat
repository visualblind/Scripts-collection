@echo off
mode con lines=30 cols=85
Title Switch SysLinux and Grub4DOS Tools - DLC Corporation
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto NotRunMini
if exist %SystemRoot%\System32\CheckMini7 goto NotRunMini

:CheckUSB
echo.
for /f "Tokens=*" %%x in ('WMIC LOGICALDISK GET DESCRIPTION^|FIND /i "Removable"') do goto MAINMENU
echo No USB connection. Please plug USB!
echo Not support for HDD Box.
echo Then press any key for continue...
pause >nul
goto CheckUSB

:MAINMENU
cls
xecho "================================================================================" /a:0E
echo.
xecho "SysLinux" /x:25 /nolf /a:0A & xecho "_" /nolf /a:0 & xecho "<<==Switch==>>" /nolf /a:0B & xecho "_" /nolf /a:0 & xecho "Grub4DOS" /a:0A
echo.
xecho "================================================================================" /a:0E

echo.
echo USB List on Your Computer
echo.
xecho "Letter" /x:1 /nolf /a:0E & xecho "___" /nolf /a:0 & xecho "Label" /nolf /a:0B & xecho "________" /nolf /a:0 & xecho "Type" /nolf /a:0D & xecho "___" /nolf /a:0 & xecho "Disk Type" /nolf /a:0C & xecho "___" /nolf /a:0 & xecho "Size" /a:0A
for /f "tokens=3*" %%a in ('echo list volume ^| diskpart ^|find /i "remov"') do (
set %%a=%%a
echo  %%a:       %%b   )
echo.
xecho "================================================================================" /a:0A
echo.
echo  Type name USB with a character, 
set /p drive=(Ex: D,E,F,G,H,I,J,K,...) and Enter:

del /f /q /a  %tmp%\TestUSB.txt >nul 2>nul
wmic logicaldisk get DESCRIPTION,DEVICEID,VOLUMENAME|FINDSTR "Removable" > %tmp%\TestUSB.txt
IF /I '%drive%'=='' goto MAINMENU
find /c /i "%drive%:" "%tmp%\TestUSB.txt" > NUL 2>NUL
if %ERRORLEVEL% == 0 (
del /f /q /a  %tmp%\TestUSB.txt >nul 2>nul
goto proceed
)
cls
echo.
echo  USB Name errors. Please press any key for try again.
pause >nul
goto MAINMENU
echo.

:proceed
cls
echo.
:agree
cls
echo.
echo Are you sure %drive%:\ is Your USB?
echo.
SET agree=
SET /P agree=Do you want continue Switch with %drive%:\ Y/N = Yes/No)?:
echo.
IF /I NOT '%agree%'=='Y' IF /I NOT '%agree%'=='N' goto agree
IF /I '%agree%'=='Y' (
goto yes
)
goto MAINMENU
cls

:yes
cls
if exist "%drive%:\dlc" (
goto SwitchSysLinux
)
if exist "%drive%:\syslinux.cfg" (
goto SwitchGrub4DOS
)
start msgbox "DLC BootUSB is not installed, can not Switch." 0 "Errors DLC Boot USB"

:SwitchSysLinux
cls
Echo Please wait for Switch SysLinux Boot.
syslinux.exe -fma -r -d \DLC1\Boot %drive%:
copy /y syslinux.cfg %drive%:\
attrib +h "%drive%:\syslinux.cfg"

attrib -r -h -s "%drive%:\dlc"
del /a /f /q "%drive%:\dlc"
start msgbox "Complete Switch SysLinux Boot. Click OK for Exit Program..." 0 "Switch Complete"
exit

:SwitchGrub4DOS
cls
Echo Please wait for Switch Grub4DOS Boot.
BootICE /DEVICE=%drive%: /mbr /install /type=nt52 /mbr-disable-floppy /quiet
BootICE /DEVICE=%drive%: /pbr /install /type=GRUB4DOS /boot_file=dlc /mbr-disable-floppy /quiet
BOOTICE /DEVICE=%drive%: /partitions /activate /quiet
copy /y dlc %drive%:\
attrib +r +h +s "%drive%:\dlc"

attrib -r -h -s "%drive%:\syslinux.cfg"
del /a /f /q "%drive%:\syslinux.cfg"
start msgbox "Complete Switch Grub4DOS Boot. Click OK for Exit Program..." 0 "Switch Complete"
exit

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit