for /f "EOL=\n tokens=*" %%i in ("%path%") do set a=%%i && set (b=!a:;=^&echo.!)
REM then echo %b%