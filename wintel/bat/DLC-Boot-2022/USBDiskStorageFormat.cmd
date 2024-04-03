@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\USBDiskStorageFormat\USBDiskStorageFormat.cmd" goto a
7z.exe x -o"%temp%\DLC1Temp\USBDiskStorageFormat\" -y files\USBDiskStorageFormat.7z
start "" /D"%temp%\DLC1Temp\USBDiskStorageFormat\" "USBDiskStorageFormat.cmd"
exit
:a
start "" /D"%temp%\DLC1Temp\USBDiskStorageFormat\" "USBDiskStorageFormat.cmd"