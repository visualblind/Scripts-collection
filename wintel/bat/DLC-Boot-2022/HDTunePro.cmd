@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\HDTunePro\HDTunePro.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\HDTunePro" -y files\HDTunePro.7z
CHDIR /D "%temp%\DLC1Temp\HDTunePro"
REG IMPORT Reg.reg
start "" /D"%temp%\DLC1Temp\HDTunePro" "HDTunePro.exe"
REM "%temp%\DLC1Temp\HDTunePro\CDKey.txt"
exit
:a
start "" /D"%temp%\DLC1Temp\HDTunePro" "HDTunePro.exe"
REM "%temp%\DLC1Temp\HDTunePro\CDKey.txt"