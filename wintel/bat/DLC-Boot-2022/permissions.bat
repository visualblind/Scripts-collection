rem Code check Permissions take from E2B. Thanks to Steve Si.

:check_Permissions
set randname=%random%%random%%random%%random%%random%
md "%windir%\%randname%" 2>nul
if %errorlevel%==0 goto :end
if %errorlevel%==1 (
	echo Please use right click - Run as administrator
	color 4f& pause>nul
	Set ADMIN=FAIL
	goto :end
)
goto :check_Permissions
:end
rd "%windir%\%randname%" 2>nul
goto :EOF