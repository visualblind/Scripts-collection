@echo off
pushd "%~dp0"


if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64bit

:32bit
if exist "%temp%\DLC1Temp\ActivePasswordChanger\ActivePasswordChanger.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\ActivePasswordChanger" -y files\ActivePasswordChanger.7z
rem copy "%temp%\DLC1Temp\ActivePasswordChanger\winmm32.dll" "%temp%\DLC1Temp\ActivePasswordChanger\winmm.dll" /y 
start "" /D"%temp%\DLC1Temp\ActivePasswordChanger" "ActivePasswordChanger.exe"
exit
:a32
start "" /D"%temp%\DLC1Temp\ActivePasswordChanger" "ActivePasswordChanger.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\ActivePasswordChanger\ActivePasswordChanger.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\ActivePasswordChanger" -y files\ActivePasswordChanger.7z
rem copy "%temp%\DLC1Temp\ActivePasswordChanger\winmm64.dll" "%temp%\DLC1Temp\ActivePasswordChanger\winmm.dll" /y 
start "" /D"%temp%\DLC1Temp\ActivePasswordChanger" "ActivePasswordChanger.exe"
exit
:a64
start "" /D"%temp%\DLC1Temp\ActivePasswordChanger" "ActivePasswordChanger.exe"
exit