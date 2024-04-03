@echo off
Title ATI Menu for Windows Vista/7/8 on HDD - DLC Corporation

echo Please wait while remove menu...
start /wait %HomeDrive%\ATIB\MenuRemove.bat
attrib -r -h -s "%HomeDrive%\ati.mbr"
attrib -r -h -s "%HomeDrive%\ati"
for %%x in (ati.mbr ati) do echo del /a /f /q %HomeDrive%\%%x&& del /a /f /q %HomeDrive%\%%x
rd /s /q %HomeDrive%\ATIB
set dd=%~dp0
start %dd%msgbox "Complete removal Menu." 0 "Complete Remove"
exit