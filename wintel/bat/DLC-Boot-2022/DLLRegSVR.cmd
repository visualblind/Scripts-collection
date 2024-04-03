@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto x64

:x86
if exist "%temp%\DLC1Temp\dllregsvr.exe" goto a86
7z.exe x -o"%temp%\DLC1Temp\dllregsvr" -y files\DLLRegSVRx86.7z
start "" /D"%temp%\DLC1Temp\dllregsvr" "dllregsvr.exe"
exit
:a86
start "" /D"%temp%\DLC1Temp\dllregsvr" "dllregsvr.exe"
exit

:x64
if exist "%temp%\DLC1Temp\dllregsvr\dllregsvr64.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\dllregsvr" -y files\DLLRegSVRx64.7z
start "" /D"%temp%\DLC1Temp\dllregsvr" "dllregsvr64.exe"
exit

:a64
start "" /B /D"%temp%\DLC1Temp\dllregsvr" "dllregsvr64.exe"
exit