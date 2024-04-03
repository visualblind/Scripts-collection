@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\GetDiskSerial\DevlibGetDiskSerial.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\GetDiskSerial" -y files\DevlibGetDiskSerial.7z
start "" /D"%temp%\DLC1Temp\GetDiskSerial" "DevlibGetDiskSerial.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\GetDiskSerial" "DevlibGetDiskSerial.exe"