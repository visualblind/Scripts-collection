@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\TNAntiM4NamesExcel.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\TNAntiM4NamesExcel.7z
start "" /D"%temp%\DLC1Temp" "TNAntiM4NamesExcel.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "TNAntiM4NamesExcel.exe"