@ECHO OFF
REM testing at cmd : sc query "MSSQLSERVER" | findstr RUNNING
REM "MSSQLSERVER" is the name of Service for sample
:: comment test
sc query "MSSQLSERVER" %1 | findstr RUNNING
if %ERRORLEVEL% == 2 goto trouble
if %ERRORLEVEL% == 1 goto stopped
if %ERRORLEVEL% == 0 goto started
echo unknown status
goto end
:trouble
echo Oh noooo.. trouble mas bro
goto end
:started
echo "SQL Server (MSSQLSERVER)" is started
goto end
:stopped
echo "SQL Server (MSSQLSERVER)" is stopped
echo Starting service
net start "MSSQLSERVER"
goto end
:erro
echo Error please check your command.. mas bro 
goto end

:end