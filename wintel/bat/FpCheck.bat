@ECHO OFF

start /B /WAIT RunCmdX.exe CheckVersion.bat

ECHO %ERRORLEVEL% >> FPLog.txt

IF %ERRORLEVEL% NEQ 0 (GOTO FAIL)
SET EXITCODE=%ERRORLEVEL%
START /B /WAIT HTTP2GA.exe Fixpack2-078 Fixpack-D NeedUpdate
ECHO %EXITCODE% >> FpCheckLog.txt
GOTO END

:FAIL
SET EXITCODE=%ERRORLEVEL%
START /B /WAIT HTTP2GA.exe Fixpack2-078 Fixpack-D Don'tNeedUpdate
ECHO %EXITCODE% >> FpCheckLog.txt
GOTO END

:END
EXIT /B %EXITCODE%