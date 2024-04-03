@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64Bit

:32bit
if exist "%temp%\DLC1Temp\VNCServer\RealVNCServer.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\VNCServer" -y files\RealVNCServerx86.7z
start "" %temp%\DLC1Temp\VNCServer\vncguihelper.exe RealVNCServer.exe -_fromGui -start -showstatus
start "" /D"%temp%\DLC1Temp\VNCServer" "Keygen.exe"
exit
:a32
start "" %temp%\DLC1Temp\VNCServer\vncguihelper.exe RealVNCServer.exe -_fromGui -start -showstatus
start "" /D"%temp%\DLC1Temp\VNCServer" "Keygen.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\VNCServer\RealVNCServer.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\VNCServer" -y files\RealVNCServerx64.7z
start "" %temp%\DLC1Temp\VNCServer\vncguihelper.exe RealVNCServer.exe -_fromGui -start -showstatus
start "" /D"%temp%\DLC1Temp\VNCServer" "Keygen.exe"
exit
:a64
start "" %temp%\DLC1Temp\VNCServer\vncguihelper.exe RealVNCServer.exe -_fromGui -start -showstatus
start "" /D"%temp%\DLC1Temp\VNCServer" "Keygen.exe"
exit