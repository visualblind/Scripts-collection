@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\HDDLowLevelFormatTool\HDDLowLevelFormatTool.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\HDDLowLevelFormatTool" -y files\HDDLowLevelFormatTool.7z
start "" /D"%temp%\DLC1Temp\HDDLowLevelFormatTool" "HDDLowLevelFormatTool.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "HDDLowLevelFormatTool.exe"