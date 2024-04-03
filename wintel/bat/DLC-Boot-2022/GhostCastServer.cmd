@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\GhostCastServer.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\GhostCastServer.7z
start "" /D"%temp%\DLC1Temp" "GhostCastServer.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "GhostCastServer.exe"