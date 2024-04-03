@echo off
pushd "%~dp0"

if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runminiwin
if exist %SystemRoot%\AcronisTrueImageHome.ico goto runminiwin

if exist "%temp%\DLC1Temp\UltraISO\UltraISO.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\UltraISO" -y files\UltraISO.7z
CHDIR /D "%temp%\DLC1Temp\UltraISO"
REG IMPORT key.reg
start "" /D"%temp%\DLC1Temp\UltraISO" "UltraISO.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "UltraISO\UltraISO.exe"
exit

:runminiwin
if exist "%temp%\DLC1Temp\UltraISO\UltraISO.exe" goto b
7z.exe x -o"%temp%\DLC1Temp\UltraISO" -y files\UltraISO.7z
CHDIR /D "%temp%\DLC1Temp\UltraISO"
REG IMPORT key.reg
start "" /D"%temp%\DLC1Temp\UltraISO" "UltraISO.exe" %*
exit
:b
start "" /D"%temp%\DLC1Temp" "UltraISO\UltraISO.exe" %*