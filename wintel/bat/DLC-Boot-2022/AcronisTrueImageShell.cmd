@echo off
pushd "%~dp0"
rem if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runati
rem if exist %SystemRoot%\AcronisTrueImageHome.ico goto runati
rem start msgbox "Sorry but this only works from Mini Windows XP or Mini Windows 8" 0 "OS Errors"
rem exit

:runati
if exist "%temp%\DLC1Temp\AcronisTrueImageHome2019\AcronisTrueImageHome2019.exe" goto run2017
start msgbox "You must run Acronis True Image 2017 before run Acronis True Image Shell" 0 "Run Errors"
exit

:run2017
if exist %SystemRoot%\SysWOW64\wdscore.dll goto run2017x64
7z.exe x -o"%temp%\DLC1Temp\AcronisTrueImageHome2019" -y files\AcronisTrueImageShellx86.7z
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2019" "TIBShell.cmd"
cls
echo Now you can open tib file in explorer
pause >nul
exit

:run2017x64
7z.exe x -o"%temp%\DLC1Temp\AcronisTrueImageHome2019" -y files\AcronisTrueImageShellx64.7z
start "" /D"%temp%\DLC1Temp\AcronisTrueImageHome2019" "TIBShell.cmd"
cls
echo Now you can open tib file in explorer
pause >nul
exit