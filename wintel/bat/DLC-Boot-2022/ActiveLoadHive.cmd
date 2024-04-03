@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\ActiveLoadHive\ActiveLoadHive.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ActiveLoadHive" -y files\ActiveLoadHive.7z
start "" /D"%temp%\DLC1Temp\ActiveLoadHive" "ActiveLoadHive.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\ActiveLoadHive" "ActiveLoadHive.exe"