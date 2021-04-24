set USERDIRS=c:\path\to\Userhome
for /f "tokens=*" %%a in ('dir /ad /b ^"%USERDIRS%^"') do (
   takeown /R /A /F "%USERDIRS%\%%a" /D Y
   xcacls "%USERDIRS%\%%a" /T /E /P Administrators:F
   xcacls "%USERDIRS%\%%a" /T /E /P SYSTEM:F
   xcacls "%USERDIRS%\%%a" /T /E /P %%a:F
   subinacl.exe /noverbose /file "%USERDIRS%\%%a" /setowner=%%a
   subinacl.exe /noverbose /subdirectories "%USERDIRS%\%%a\*" /setowner=%%a
)