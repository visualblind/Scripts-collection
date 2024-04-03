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
if exist "%temp%\DLC1Temp\GetData\GetDataBackPro.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\GetData" -y files\GetDataBackPro.7z
CHDIR /D "%temp%\DLC1Temp\GetData"
REG IMPORT Regx86.reg
start "" /D"%temp%\DLC1Temp\GetData" "GetDataBackPro.exe"
exit

:64Bit
if exist "%temp%\DLC1Temp\GetData\GetDataBackPro.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\GetData" -y files\GetDataBackPro.7z
CHDIR /D "%temp%\DLC1Temp\GetData"
REG IMPORT Regx64.reg
start "" /D"%temp%\DLC1Temp\GetData" "GetDataBackPro.exe"
exit

:a
start "" /D"%temp%\DLC1Temp\GetData" "GetDataBackPro.exe"