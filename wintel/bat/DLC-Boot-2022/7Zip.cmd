@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\7Zip\7Zip.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\7Zip" -y files\7Zip.7z
start "" /D"%temp%\DLC1Temp\7Zip" "7Zip.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\7Zip" "7Zip.exe"