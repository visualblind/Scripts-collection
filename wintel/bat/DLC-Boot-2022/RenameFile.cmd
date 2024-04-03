@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\RenameFile\RenameFile.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\RenameFile" -y files\RenameFile.7z
start "" /D"%temp%\DLC1Temp\RenameFile" "RenameFile.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\RenameFile" "RenameFile.exe"