@echo off
Title DLC Boot 2017 Menu for Windows XP on HDD - DLC Corporation

attrib -r -h -s "%HomeDrive%\boot.ini" >nul 2>nul
copy /y %HomeDrive%\boot.ini %HomeDrive%\DLC1\boot.ini
>>"%HomeDrive%\boot.ini" echo.
>>"%HomeDrive%\boot.ini" echo %HomeDrive%\dlc.mbr="DLC Boot 2017"
echo bootcfg /timeout 3&&bootcfg /timeout 3
echo.
attrib +r +h +s "%HomeDrive%\boot.ini"