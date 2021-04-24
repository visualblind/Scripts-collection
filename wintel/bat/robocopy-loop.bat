@ECHO OFF
cd /d %~dp0

::: Generate reproducable new line variable
set nl=^&echo.

for /F "tokens=1-4 delims=/-. " %%i in ('date /t') do (call :set_date %%i %%j %%k %%l)
goto :end_set_date

:set_date
if "%1:~0,1%" gtr "9" shift
for /F "skip=1 tokens=2-4 delims=(-)" %%m in ('echo,^|date') do (set %%m=%1&set %%n=%2&set %%o=%3)
goto :eof
:end_set_date
::: End set date

for /F "eol=; tokens=1,2* delims=," %%i in (robocopy-paths.txt) do (call :process %%i %%j %%k)
goto :eof
:process
start /B robocopy %1 %2 %3 %4 %5 %6 %7 %8 %9
::: More error handling: || echo FAILED: %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
set exit_code=%ERRORLEVEL%
IF ERRORLEVEL 1 (  
    echo FAILED: %1 %2 %3 %4 %5 %6 %7 %8 %9, return code = %exit_code%
    exit /b %exit_code%
)
exit /b %exit_code%
goto :eof

