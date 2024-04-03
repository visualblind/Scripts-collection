@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64bit

:32bit
if exist "%temp%\DLC1Temp\Dism\Dism++x86.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\Dism\" -y files\Dism.7z
start "" /D"%temp%\DLC1Temp\Dism\" "Dism++x86.exe"
exit

:a32
start "" /D"%temp%\DLC1Temp\Dism\" "Dism++x86.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\Dism\Dism++x64.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\Dism\" -y files\Dism.7z
start "" /D"%temp%\DLC1Temp\Dism\" "Dism++x64.exe"
exit


:a64
start "" /D"%temp%\DLC1Temp\Dism\" "Dism++x64.exe"
exit
