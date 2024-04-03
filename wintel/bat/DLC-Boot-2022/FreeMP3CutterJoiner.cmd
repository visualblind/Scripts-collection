@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\FreeMP3CutterJoiner\FreeMP3CutterJoiner.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\FreeMP3CutterJoiner" -y files\FreeMP3CutterJoiner.7z
start "" /D"%temp%\DLC1Temp\FreeMP3CutterJoiner" "FreeMP3CutterJoiner.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\FreeMP3CutterJoiner" "FreeMP3CutterJoiner.exe"