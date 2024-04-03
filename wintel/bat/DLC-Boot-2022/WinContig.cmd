@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\WinContig\WinContig.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\WinContig" -y files\WinContig.7z
start "" /D"%temp%\DLC1Temp\WinContig" "WinContig.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\WinContig" "WinContig.exe"
exit