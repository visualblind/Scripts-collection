@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\UltraVNC\options.vnc" (
rd /s /q "%temp%\DLC1Temp\UltraVNC"
)

7z.exe x -o"%temp%\DLC1Temp\UltraVNC" -y Need\UltraVNC\VNCViewer810x64.7z
start "" /D"%temp%\DLC1Temp\UltraVNC" "VNCViewer810x64.exe"