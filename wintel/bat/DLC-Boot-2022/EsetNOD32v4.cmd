@echo off
PUSHD %~dp0

:MAIN
if exist X:\I386\explorer.exe goto runminiwin
if exist X:\setup.exe goto runminiwin
start msgbox "Sorry but this only works from Mini Windows" 0 "OS Errors"
exit

:runminiwin
cd /d "..\..\"
for /F "eol= delims=~" %%d in ('CD') do set source=%%d
if exist "%source%\Boot\cd.c32" goto notrunoncd

if exist "X:\Windows\SysWOW64\wdscore.dll" goto x64

:x86
start "" /D"%source%\Programs\Windows\Files\EsetNOD32v4x86" "EsetNOD32v4.cmd"
exit

:x64
start "" /D"%source%\Programs\Windows\Files\EsetNOD32v4x64" "EsetNOD32v4.cmd"
exit

:notrunoncd
start msgbox "Sorry but this not run on CD" 0 "Run Errors"
exit

