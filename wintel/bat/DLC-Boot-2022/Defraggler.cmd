@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\Defraggler\Defraggler.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\Defraggler" -y files\Defraggler.7z
CHDIR /D "%temp%\DLC1Temp\Defraggler"
start "" /D"%temp%\DLC1Temp\Defraggler" "Defraggler.exe"
exit
:a
CHDIR /D "%temp%\DLC1Temp\Defraggler"
start "" /D"%temp%\DLC1Temp\Defraggler" "Defraggler.exe"
exit
