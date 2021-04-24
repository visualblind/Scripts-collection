Bootrec /scanos >"%~dp0BootFixerTest.txt"
type "%~dp0BootFixerTest.txt" |find /i "Windows installations: 0" >nul || goto :Done
Pause
:Done