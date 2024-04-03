@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\FreeVideoCutterJoiner\FreeVideoCutterJoiner.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\FreeVideoCutterJoiner" -y files\FreeVideoCutterJoiner.7z
start "" /D"%temp%\DLC1Temp\FreeVideoCutterJoiner" "FreeVideoCutterJoiner.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\FreeVideoCutterJoiner" "FreeVideoCutterJoiner.exe"