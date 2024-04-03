@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\QemuSimpleBoot\Qsib.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\QemuSimpleBoot" -y files\QemuSimpleBoot.7z
start "" /D"%temp%\DLC1Temp\QemuSimpleBoot" "Qsib.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\QemuSimpleBoot" "Qsib.exe"