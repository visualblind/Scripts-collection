@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\ChangeMACAddress\ChangeMACAddress.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ChangeMACAddress" -y files\ChangeMACAddress.7z
start "" /D"%temp%\DLC1Temp\ChangeMACAddress" "ChangeMACAddress.exe"
start "" /D"%temp%\DLC1Temp\ChangeMACAddress" "LSKeyGen.exe"
exit

:a
start "" /D"%temp%\DLC1Temp\ChangeMACAddress" "ChangeMACAddress.exe"
start "" /D"%temp%\DLC1Temp\ChangeMACAddress" "LSKeyGen.exe"
exit