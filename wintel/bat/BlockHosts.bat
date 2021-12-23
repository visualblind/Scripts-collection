attrib -r %WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

FIND /C /I "www.link-assistant.com#" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^	127.0.0.1	www.link-assistant.com#>>%WINDIR%\system32\drivers\etc\hosts
