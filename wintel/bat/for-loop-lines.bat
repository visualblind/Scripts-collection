
for /F "tokens=1,2*" %%i in (robocopy-paths.bat) do call :process %%i %%j %%k
goto thenextstep
:process
set VAR1=%1
set VAR2=%2
set VAR3=%3
set VAR4=%4
COMMANDS TO PROCESS INFORMATION
goto :EOF