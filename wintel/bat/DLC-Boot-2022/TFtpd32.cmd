@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runminixp
if exist %SystemRoot%\AcronisTrueImageHome.ico goto runmini78

if exist "%temp%\DLC1Temp\TFtpd32\tftpd32.exe" goto runready
:run
7z.exe x -o"%temp%\DLC1Temp\TFtpd32" -y files\TFtpd32.7z
@copy /y ..\grldr "%temp%\DLC1Temp\TFtpd32">nul
start "" /D"%temp%\DLC1Temp\TFtpd32" "tftpd32.exe"
exit
:runready
start "" /D"%temp%\DLC1Temp\TFtpd32" "tftpd32.exe"
exit

:runminixp
if exist "%temp%\DLC1Temp\TFtpd32\tftpd32.exe" goto runready
if exist "%temp%\PENMDebug.txt" goto run
reg add HKLM\Software\PENetwork /v CloseAfterStartnet /d 1 /f
start "" /D"%SystemRoot%\System32" "penetwork.exe"
nircmd waitprocess penetwork.exe
reg delete HKLM\Software\PENetwork /v CloseAfterStartnet /f
goto run
exit

:runmini78
if exist "%temp%\DLC1Temp\TFtpd32\tftpd32.exe" goto runready
goto run
exit