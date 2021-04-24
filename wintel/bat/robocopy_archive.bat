for /f "tokens=1-4 delims=/-. " %%i in ('date /t') do (call :set_date %%i %%j %%k %%l)
goto :end_set_date

:set_date
if "%1:~0,1%" gtr "9" shift
for /f "skip=1 tokens=2-4 delims=(-)" %%m in ('echo,^|date') do (set %%m=%1&set %%n=%2&set %%o=%3)
goto :eof

:end_set_date
::: End set date
robocopy c:\torrent-downloads F:\OneDrive\torrent-downloads /E /MOVE /MINAGE:10 /R:5 /W:10 /LOG:%userprofile%\Documents\robocopy_%mm%_%dd%_%yy%.txt
echo "Done!"
exit
