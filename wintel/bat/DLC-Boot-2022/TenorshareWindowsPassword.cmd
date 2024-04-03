@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\TenorshareWindowsPassword\TenorshareWindowsPassword.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\TenorshareWindowsPassword" -y files\TenorshareWindowsPassword.7z
start "" /D"%temp%\DLC1Temp\TenorshareWindowsPassword" "TenorshareWindowsPassword.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\TenorshareWindowsPassword" "TenorshareWindowsPassword.exe"