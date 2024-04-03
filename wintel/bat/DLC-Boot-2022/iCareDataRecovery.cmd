@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\iCareDataRecovery\iCareDataRecovery.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\iCareDataRecovery" -y files\iCareDataRecovery.7z
start "" /D"%temp%\DLC1Temp\iCareDataRecovery" "iCareDataRecovery.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "iCareDataRecovery\iCareDataRecovery.exe"