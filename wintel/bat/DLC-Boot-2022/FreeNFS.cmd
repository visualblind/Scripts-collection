@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\FreeNFS.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y Need\FreeNFS.7z
start "" /D"%temp%\DLC1Temp" "FreeNFS.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "FreeNFS.exe"