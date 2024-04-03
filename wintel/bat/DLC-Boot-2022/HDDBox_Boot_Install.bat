@echo off
mode con lines=30 cols=85
Title Creat HDD Box DLC Boot 2015 - DLC Corporation
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto NotRunMini
if exist %SystemRoot%\System32\CheckMini7 goto NotRunMini
if exist %SystemRoot%\System32\CheckMini8 goto NotRunMini

if exist %tmp%\usbdisk.txt del %tmp%\usbdisk.txt
:start
for /f %%a in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Disk\Enum /s ^| find "USBSTOR"') do echo %%a >> %tmp%\listUSB.txt
for /f %%b in (%tmp%\listUSB.txt) do (
echo select disk %%b >%tmp%\list%%b.txt
echo detail disk >> %tmp%\list%%b.txt
diskpart /s %tmp%\list%%b.txt > %tmp%\usbdiskdetail.txt
for /f  "skip=17 tokens=3" %%a in (%tmp%\usbdiskdetail.txt) do goto MAINMENU
if exist %tmp%\list%%b.txt del %tmp%\list%%b.txt
)
if exist %tmp%\UsbDrives.txt del %tmp%\UsbDrives.txt
if exist %tmp%\usbdiskdetail.txt del %tmp%\usbdiskdetail.txt
if exist %tmp%\listUSB.txt del %tmp%\listUSB.txt
echo.
cls
echo No HDD Box connection. Please plug HDD Box!
echo Then press any key for continue...
pause >nul
goto start

:MAINMENU
for /f %%b in (%tmp%\listUSB.txt) do (
echo select disk %%b >%tmp%\list%%b.txt
echo detail disk >> %tmp%\list%%b.txt
diskpart /s %tmp%\list%%b.txt > %tmp%\usbdiskdetail.txt
del %tmp%\listUSB.txt
del %tmp%\list%%b.txt
)
cls
xecho "================================================================================" /a:0E
echo.
xecho "Tool creat HDD Box DLC Boot 2015 with Grub4DOS" /x:9 /nolf /a:0E & xecho "_" /nolf /a:0 & xecho "(FAT/FAT32/NTFS)" /a:0C
echo.
xecho "================================================================================" /a:0E

echo.
echo HDD Box List on Your Computer
echo.
xecho "Disk Type" /nolf /a:0A & xecho "_________" /nolf /a:0 & xecho "Letter" /nolf /a:0B & xecho "____" /nolf /a:0 & xecho "Label" /a:0D
for /f  "skip=17 tokens=3" %%a in (%tmp%\usbdiskdetail.txt) do wmic logicaldisk get DESCRIPTION,DEVICEID,VOLUMENAME|FINDSTR "%%a:"
echo.
xecho "================================================================================" /a:0A
echo.
echo  Type name HDD Box with a character, 
set /p drive=(Ex: D,E,F,G,H,I,J,K,...) and Enter:
IF /I '%drive%'=='' goto start
for /f  "skip=17 tokens=3" %%a in (%tmp%\usbdiskdetail.txt) do echo %%a >> %tmp%\TestHDDBox.txt
find /c /i "%drive%" "%tmp%\TestHDDBox.txt" > NUL 2>NUL
if %ERRORLEVEL% == 0 (
del %tmp%\usbdiskdetail.txt
del %tmp%\TestHDDBox.txt
goto proceed
)
del %tmp%\usbdiskdetail.txt
del %tmp%\TestHDDBox.txt
cls
echo.
echo  HDD Box Name errors. Please press any key for try again.
pause >nul
goto start
echo.

:proceed
cls
echo.
if exist "..\..\Programs\BootFromCD" (
goto agree
)

:checkhddboxrun
echo Tao file de kiem tra xem co go nham HDD Box DLC Boot tren HDD Box dang chay >Check.DLC
if not exist "%drive%:\DLC1\Tools\Make_Boot\Check.DLC" (
del /a /f /q Check.DLC
goto agree
)
del /a /f /q Check.DLC
cls
echo.
echo  You can't Creat HDD Box DLC Boot on HDD Box running DLC Boot.
echo  Please press any key for try again.
pause >nul
goto MAINMENU
:agree
cls
echo.
echo Are you sure %drive%:\ is Your HDD Box?
echo.
SET agree=
SET /P agree=Do you want continue with %drive%:\ Y/N = Yes/No)?:
echo.
IF /I NOT '%agree%'=='Y' IF /I NOT '%agree%'=='N' goto agree
IF /I '%agree%'=='Y' (
goto yes
)
goto start
cls

:yes
cls
if exist "%drive%:\dlc" (
goto Remove
)

:setupusb
Echo Please wait for creat HDD Box Boot.
for %%x in (Boot DLC1) do md %drive%:\%%x
for %%x in (Boot DLC1) do attrib +h +s %drive%:\%%x
BootICE /DEVICE=%drive%: /mbr /install /type=nt52 /mbr-disable-floppy /quiet
BootICE /DEVICE=%drive%: /pbr /install /type=GRUB4DOS /boot_file=dlc /mbr-disable-floppy /quiet
BOOTICE /DEVICE=%drive%: /partitions /activate /quiet
echo.
echo Please wait while copying the necessary files...
copy /y dlc %drive%:\
copy /y livecd %drive%:\
attrib +r +h +s "%drive%:\dlc"
attrib +r +h +s "%drive%:\livecd"
copy /y ..\..\..\DLC_Boot_2015.doc %drive%:\
copy /y ..\..\..\DLC1Menu.exe %drive%:\
xcopy ..\..\..\DLC1\* %drive%:\DLC1 /s /i /y
xcopy ..\..\..\Boot\* %drive%:\Boot /s /i /y
ren %drive%:\DLC1\Programs\BootFromCD BootFromUSB
start msgbox "Complete Create HDD Box Boot. Click OK for Exit Program..." 0 "Creat HDD Box DLC Boot 2015"
exit

:Remove
echo Please wait while remove the old version...
for %%x in (dlc livecd) do echo attrib -r -h -s %drive%:\%%x&& attrib -r -h -s %drive%:\%%x
for %%x in (dlc DLC_Boot_2015.doc DLC1Menu.exe DLC1MenuUSB.exe livecd) do echo del /a /f /q %drive%:\%%x&& del /a /f /q %drive%:\%%x
rd /s /q %drive%:\DLC1
rd /s /q %drive%:\Boot
echo.
echo Finished remove the old version.
goto setupusb

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit