@echo off
Title GHOST Menu for Windows Vista/7/8 on HDD - DLC Corporation

echo Please wait while remove menu...
start /wait %HomeDrive%\GHOS\MenuRemove.bat
attrib -r -h -s "%HomeDrive%\gho.mbr"
attrib -r -h -s "%HomeDrive%\gho"
for %%x in (gho.mbr gho) do echo del /a /f /q %HomeDrive%\%%x&& del /a /f /q %HomeDrive%\%%x
rd /s /q %HomeDrive%\GHOS
set dd=%~dp0
start %dd%msgbox "Complete removal Menu." 0 "Complete Remove"
exit