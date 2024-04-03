@echo off
Title DLC Boot 2015 Menu for Windows Vista/7/8 on HDD - DLC Corporation

echo Please wait while remove menu...
start /wait %HomeDrive%\DLC1\MenuRemove.bat
attrib -r -h -s "%HomeDrive%\dlc.mbr"
attrib -r -h -s "%HomeDrive%\dlc"
for %%x in (dlc.mbr dlc) do echo del /a /f /q %HomeDrive%\%%x&& del /a /f /q %HomeDrive%\%%x
rd /s /q %HomeDrive%\DLC1
if exist "%HomeDrive%\Boot\BCD" (
goto RemoveWithBootFolder
)
attrib -h -s -r "%HomeDrive%\Boot"
rd /s /q %HomeDrive%\Boot
start msgbox "Complete removal Menu." 0 "Complete Remove"
exit

:RemoveWithBootFolder
for %%x in (832 864 BOOT.SDI) do echo del /a /f /q %HomeDrive%\Boot\%%x&& del /a /f /q %HomeDrive%\Boot\%%x
set dd=%~dp0
start %dd%msgbox "Complete removal Menu." 0 "Complete Remove"
exit