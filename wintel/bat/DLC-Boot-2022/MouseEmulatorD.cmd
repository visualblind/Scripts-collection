@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\MouseEmulator.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\MouseEmulator.7z
start "" /D"%temp%\DLC1Temp" "MouseEmulator.exe"
"%temp%\DLC1Temp\mousem.txt"
exit
:a
start "" /D"%temp%\DLC1Temp" "MouseEmulator.exe"
"%temp%\DLC1Temp\mousem.txt"
exit