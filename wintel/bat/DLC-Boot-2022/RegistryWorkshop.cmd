@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64Bit

:32bit
if exist "%temp%\DLC1Temp\RegistryWorkshop\RegWorkshop.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\RegistryWorkshop" -y files\RegistryWorkshopx86.7z
start "" /D"%temp%\DLC1Temp\RegistryWorkshop" "RegWorkshop.exe"
exit
:a32
start "" /D"%temp%\DLC1Temp\RegistryWorkshop" "RegWorkshop.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\RegistryWorkshop\RegWorkshop.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\RegistryWorkshop" -y files\RegistryWorkshopx64.7z
start "" /D"%temp%\DLC1Temp\RegistryWorkshop" "RegWorkshop.exe"
exit
:a64
start "" /D"%temp%\DLC1Temp\RegistryWorkshop" "RegWorkshop.exe"