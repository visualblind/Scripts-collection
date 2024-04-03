@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\ResourceHacker\ResourceHacker.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ResourceHacker" -y files\ResourceHacker.7z
start "" /D"%temp%\DLC1Temp\ResourceHacker" "ResourceHacker.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\ResourceHacker" "ResourceHacker.exe"