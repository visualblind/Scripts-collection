@pushd "%~dp0"
if exist "%temp%\DLC1Temp\DoubleDriver\DoubleDriver.exe" goto a
@7z.exe x -o"%temp%\DLC1Temp\DoubleDriver" -y Files\DoubleDriver.7z
@start "" /D"%temp%\DLC1Temp\DoubleDriver" "DoubleDriver.exe"
exit

:a
@start "" /D"%temp%\DLC1Temp\DoubleDriver" "DoubleDriver.exe"