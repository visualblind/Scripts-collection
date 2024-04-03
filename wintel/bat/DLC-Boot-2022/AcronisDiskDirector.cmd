@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\AcronisDiskDirector\adds2012.cmd" goto a
7z.exe x -o"%temp%\DLC1Temp\AcronisDiskDirector" -y files\AcronisDiskDirector.7z
start "" /D"%temp%\DLC1Temp\AcronisDiskDirector" "adds2012.cmd"
exit

:a
start "" /D"%temp%\DLC1Temp\AcronisDiskDirector" "DiskDirector.exe"
exit