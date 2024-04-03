@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\AvastRegedit\AvastRegistryEditor.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\AvastRegedit" -y files\AvastRegistryEditor.7z
start "" /D"%temp%\DLC1Temp\AvastRegedit" "AvastRegistryEditor.exe"
cls
@type ""%temp%\DLC1Temp\AvastRegedit\HuongDanREG.txt"
pause >nul
exit
:a
start "" /D"%temp%\DLC1Temp\AvastRegedit" "AvastRegistryEditor.exe"
cls
@type ""%temp%\DLC1Temp\AvastRegedit\HuongDanREG.txt"
pause >nul
exit