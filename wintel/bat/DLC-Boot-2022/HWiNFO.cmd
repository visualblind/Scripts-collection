@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\HWiNFO32\HWiNFO.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\HWiNFO32" -y files\HWiNFO.7z
start "" /D"%temp%\DLC1Temp\HWiNFO32" "HWiNFO.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\HWiNFO32" "HWiNFO.exe"