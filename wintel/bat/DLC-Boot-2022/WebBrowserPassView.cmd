@pushd "%~dp0"
if exist "%temp%\DLC1Temp\WebBrowserPassView\WebBrowserPassView.exe" goto a
@7z.exe x -o"%temp%\DLC1Temp\WebBrowserPassView" -y Files\WebBrowserPassView.7z
@start "" /D"%temp%\DLC1Temp\WebBrowserPassView" "WebBrowserPassView.exe"
exit

:a
@start "" /D"%temp%\DLC1Temp\WebBrowserPassView" "WebBrowserPassView.exe"