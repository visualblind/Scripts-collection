@echo off
Title DLC Boot 2016 Menu for Windows XP on HDD - DLC Corporation

:Start
if not exist "%HomeDrive%\DLC1\DLC1Menu.exe" (
goto NotMenu
)
echo Please wait while remove menu...
attrib -r -h -s "%HomeDrive%\boot.ini"

copy /y %HomeDrive%\boot.ini %HomeDrive%\DLC1\boot.ini
del /a/f/q "%HomeDrive%\boot.ini"
ChangeCodeXP --cl  --find "%HomeDrive%\dlc.mbr=\"DLC Boot 2016\"" --replace "" --fileMask "*.ini" --dir "%HomeDrive%\DLC1"
copy /y %HomeDrive%\DLC1\boot.ini %HomeDrive%\boot.ini

attrib +r +h +s "%HomeDrive%\boot.ini"
attrib -r -h -s "%HomeDrive%\dlc"
attrib -r -h -s "%HomeDrive%\dlc.mbr"
del /a /f /q %HomeDrive%\dlc
del /a /f /q %HomeDrive%\dlc.mbr
rd /s /q %HomeDrive%\DLC1
if exist "%HomeDrive%\Boot\BCD" (
goto RemoveWithBootFolder
)
rd /s /q %HomeDrive%\Boot
start msgbox "Complete removal Menu." 0 "Complete Remove"
exit

:RemoveWithBootFolder
for %%x in (B7P B8P BOOT.SDI info.txt) do echo del /a /f /q %HomeDrive%\Boot\%%x&& del /a /f /q %HomeDrive%\Boot\%%x
start msgbox "Complete removal Menu." 0 "Complete Remove"
exit

:NotMenu
start msgbox "Menu is not installed, can not be remove." 0 "Menu Errors"
exit