@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\AntiDeepFreeze5.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\AntiDeepFreeze5.7z
start "" /D"%temp%\DLC1Temp" "AntiDeepFreeze5.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "AntiDeepFreeze5.exe"