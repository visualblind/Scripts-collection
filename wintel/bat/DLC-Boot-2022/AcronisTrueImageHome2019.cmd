@echo off
pushd "%~dp0"

:MAIN
if exist X:\I386\explorer.exe goto runminiwinxp
rem if exist X:\bootmgr goto runminiwin
rem start msgbox "Sorry but this only works from Mini Windows XP or Mini Windows 10" 0 "OS Errors"
rem exit

rem :runminiwin
if exist %SystemRoot%\SysWOW64\wdscore.dll goto x64
:x86
if exist "%temp%\DLC1Temp\AcronisTrueImageHome2019\acronis.cmd" goto a86
7z.exe x -o"%temp%\DLC1Temp\AcronisTrueImageHome2019" -y files\AcronisTrueImageHome2019.7z
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2019" "acronis.cmd"
exit

:a86
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2019" "acronis.cmd"
exit

:x64
if exist "%temp%\DLC1Temp\AcronisTrueImageHome2019\AcronisTrueImageHome2019.cmd" goto a64
7z.exe x -o"%temp%\DLC1Temp\AcronisTrueImageHome2019" -y files\AcronisTrueImageHome2019.7z
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2019" "AcronisTrueImageHome2019.cmd"
exit

:a64
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2019" "AcronisTrueImageHome2019.cmd"
exit



:runminiwinxp
start msgbox "Sorry but this only works from Your Windows or Mini Windows 10" 0 "OS Errors"
exit