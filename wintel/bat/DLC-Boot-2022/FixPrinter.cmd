@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\FixPrinter\FixPrinter.cmd" goto a
7z.exe x -o"%temp%\DLC1Temp\FixPrinter" -y files\FixPrinter.7z
start "" /D"%temp%\DLC1Temp\FixPrinter" "FixPrinter.cmd"
exit
:a
start "" /D"%temp%\DLC1Temp\FixPrinter" "FixPrinter.cmd"
exit