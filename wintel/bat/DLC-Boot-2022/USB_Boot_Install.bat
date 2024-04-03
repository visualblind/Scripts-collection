@echo off
mode con lines=30 cols=85
Title Creat USB DLC Boot 2015 - DLC Corporation
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto CheckUSBMiniWin
if exist %SystemRoot%\System32\CheckMini7 goto CheckUSBMiniWin
if exist %SystemRoot%\System32\CheckMini8 goto CheckUSBMiniWin

:CheckUSB
echo.
for /f "Tokens=*" %%x in ('WMIC LOGICALDISK GET DESCRIPTION^|FIND /i "Removable"') do goto MAINMENU
echo No USB connection. Please plug USB!
echo Then press any key for continue...
pause >nul
goto CheckUSB

:CheckUSBMiniWin
echo.
Drv.exe GetUsbDrives
find /c /i "No USB" "%Temp%\UsbDrives.txt" > NUL 2>NUL
if %ERRORLEVEL% == 1 (
del /f /q /a  %Temp%\UsbDrives.txt >nul 2>nul
del /f /q /a  %Temp%\RMPartUSB.lst >nul 2>nul
goto MAINMENU
)
del /f /q /a  %Temp%\UsbDrives.txt >nul 2>nul
del /f /q /a  %Temp%\RMPartUSB.lst >nul 2>nul
cls
echo.
echo No USB connection. Please plug USB!
echo Then press any key for continue...
pause >nul
goto CheckUSBMiniWin

:MAINMENU
cls
xecho "================================================================================" /a:0E
echo.
xecho "Tool creat USB DLC Boot 2015 with SysLinux" /x:12 /nolf /a:0E & xecho "_" /nolf /a:0 & xecho "(FAT/FAT32/NTFS)" /a:0C
echo.
xecho "If you want boot USB on UEFI, " /x:12 /nolf /a:0E & xecho "_" /nolf /a:0 & xecho "USB must format FAT32" /a:0C
echo.
xecho "================================================================================" /a:0E

echo.
echo USB List on Your Computer
echo.

if "%COMPUTERNAME:~0,6%"=="MiniXP" goto GetUSBOnMiniWin
if exist %SystemRoot%\System32\CheckMini7 goto GetUSBOnMiniWin
if exist %SystemRoot%\System32\CheckMini8 goto GetUSBOnMiniWin

xecho "Letter" /x:1 /nolf /a:0E & xecho "___" /nolf /a:0 & xecho "Label" /nolf /a:0B & xecho "________" /nolf /a:0 & xecho "Type" /nolf /a:0D & xecho "___" /nolf /a:0 & xecho "Disk Type" /nolf /a:0C & xecho "___" /nolf /a:0 & xecho "Size" /a:0A
for /f "tokens=3*" %%a in ('echo list volume ^| diskpart ^|find /i "remov"') do (
set %%a=%%a
echo  %%a:       %%b   )
goto Continue

:GetUSBOnMiniWin
Drv.exe GetUsbDrives
type %Temp%\UsbDrives.txt

:Continue
echo.
xecho "================================================================================" /a:0A
echo.
echo  Type name USB with a character, 
set /p drive=(Ex: D,E,F,G,H,I,J,K,...) and Enter:
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto CheckUSBOnMiniWin
if exist %SystemRoot%\System32\CheckMini7 goto CheckUSBOnMiniWin
if exist %SystemRoot%\System32\CheckMini8 goto CheckUSBOnMiniWin

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

