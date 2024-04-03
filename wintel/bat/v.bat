for /f "tokens=2 delims=[]" %%i in ('ver') do set verstr=%%i 
for /f "tokens=2" %%i in ('echo %verstr%') do set vernumstr=%%i 
for /F "tokens=1 delims=." %%i in ('echo %vernumstr%') do set maj=%%i 
Exit /B %maj% 
