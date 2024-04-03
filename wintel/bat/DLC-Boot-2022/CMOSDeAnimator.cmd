@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\CMOSDeAnimator.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\CMOSDeAnimator.7z
start "" /B /D"%temp%\DLC1Temp" "CMOSDeAnimator.exe"
exit
:a
start "" /B /D"%temp%\DLC1Temp" "CMOSDeAnimator.exe"