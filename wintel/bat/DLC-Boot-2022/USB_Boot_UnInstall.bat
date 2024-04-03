@echo off
mode con lines=30 cols=85
Title UnInstall USB DLC Boot 2015 - DLC Corporation
REM if "%COMPUTERNAME:~0,6%"=="MiniXP" goto NotRunMini
REM if exist %SystemRoot%\System32\CheckMini7 goto NotRunMini

:CheckUSB
echo.
for /f "Tokens=*" %%x in ('WMIC LOGICALDISK GET DESCRIPTION^|FIND /i "Removable"') do goto MAINMENU
echo No USB connection. Please plug USB!
echo Then press any key for continue...
echo.
@pause
goto CheckUSB

:MAINMENU
cls
xecho "================================================================================" /a:0E
echo.
xecho "Tool UnInstall USB DLC Boot 2015" /x:22 /a:0E
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

:proceed
cls
echo.
if exist "..\..\Programs\BootFromCD" (
goto agree
)

:checkusbrun
echo Tao file de kiem tra xem co go nham USB DLC Boot tren USB dang chay >Check.DLC
if not exist "%drive%:\DLC1\Tools\Make_Boot\Check.DLC" (
del /a /f /q Check.DLC
goto agree
)
del /a /f /q Check.DLC
cls
echo.
echo  You can't remove USB DLC Boot on USB running DLC Boot.
echo  Please press any key for try again.
pause >nul
goto MAINMENU

:agree
cls
echo.
echo Are you sure %drive%:\ is Your USB?
echo.
SET agree=
SET /P agree=Do you want continue with %drive%:\ Y/N = Yes/No)?:
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
goto Remove
)
if exist "%drive%:\syslinux.cfg" (
goto Remove
)
start msgbox "DLC BootUSB is not installed, can not be remove." 0 "Errors DLC Boot USB"
exit

:Remove
echo Please wait while remove DLC BootUSB...
for %%x in (syslinux.cfg dlc livecd) do echo attrib -r -h -s %drive%:\%%x&& attrib -r -h -s %drive%:\%%x
for %%x in (syslinux.cfg dlc DLC_Boot_2015.doc DLC1Menu.exe DLC1MenuUSB.exe livecd) do echo del /a /f /q %drive%:\%%x&& del /a /f /q %drive%:\%%x
rd /s /q %drive%:\DLC1
rd /s /q %drive%:\Boot
rd /s /q %drive%:\efi
start msgbox "Complete removal DLC BootUSB." 0 "Complete removal"
exit

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit