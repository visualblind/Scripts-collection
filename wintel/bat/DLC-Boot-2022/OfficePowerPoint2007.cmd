@echo off
pushd %~dp0
SET CurDir=%CD%\
if exist "%temp%\DLC1Temp\Office2007\WINWORD.EXE" goto a
7z.exe x -o"%temp%\DLC1Temp\Office2007" -y Files\Office2007.7z
start "" /D"%temp%\DLC1Temp\Office2007" "Run.cmd"
rem if exist "%temp%\DLC1Temp\EVKey\EVKey.exe" goto readyevkey
rem EVKey.cmd
rem exit
rem :a
rem if exist "%temp%\DLC1Temp\EVKey\EVKey.exe" goto readyevkey
rem EVKey.cmd
rem exit

rem :readyevkey
exit