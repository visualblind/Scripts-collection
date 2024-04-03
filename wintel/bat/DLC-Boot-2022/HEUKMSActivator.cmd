@echo off
pushd "%~dp0"

if exist "%PUBLIC%" (
goto win78
)

if exist "%temp%\DLC1Temp\HEUKMSActivator\HEU_KMS_Activator.exe" goto axp
7z.exe x -o"%temp%\DLC1Temp\HEUKMSActivator\" -y files\HEUKMSActivator.7z -p123
start "" /D"%temp%\DLC1Temp\HEUKMSActivator\" "HEU_KMS_Activator.exe"
exit
:axp
start "" /D"%temp%\DLC1Temp\HEUKMSActivator\" "HEU_KMS_Activator.exe"
exit

:win78
if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64Bit
rem Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
rem REG.exe Query %RegQry%  | Find /i "x86" 
rem if %ERRORLEVEL% == 0 (
rem     goto 32Bit
rem ) else (
rem     goto 64Bit
rem )

:32Bit
if exist "%temp%\DLC1Temp\HEUKMSActivator\HEU_KMS_Activator.exe" goto a78x86
7z.exe x -o"%temp%\DLC1Temp\HEUKMSActivator\" -y files\HEUKMSActivator.7z -p123
start "" /D"%temp%\DLC1Temp\HEUKMSActivator\" "HEU_KMS_Activator.exe"
exit
:a78x86
start "" /D"%temp%\DLC1Temp\HEUKMSActivator\" "HEU_KMS_Activator.exe"
exit

:64Bit
if exist "%temp%\DLC1Temp\HEUKMSActivator\HEU_KMS_Activator.exe" goto a78x64
7z.exe x -o"%temp%\DLC1Temp\HEUKMSActivator\" -y files\HEUKMSActivator.7z -p123
start "" /D"%temp%\DLC1Temp\HEUKMSActivator\" "HEU_KMS_Activator.exe"
exit
:a78x64
start "" /D"%temp%\DLC1Temp\HEUKMSActivator\" "HEU_KMS_Activator.exe"
exit