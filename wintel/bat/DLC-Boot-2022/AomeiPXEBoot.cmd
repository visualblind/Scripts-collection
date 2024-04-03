@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\AomeiPXEBoot\PXEBoot.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\AomeiPXEBoot" -y files\AomeiPXEBoot.7z
start "" /D"%temp%\DLC1Temp\AomeiPXEBoot" "PXEBoot.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\AomeiPXEBoot" "PXEBoot.exe"