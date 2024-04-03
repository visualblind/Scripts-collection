@echo off
PUSHD %~dp0
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runminiwin
if exist %SystemRoot%\System32\CheckMini7 goto runminiwin
if exist %SystemRoot%\System32\CheckMini8 goto runminiwin
exit

:runminiwin
if exist "%temp%\DLC1Temp\IrfanView\i_view32.exe" goto b
7z.exe x -o"%temp%\DLC1Temp\IrfanView" -y Files\IrfanView.7z
start "" /D"%temp%\DLC1Temp\IrfanView" "i_view32.exe" %*
exit

:b
start "" /D"%temp%\DLC1Temp\IrfanView" "i_view32.exe" %*
exit