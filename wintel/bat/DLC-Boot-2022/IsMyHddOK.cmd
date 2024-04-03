@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\IsMyHddOK.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\IsMyHddOK.7z
start "" /D"%temp%\DLC1Temp" "IsMyHddOK.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "IsMyHddOK.exe"