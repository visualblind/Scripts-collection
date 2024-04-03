@echo off
pushd "%~dp0"


:start
if exist "%temp%\DLC1Temp\PassMarkKeyboardTest\KeyboardTestPortable.exe" goto ready
7z.exe x -o"%temp%\DLC1Temp\PassMarkKeyboardTest" -y files\PassMarkKeyboardTest.7z
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "KeyboardTestPortable.exe"
exit

:ready
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "KeyboardTestPortable.exe"
exit

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64Bit

:32Bit
if exist "%temp%\DLC1Temp\PassMarkKeyboardTest\PassMarkKeyboardTestRun.cmd" goto a32
7z.exe x -o"%temp%\DLC1Temp\PassMarkKeyboardTest" -y files\PassMarkKeyboardTest.7z
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "KeyboardTest.exe"
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "serial.txt"
exit

:a32
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "KeyboardTest.exe"
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "serial.txt"
exit

:64Bit
if exist "%temp%\DLC1Temp\PassMarkKeyboardTest\PassMarkKeyboardTestx64.cmd" goto a64
7z.exe x -o"%temp%\DLC1Temp\PassMarkKeyboardTest" -y files\PassMarkKeyboardTest.7z
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "KeyboardTest64.exe"
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "serial.txt"
exit

:a64
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "KeyboardTest64.exe"
start "" /D"%temp%\DLC1Temp\PassMarkKeyboardTest" "serial.txt"
exit