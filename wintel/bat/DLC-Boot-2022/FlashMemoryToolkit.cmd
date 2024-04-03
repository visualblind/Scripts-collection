@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\FlashMemoryToolkit\FlashMemoryToolkit.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\FlashMemoryToolkit" -y files\FlashMemoryToolkit.7z
CHDIR /D "%temp%\DLC1Temp\FlashMemoryToolkit"
REG IMPORT Reg.reg
start "" /D"%temp%\DLC1Temp\FlashMemoryToolkit" "FlashMemoryToolkit.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "FlashMemoryToolkit\FlashMemoryToolkit.exe"