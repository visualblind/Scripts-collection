@echo off
pushd "%~dp0"

:MAIN
if exist X:\I386\explorer.exe goto runminiwin
if exist X:\bootmgr goto runminiwin
start msgbox "Sorry but this only works from Mini Windows XP or Mini Windows 10" 0 "OS Errors"
exit

:runminiwin
if exist %SystemRoot%\SysWOW64\wdscore.dll goto x64
:x86
if exist "%temp%\DLC1Temp\AcronisTrueImageHome2014\atihxp.cmd" goto a86
7z.exe x -o"%temp%\DLC1Temp\AcronisTrueImageHome2014" -y files\AcronisTrueImageHome2014.7z
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2014" "atihxp.cmd"
exit

:a86
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2014" "atihxp.cmd"
exit

:x64
if exist "%temp%\DLC1Temp\AcronisTrueImageHome2014\atih.cmd" goto a64
7z.exe x -o"%temp%\DLC1Temp\AcronisTrueImageHome2014" -y files\AcronisTrueImageHome2014.7z
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2014" "atih.cmd"
exit

:a64
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2014" "atih.cmd"
exit