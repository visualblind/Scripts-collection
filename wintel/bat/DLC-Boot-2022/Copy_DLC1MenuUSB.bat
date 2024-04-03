@echo off
mode con lines=30 cols=85
Title Copy DLC1MenuUSB - DLC Corporation

:CheckUSB
echo.
for /f "Tokens=*" %%x in ('WMIC LOGICALDISK GET DESCRIPTION^|FIND /i "Removable"') do goto MAINMENU
echo No USB connection. Please plug USB!
echo Then press any key for continue...
pause >nul
goto CheckUSB

:MAINMENU
cls
xecho "================================================================================" /a:0E
echo.
xecho "Please select the drive to copy files" /x:12 /nolf /a:0E & xecho "_" /nolf /a:0 & xecho "DLC1MenuUSB.exe" /a:0C
echo.
xecho "================================================================================" /a:0E
start "" BOOTICE.exe
echo.
echo Please Hide Partition Boot and UnHide Partition Data
echo Press any key for continue...
pause >nul
cls
xecho "================================================================================" /a:0E
echo.
xecho "Please select the drive to copy files" /x:12 /nolf /a:0E & xecho "_" /nolf /a:0 & xecho "DLC1MenuUSB.exe" /a:0C
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
SET /P agree=Do you want continue with %drive%:\ Y/N = Yes/No)?:
echo.
IF /I NOT '%agree%'=='Y' IF /I NOT '%agree%'=='N' goto agree
IF /I '%agree%'=='Y' (
goto yes
)
goto MAINMENU
cls

:yes
echo Please wait while Copy DLC1MenuUSB.exe to USB...
copy /y DLC1MenuUSB.exe %drive%:\
start msgbox "Complete Create USB Boot. Click OK for Exit Program..." 0 "Creat USB DLC Boot 2015"
exit