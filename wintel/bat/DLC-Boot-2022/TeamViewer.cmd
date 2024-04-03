@echo off
pushd "%~dp0"

if exist X:\I386\explorer.exe goto runminixp

if exist "%temp%\DLC1Temp\TeamViewer\TeamViewer.exe" goto runready
:run
7z.exe x -o"%temp%\DLC1Temp\TeamViewer" -y files\TeamViewer.7z
start "" /D"%temp%\DLC1Temp\TeamViewer" "TeamViewer.exe"
exit


:runminixp
if exist "%temp%\DLC1Temp\TeamViewer\TeamViewer.exe" goto runready
7z.exe x -o"%temp%\DLC1Temp\TeamViewer" -y files\TeamViewer6.7z
start "" /D"%temp%\DLC1Temp\TeamViewer" "TeamViewer.exe"
exit
:runreadymini
start "" /D"%temp%\DLC1Temp\TeamViewer" "TeamViewer.exe"
exit