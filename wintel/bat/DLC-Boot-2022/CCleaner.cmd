@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto x64

:x86
if exist "%temp%\DLC1Temp\CCleaner\CCleaner.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\CCleaner" -y files\CCleanerx86.7z
start "" /D"%temp%\DLC1Temp\CCleaner" "CCleaner.exe"
exit

:x64
::================================================================================================
:: Run Script as Administrator

set _Args=%*
if "%~1" NEQ "" (
  set _Args=%_Args:"=%
)
fltmc 1>nul 2>nul || (
  cd /d "%~dp0"
  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0"" ""%_Args%""", "", "runas", 1 > "%temp%\GetAdmin.vbs"
  "%temp%\GetAdmin.vbs"
  del /f /q "%temp%\GetAdmin.vbs" 1>nul 2>nul
  exit
)

::================================================================================================

@SHIFT /0

CLS

TITLE Piriform Blocker Key Verificator

color a

ECHO.
ECHO  - Piriform Blocker Key Verificator...
ECHO.
ECHO  - Editing the hosts file with string "127.0.0.1                   license.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   www.license.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   speccy.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   www.speccy.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   recuva.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   www.recuva.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   defraggler.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   www.defraggler.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   ccleaner.piriform.com"
ECHO  - Editing the hosts file with string "127.0.0.1                   www.ccleaner.piriform.com" 
ECHO  - Editing the hosts file with string "127.0.0.1                   license-api.ccleaner.com"

rem timeout -1

takeown /f "%SystemRoot%\System32\drivers\etc\hosts" /a

icacls "%SystemRoot%\System32\drivers\etc\hosts" /grant administrators:F

attrib -h -r -s "%SystemRoot%\System32\drivers\etc\hosts"

SET NEWLINE=^& echo.

FIND /C /I "# Piriform Blocker Key Verificator" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^# Piriform Blocker Key Verificator>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "license.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   license.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "www.license.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   www.license.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "speccy.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   speccy.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "www.speccy.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   www.speccy.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "recuva.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   recuva.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "www.recuva.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   www.recuva.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "defraggler.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   defraggler.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "www.defraggler.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   www.defraggler.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "ccleaner.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   ccleaner.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "www.ccleaner.piriform.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   www.ccleaner.piriform.com>>%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "license-api.ccleaner.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO ^127.0.0.1                   license-api.ccleaner.com>>%WINDIR%\system32\drivers\etc\hosts

attrib +h +r +s "%SystemRoot%\system32\drivers\etc\hosts"

if exist "%temp%\DLC1Temp\CCleaner\CCleaner.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\CCleaner" -y files\CCleanerx64.7z
start "" /D"%temp%\DLC1Temp\CCleaner" "CCleaner.exe"
exit

:a
start "" /D"%temp%\DLC1Temp\CCleaner" "CCleaner.exe"