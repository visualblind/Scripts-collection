# PowerShell get-service
# Determine whether or not a service is running as a parameter

SET PS=powershell -nologo -command 

%PS% "& {if((get-service SvcName).Status -eq 'Running'){exit 1}}"
ECHO.%ERRORLEVEL%