@echo off
Title ATI Menu for Windows XP on HDD - DLC Corporation

:Start
if not exist "%HomeDrive%\ATIB\Dos\ati.iso" (
goto NotMenu
)
echo Please wait while remove menu...
attrib -r -h -s "%HomeDrive%\boot.ini"

copy /y %HomeDrive%\boot.ini %HomeDrive%\ATIB\boot.ini
del /a/f/q "%HomeDrive%\boot.ini"
ChangeCodeXP --cl  --find "%HomeDrive%\ati.mbr=\"Acronis True Image Home\"" --replace "" --fileMask "*.ini" --dir "%HomeDrive%\ATIB"
copy /y %HomeDrive%\ATIB\boot.ini %HomeDrive%\boot.ini
attrib +r +h +s "%HomeDrive%\boot.ini"
attrib -r -h -s "%HomeDrive%\ati"
attrib -r -h -s "%HomeDrive%\ati.mbr"
del /a /f /q %HomeDrive%\ati
del /a /f /q %HomeDrive%\ati.mbr
rd /s /q %HomeDrive%\ATIB
cls
start msgbox "Complete removal Menu." 0 "Complete Remove"
exit

:NotMenu
start msgbox "Menu is not installed, can not be remove." 0 "Menu Errors"
exit