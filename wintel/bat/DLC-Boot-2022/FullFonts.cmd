echo off
for %%F in (C D E F G H I J K L M N O P Q S T U V W Y Z) do (If /i Exist "%%F:\Windows\Fonts\arial.ttf" set FONTS=%%F:&goto fullfonts)
echo No any Windows System install on this PC
echo Can't load Full Fonts
pause
exit

:fullfonts
REM 7z.exe x -o"%FONTS%\Windows\Fonts" -y %DLC1%\DLC1\Programs\Files\FontReg.7z
copy /y FontReg.exe %FONTS%\Windows\Fonts
nircmd exec min %FONTS%\Windows\Fonts\FontReg /copy
del /a /f /q %FONTS%\Windows\Fonts\FontReg.exe
nircmd sysrefresh
nircmd sysrefresh environment
start msgbox "Complete Load Full Fonts for Mini Windows. Click OK for Exit." 0 "Finish Load Fonts"
exit