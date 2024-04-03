@echo off
pushd "%~dp0"

if exist X:\I386\explorer.exe goto runminiwinxp

:32bit
if exist "%temp%\DLC1Temp\ActiveFileRecovery\ActiveFileRecovery.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\ActiveFileRecovery" -y files\ActiveFileRecovery.7z
rem copy "%temp%\DLC1Temp\ActiveFileRecovery\winmm32.dll" "%temp%\DLC1Temp\ActiveFileRecovery\winmm.dll" /y 
start "" /D"%temp%\DLC1Temp\ActiveFileRecovery" "ActiveFileRecovery.exe"
exit
:a32
start "" /D"%temp%\DLC1Temp\ActiveFileRecovery" "ActiveFileRecovery.exe"
exit

:runminiwinxp
if exist "%temp%\DLC1Temp\ActiveFileRecovery\ActiveFileRecovery.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ActiveFileRecovery" -y files\ActiveFileRecoveryMiniXP.7z
7z.exe x -o"%temp%\DLC1Temp\ActiveFileRecovery" -y files\ActiveRunMiniXP.7z
start "" /D"%temp%\DLC1Temp\ActiveFileRecovery" "ActiveFileRecovery.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\ActiveFileRecovery" "ActiveFileRecovery.exe"
exit