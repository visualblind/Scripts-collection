@echo off
pushd "%~dp0"

Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry%  | Find /i "x86" 
if %ERRORLEVEL% == 0 (
    goto 32Bit
) else (
    goto 64Bit
)

:32Bit
if exist "%temp%\DLC1Temp\GetData\GetDataBackSimple.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\GetData" -y files\GetDataBackSimple.7z
CHDIR /D "%temp%\DLC1Temp\GetData"
REG IMPORT Registerx86.reg
start "" /D"%temp%\DLC1Temp\GetData" "GetDataBackSimple.exe"
exit

:64Bit
if exist "%temp%\DLC1Temp\GetData\GetDataBackSimple.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\GetData" -y files\GetDataBackSimple.7z
CHDIR /D "%temp%\DLC1Temp\GetData"
REG IMPORT Registerx64.reg
start "" /D"%temp%\DLC1Temp\GetData" "GetDataBackSimple.exe"
exit

:a
start "" /D"%temp%\DLC1Temp\GetData" "GetDataBackSimple.exe"