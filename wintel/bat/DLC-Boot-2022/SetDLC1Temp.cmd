@echo off

if "%COMPUTERNAME:~0,6%"=="MiniXP" goto st
if exist %SystemRoot%\AcronisTrueImageHome.ico goto st

start msgbox "Sorry but this only works from Mini Windows XP or Mini Windows 7" 0 "OS Errors"
exit

:st
For %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO for /f "tokens=4,6*" %%k in ('vol %%I: 2^>nul^|find "drive"') do echo %%k - %%l %%m
set newd=%DLC1:~0,1%
for /f "tokens=3" %%x in ('fsutil fsinfo drivetype %newd%:') do if "%%x"=="CD-ROM" set newd=C
echo Press ENTER if you want to set your temp folder as C:\DLC1Temp
set /p newd=Enter Drive letter only (Example: C) : 
set NewTemp=%newd%:\DLC1Temp

if /i %TEMP%==%NewTemp% if /i %TMP%==%NewTemp% if not exist "B:\" if exist "%Temp%\" goto alrd
if not exist "%NewTemp%\" goto cont1
echo The new temp folder already exists
if not exist "%NewTemp%\*" goto cont2
echo Please wait while attempting to clear the content...
rmdir /s /q %NewTemp% 2> NUL
if exist "%NewTemp%\*" (echo Some of the files/folders from the new temp folder could not be erased!) else echo The content of the new temp folder was cleared...
if exist "%NewTemp%\" (goto cont2) else goto ncm
:cont1
echo Creating the new temp folder...
:ncm
mkdir %NewTemp% 2> NUL
if not exist "%NewTemp%\" goto err2
:cont2
for /f "tokens=3" %%i in ('dir /-c %newd%:\ ^| find "bytes free"') do if %%i lss 209715200 goto err3
if not exist "B:\" goto cont3
echo Detaching drive B...
imdisk.exe -D -m B:
if exist "B:\" then goto err4
:cont3
if /i %TEMP%==%NewTemp% if /i %TMP%==%NewTemp% goto cont4
echo Setting the environment...
setx.exe Temp %NewTemp%
if errorlevel 1 goto err5
setx.exe Tmp %NewTemp%
if errorlevel 1 goto err5
set Temp=%NewTemp%
set Tmp=%NewTemp%
echo Setting Program files to %SystemDrive%...
Reg add HKLM\Software\Microsoft\Windows\CurrentVersion /f /t REG_EXPAND_SZ /v ProgramFilesDir /d "%SystemDrive%\Program Files" >nul
Reg add HKLM\Software\Microsoft\Windows\CurrentVersion /f /t REG_EXPAND_SZ /v ProgramFilesPath /d "%SystemDrive%\Program Files" >nul
Reg add HKLM\Software\Microsoft\Windows\CurrentVersion /f /t REG_EXPAND_SZ /v CommonFilesDir /d "%SystemDrive%\Program Files\Common Files" >nul
mkdir "%SystemDrive%\Program Files\Common Files"
setx.exe ramdrv %Temp% -m
if errorlevel 1 goto err5
nircmd sysrefresh 2> NUL
nircmd sysrefresh environment 2> NUL
if not exist "%DLC1%\DLC1\DLC1menu.exe" goto err6
echo Restarting DLC1 menu...
nircmd closeprocess DLC1menu.exe 2> NUL
nircmd killprocess DLC1menu.exe 2> NUL
start "DLC1 menu" /MIN "%DLC1%\DLC1\DLC1menu.exe" 2> NUL
if errorlevel 1 goto err7
:cont4
goto ok
:alrd
echo The temp folder is already set on boot drive!
goto end
:err2
echo The new temp folder %NewTemp% could not be (re)created!
echo.
goto st
:err3
echo The amount of free space on drive %NewTemp:~0,2% is less than 200 MB!
echo Please free space and try again...
goto end
:err4
echo Drive B couldn't be detached!
goto end
:err5
echo Error setting the environment!
goto end
:err6
echo Error finding "%DLC1%\DLC1\DLC1menu.exe"
echo Please restart DLC1 menu manually!
goto ok
:err7
echo Error starting "%DLC1%\DLC1\DLC1menu.exe"
echo Please restart DLC1 menu manually!
goto ok
:ok
echo Temp folder is now %Temp%
for /f "tokens=3" %%x in ('fsutil fsinfo drivetype %newd%:') do if "%%x"=="Fixed" nircmd qbox "Do you want to set the pagefile as~n%newd%:\pagefile.sys of 512MB?" "Set Pagefile" "SetPageFile.exe" %newd%:\pagefile.sys 512
:end
pause