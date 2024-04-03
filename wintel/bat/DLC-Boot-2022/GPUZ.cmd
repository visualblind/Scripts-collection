@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\GPUZ.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\GPUZ.7z
rem REG ADD HKCU\Software\techPowerUp\GPU-Z /v Interval /t REG_DWORD /d 3 /f
start "" /D"%temp%\DLC1Temp" "GPUZ.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "GPUZ.exe"