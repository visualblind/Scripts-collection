@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\ReloaderActivator\ReLoaderByR1n.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ReloaderActivator\" -y files\ReloaderActivator.7z -p123
start "" /D"%temp%\DLC1Temp\ReloaderActivator\" "ReLoaderByR1n.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\ReloaderActivator\" "ReLoaderByR1n.exe"
exit