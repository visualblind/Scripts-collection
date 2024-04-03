@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\SoftPerfectNetworkScanner\SoftPerfectNetworkScanner.exe" (
rd /s /q "%temp%\DLC1Temp\SoftPerfectNetworkScanner"
)

7z.exe x -o"%temp%\DLC1Temp\SoftPerfectNetworkScanner" -y files\SoftPerfectNetworkScanner.7z
start "" /D"%temp%\DLC1Temp\SoftPerfectNetworkScanner" "SoftPerfectNetworkScanner.exe"