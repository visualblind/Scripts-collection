@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runminixp
if exist %SystemRoot%\AcronisTrueImageHome.ico goto runmini78

if exist "%temp%\DLC1Temp\VLC\VLCMediaPlayer.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\VLC" -y files\VLCMediaPlayer.7z
start "" /D"%temp%\DLC1Temp\VLC" "VLCMediaPlayer.exe"
exit

:a
start "" /D"%temp%\DLC1Temp" "VLC\VLCMediaPlayer.exe"
exit

:runminixp
if exist "%temp%\DLC1Temp\VLC\VLC.exe" goto axp
7z.exe x -o"%temp%\DLC1Temp\VLC" -y files\VLCMediaPlayer.7z
start "" /D"%temp%\DLC1Temp\VLC" "VLCMediaPlayer.exe" %*
exit

:axp
start "" /D"%temp%\DLC1Temp\VLC" "VLCMediaPlayer.exe" %*
exit

:runmini78
if exist "%temp%\DLC1Temp\VLC\VLCMediaPlayer.exe" goto b
if exist "%SystemRoot%\System32\CheckNetwork" goto run
echo.


:run
7z.exe x -o"%temp%\DLC1Temp\VLC" -y files\VLCMediaPlayer.7z
start "" /D"%temp%\DLC1Temp\VLC" "VLCMediaPlayer.exe" %*
exit

:b
start "" /D"%temp%\DLC1Temp" "VLC\VLCMediaPlayer.exe" %*
exit