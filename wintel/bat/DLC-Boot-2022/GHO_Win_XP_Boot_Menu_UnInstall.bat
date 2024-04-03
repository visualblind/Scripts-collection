@echo off
Title GHOST Menu for Windows XP on HDD - DLC Corporation

:Start
if not exist "%HomeDrive%\GHOS\Dos\Ghost.ima" (
goto NotMenu
)
echo Please wait while remove menu...
attrib -r -h -s "%HomeDrive%\boot.ini"

copy /y %HomeDrive%\boot.ini %HomeDrive%\GHOS\boot.ini
del /a/f/q "%HomeDrive%\boot.ini"
ChangeCodeXP --cl  --find "%HomeDrive%\gho.mbr=\"Norton Ghost\"" --replace "" --fileMask "*.ini" --dir "%HomeDrive%\GHOS"
copy /y %HomeDrive%\GHOS\boot.ini %HomeDrive%\boot.ini

attrib +r +h +s "%HomeDrive%\boot.ini"
attrib -r -h -s "%HomeDrive%\gho"
attrib -r -h -s "%HomeDrive%\gho.mbr"
del /a /f /q %HomeDrive%\gho
del /a /f /q %HomeDrive%\gho.mbr
rd /s /q %HomeDrive%\GHOS
cls
start msgbox "Complete removal Menu." 0 "Complete Remove"
exit

:NotMenu
start msgbox "Menu is not installed, can not be remove." 0 "Menu Errors"
exit