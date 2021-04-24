@ECHO ON
set IS_ELEVATED=0
whoami /groups | findstr /b /c:"Mandatory Label\High Mandatory Level" | findstr /c:"Enabled group" > nul: && set IS_ELEVATED=1
if %IS_ELEVATED%==0 (
    echo You must run the command prompt as administrator to install.
    exit /b 1
)


#OR


openfiles >nul 2>&1
if %ErrorLevel% equ 0 ( echo Administrator ) else ( echo NOT Administrator )