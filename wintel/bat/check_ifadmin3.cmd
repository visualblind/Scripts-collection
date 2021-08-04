whoami /groups | find "12288" && echo Elevated

or

whoami /groups | find "12288" || echo Not Elevated

or:

WHOAMI /GROUPS | FIND "12288" >NUL & SET /A Elevated = 1 - ErrorLevel


AT > NUL
IF %ERRORLEVEL% EQU 0 (
    ECHO you are Administrator 
) ELSE (
    ECHO you are NOT Administrator. Exiting...
    PING 127.0.0.1 > NUL 2>&1
    EXIT /B 1
)