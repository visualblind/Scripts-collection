@echo off
pushd "%~dp0"

if exist X:\I386\explorer.exe goto runminiwinxp

:32bit
if exist "%temp%\DLC1Temp\ActivePartitionRecovery\ActivePartitionRecovery.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\ActivePartitionRecovery" -y files\ActivePartitionRecovery.7z
rem copy "%temp%\DLC1Temp\ActivePartitionRecovery\winmm32.dll" "%temp%\DLC1Temp\ActivePartitionRecovery\winmm.dll" /y 
start "" /D"%temp%\DLC1Temp\ActivePartitionRecovery" "ActivePartitionRecovery.exe"
exit
:a32
start "" /D"%temp%\DLC1Temp\ActivePartitionRecovery" "ActivePartitionRecovery.exe"
exit

:runminiwinxp
if exist "%temp%\DLC1Temp\ActivePartitionRecovery\ActivePartitionRecovery.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ActivePartitionRecovery" -y files\ActivePartitionRecoveryMiniXP.7z
7z.exe x -o"%temp%\DLC1Temp\ActivePartitionRecovery" -y files\ActiveRunMiniXP.7z
start "" /D"%temp%\DLC1Temp\ActivePartitionRecovery" "ActivePartitionRecovery.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\ActivePartitionRecovery" "ActivePartitionRecovery.exe"
exit