:CheckUSBOnMiniWin
IF /I '%drive%'=='' goto MAINMENU
find /c /i "%drive%:" "%Temp%\UsbDrives.txt" > NUL 2>NUL
if %ERRORLEVEL% == 0 (
del /f /q /a  %Temp%\UsbDrives.txt >nul 2>nul
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
echo  You can't Creat USB DLC Boot on USB running DLC Boot.
echo  Please press any key for try again.
pause >nul
goto MAINMENU
:agree
cls
echo.
echo Are you sure %drive%:\ is Your USB?
echo.
SET agree=
SET /P agree=Do you want continue with %drive%:\ (Y/N = Yes/No)?:
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

:setupusb
Echo Please wait for creat USB Boot.
for %%x in (Boot DLC1 efi) do md %drive%:\%%x
for %%x in (Boot DLC1 efi) do attrib +h +s %drive%:\%%x
md %drive%:\DLC1\Boot
syslinux.exe -fma -r -d \DLC1\Boot %drive%:
echo.
echo Please wait while copying the necessary files...
copy /y syslinux.cfg %drive%:\
copy /y livecd %drive%:\
attrib +h "%drive%:\syslinux.cfg"
attrib +r +h +s "%drive%:\livecd"
copy /y ..\..\..\DLC_Boot_2015.doc %drive%:\
copy /y ..\..\..\DLC1Menu.exe %drive%:\
xcopy ..\..\..\DLC1\* %drive%:\DLC1 /s /i /y
xcopy ..\..\..\Boot\* %drive%:\Boot /s /i /y
xcopy ..\..\..\efi\* %drive%:\efi /s /i /y
ren %drive%:\DLC1\Programs\BootFromCD BootFromUSB

if exist "%drive%:\DLC1\XP\XP.iso" (
goto extractminixpiso
)
start msgbox "Complete Create USB Boot. Click OK for Exit Program..." 0 "Creat USB DLC Boot 2015"
exit

:extractminixpiso
del /a /f /q %drive%:\DLC1\XP\XP.iso
..\Create_or_Extract\Program_Files\7z x ..\..\XP\XP.iso -o"%drive%:\" -y -x"![BOOT]\*.img"
del /a /f /q %drive%:\isolinux.cfg

ChangeCodeXP --cl --dir "%drive%:\DLC1\Menu" --fileMask "*.cfg"  --includeSubDirectories --find "#COM32 /DLC1/Boot/chain.c32 ntldr=/DLC1/XP/XP.BIN\nkernel /DLC1/Boot/grub.exe" --replace "COM32 /DLC1/Boot/chain.c32 ntldr=/DLC1/XP/XP.BIN\n#kernel /DLC1/Boot/grub.exe"
ChangeCodeXP --cl --dir "%drive%:\DLC1\Menu" --fileMask "*.lst"  --includeSubDirectories --find "#find --set-root /DLC1/XP/XP.BIN\n#chainloader /DLC1/XP/XP.BIN\nfind --set-root --ignore-floppies /DLC1/XP/XP.iso\nmap /DLC1/XP/XP.iso (0xff) || map --mem /DLC1/XP/XP.iso (0xff)\nmap --hook\nroot (0xff)\nchainloader (0xff)\nboot" --replace "find --set-root /DLC1/XP/XP.BIN\nchainloader /DLC1/XP/XP.BIN\n#find --set-root --ignore-floppies /DLC1/XP/XP.iso\n#map /DLC1/XP/XP.iso (0xff) || map --mem /DLC1/XP/XP.iso (0xff)\n#map --hook\n#root (0xff)\n#chainloader (0xff)\n#boot"

start msgbox "Complete Create USB Boot. Click OK for Exit Program..." 0 "Creat USB DLC Boot 2015"
exit

:Remove
echo Please wait while remove the old version...
for %%x in (syslinux.cfg dlc livecd) do echo attrib -r -h -s %drive%:\%%x&& attrib -r -h -s %drive%:\%%x
for %%x in (syslinux.cfg dlc DLC_Boot_2015.doc DLC1Menu.exe DLC1MenuUSB.exe livecd) do echo del /a /f /q %drive%:\%%x&& del /a /f /q %drive%:\%%x
rd /s /q %drive%:\DLC1
rd /s /q %drive%:\Boot
rd /s /q %drive%:\efi
echo.
echo Finished remove the old version.
goto setupusb

:NotRunMini
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit