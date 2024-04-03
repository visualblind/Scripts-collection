@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\AntiDeepFreeze1.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\AntiDeepFreeze1.7z
start "" /D"%temp%\DLC1Temp" "AntiDeepFreeze1.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "AntiDeepFreeze1.exe"