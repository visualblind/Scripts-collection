@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\VNCViewer\RealVNCViewer.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\VNCViewer" -y files\RealVNCViewer.7z
start "" /D"%temp%\DLC1Temp\VNCViewer" "RealVNCViewer.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\VNCViewer" "RealVNCViewer.exe"
exit