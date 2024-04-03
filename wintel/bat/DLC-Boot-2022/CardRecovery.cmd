@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\CardRecovery\CardRecovery.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\CardRecovery" -y files\CardRecovery.7z
CHDIR /D "%temp%\DLC1Temp\CardRecovery"
REG IMPORT Reg.reg
start "" /D"%temp%\DLC1Temp\CardRecovery" "CardRecovery.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "CardRecovery\CardRecovery.exe"