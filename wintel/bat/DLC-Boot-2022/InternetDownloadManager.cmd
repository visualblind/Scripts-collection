@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runminixp
if exist %SystemRoot%\AcronisTrueImageHome.ico goto runmini78
if exist "%temp%\DLC1Temp\Internet Download Manager\InternetDownloadManager.exe" goto runready
:run
7z.exe x -o"%temp%\DLC1Temp\Internet Download Manager" -y files\InternetDownloadManager.7z
CHDIR /D "%temp%\DLC1Temp\Internet Download Manager"
REG IMPORT Reg.reg
start "" /D"%temp%\DLC1Temp\Internet Download Manager" "InternetDownloadManager.exe"
exit
:runready
start "" /D"%temp%\DLC1Temp\Internet Download Manager" "InternetDownloadManager.exe"
exit

:runminixp
if exist "%temp%\DLC1Temp\Internet Download Manager\InternetDownloadManager.exe" goto runready
if exist "%temp%\PENMDebug.txt" goto axp
reg add HKLM\Software\PENetwork /v CloseAfterStartnet /d 1 /f
start "" /D"%SystemRoot%\System32" "penetwork.exe"
nircmd waitprocess penetwork.exe
reg delete HKLM\Software\PENetwork /v CloseAfterStartnet /f
:axp
7z.exe x -o"%temp%\DLC1Temp\Internet Download Manager" -y files\InternetDownloadManager.7z
CHDIR /D "%temp%\DLC1Temp\Internet Download Manager"
REG IMPORT Reg.reg
attrib -r -h -s "%windir%\system32\drivers\etc\hosts"
>>"%windir%\system32\drivers\etc\hosts" echo.
>>"%windir%\system32\drivers\etc\hosts" echo 0.0.0.0 www.internetdownloadmanager.com
>>"%windir%\system32\drivers\etc\hosts" echo 207.44.199.159 registeridm.com
>>"%windir%\system32\drivers\etc\hosts" echo 207.44.199.16 registeridm.com
start "" /D"%temp%\DLC1Temp\Internet Download Manager" "InternetDownloadManager.exe"
nircmd cmdwait 5000 killprocess rundll32.exe
exit

:runmini78
if exist "%temp%\DLC1Temp\Internet Download Manager\InternetDownloadManager.exe" goto runready
if exist "%SystemRoot%\System32\CheckNetwork" goto run7
echo.
echo Wait for turn on Network....
echo Please don't click in this black screen
echo.
echo Dang tien hanh kich hoat mang....
echo Vui long khong nhap chuot vao man hinh den nay
start /wait X:\Windows\System32\PECMD.EXE Load X:\Windows\system32\PE_NET-Media.INI
:run7
7z.exe x -o"%temp%\DLC1Temp\Internet Download Manager" -y files\InternetDownloadManager.7z
CHDIR /D "%temp%\DLC1Temp\Internet Download Manager"
REG IMPORT Reg.reg
attrib -r -h -s "%windir%\system32\drivers\etc\hosts"
>>"%windir%\system32\drivers\etc\hosts" echo.
>>"%windir%\system32\drivers\etc\hosts" echo 0.0.0.0 www.internetdownloadmanager.com
>>"%windir%\system32\drivers\etc\hosts" echo 207.44.199.159 registeridm.com
>>"%windir%\system32\drivers\etc\hosts" echo 207.44.199.16 registeridm.com
start "" /D"%temp%\DLC1Temp\Internet Download Manager" "InternetDownloadManager.exe"
exit