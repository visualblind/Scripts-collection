@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\Unlocker\UnlockerAssistant.exe" goto s
7z.exe x -o"%temp%\DLC1Temp\Unlocker" -y Files\unlocker.7z
if defined ProgramFiles(x86) (copy /y "%temp%\DLC1Temp\Unlocker\x64\*.*" "%temp%\DLC1Temp\Unlocker")
:s
start "" /D"%temp%\DLC1Temp\Unlocker" "UnlockerAssistant.exe"
echo Unlocker Assistant is running in System Tray,
echo Now you can try to delete a Locked item.
echo.
echo Press any key to EXIT
pause>nul