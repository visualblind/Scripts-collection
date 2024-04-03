@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runminiwin
if exist %SystemRoot%\AcronisTrueImageHome.ico goto runminiwin

if exist "%temp%\DLC1Temp\SumatraPDF.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\SumatraPDF.7z
start "" /D"%temp%\DLC1Temp" "SumatraPDF.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "SumatraPDF.exe"
exit

:runminiwin
if exist "%temp%\DLC1Temp\SumatraPDF.exe" goto b
7z.exe x -o"%temp%\DLC1Temp" -y files\SumatraPDF.7z
start "" /D"%temp%\DLC1Temp" "SumatraPDF.exe" %*
exit
:b
start "" /D"%temp%\DLC1Temp" "SumatraPDF.exe" %*