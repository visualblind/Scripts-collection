@echo off
pushd "%~dp0"

if exist X:\I386\explorer.exe goto runminiwinxp

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64bit

:32bit
if exist "%temp%\DLC1Temp\ActivePartitionRecovery\ActivePartitionRecovery.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\ActivePartitionRecovery" -y files\ActivePartitionRecoveryx86.7z
start "" /D"%temp%\DLC1Temp\ActivePartitionRecovery" "ActivePartitionRecovery.exe"
exit
:a32
start "" /D"%temp%\DLC1Temp\ActivePartitionRecovery" "ActivePartitionRecovery.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\ActivePartitionRecovery\ActivePartitionRecovery.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\ActivePartitionRecovery" -y files\ActivePartitionRecoveryx64.7z
start "" /D"%temp%\DLC1Temp\ActivePartitionRecovery" "ActivePartitionRecovery.exe"
exit
:a64
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