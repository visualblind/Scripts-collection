@echo off
set WHOAMI_EXE=%windir%\system32\whoami.exe

if NOT exist "%WHOAMI_EXE%" (
   echo WARNING: could not verify that the user has Administrative privileges.
   echo Windows Server 2003 or later is required.  Windows XP x64 is also acceptable.
   pause
   exit /B 1
)

call :checkIfAdmin
if ERRORLEVEL 1 (
   echo The current account does not appear to be a member of the Administrators group.
   echo Administrative privileges are required to execute the tool.
   pause
   exit /B 1
)

:checkIfAdmin

set SAW_ADMIN_GROUP=0
for /F "tokens=3,* delims=," %%i in ('"%WHOAMI_EXE%" /groups /fo csv') DO (
   if "%%i"==""S-1-5-32-544"" (
      set SAW_ADMIN_GROUP=1
   )
)

if "%SAW_ADMIN_GROUP%"=="0" (
   echo ERROR: The current account does not appear to be a member of the Administrators group.
   exit /B 1
)