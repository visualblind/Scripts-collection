@echo off
pushd "%~dp0"

if exist X:\I386\explorer.exe goto runminiwinxp

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64bit

:32bit
if exist "%temp%\DLC1Temp\ActiveFileRecovery\ActiveFileRecovery.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\ActiveFileRecovery" -y files\ActiveFileRecoveryx86.7z
start "" /D"%temp%\DLC1Temp\ActiveFileRecovery" "ActiveFileRecovery.exe"
exit
:a32
start "" /D"%temp%\DLC1Temp\ActiveFileRecovery" "ActiveFileRecovery.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\ActiveFileRecovery\ActiveFileRecovery.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\ActiveFileRecovery" -y files\ActiveFileRecoveryx64.7z
start "" /D"%temp%\DLC1Temp\ActiveFileRecovery" "ActiveFileRecovery.exe"
exit
:a64
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