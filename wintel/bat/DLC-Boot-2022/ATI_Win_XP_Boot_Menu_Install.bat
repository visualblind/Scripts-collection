@echo off
Title ATI Menu for Windows XP on HDD - DLC Corporation

:Start
if not exist "%HomeDrive%\ATIB\Dos\ati.iso" (
goto SetupMenu
)
echo Please wait while remove the old version...
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
echo Finished remove the old version.

:SetupMenu
if exist "%HomeDrive%\boot.ini" (
goto IniExit1
)
copy /y "boot.ini" "%HomeDrive%\"
:IniExit1
md %HomeDrive%\ATIB
for %%x in (Dos Menu) do md %HomeDrive%\ATIB\%%x
attrib +h +s "%HomeDrive%\ATIB"
attrib -r -h -s "%HomeDrive%\boot.ini" >nul 2>nul
copy /y "%HomeDrive%\boot.ini" "%HomeDrive%\ATIB\boot.ini"
>>"%HomeDrive%\boot.ini" echo.
>>"%HomeDrive%\boot.ini" echo %HomeDrive%\ati.mbr="Acronis True Image Home"
echo bootcfg /timeout 3&&bootcfg /timeout 3
echo.
attrib +r +h +s "%HomeDrive%\boot.ini"
echo Please wait while copying the necessary files...
copy /y ati %HomeDrive%\
copy /y ati.mbr %HomeDrive%\
attrib +r +h +s "%HomeDrive%\ati"
attrib +r +h +s "%HomeDrive%\ati.mbr"
copy /y ..\..\Dos\ati.iso %HomeDrive%\ATIB\Dos

:password
cls
echo.
echo Do you want to create a password for Menu Boot?
echo.
SET agree=
SET /P agree=Do you want continue (Y/N = Yes/No)?:
echo.
IF /I NOT '%agree%'=='Y' IF /I NOT '%agree%'=='N' goto password
IF /I '%agree%'=='Y' (
goto makepass
)
goto finish

:makepass
cls
echo.
echo  Type Password you want: 
set /p password=(Ex: 123) and Enter:
IF /I '%password%'=='' (
goto makepass
)
cls
copy /y menupass.lst %HomeDrive%\ATIB\Menu\menu.lst
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo.
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo password %password%
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo find --set-root --ignore-floppies /ATIB/Dos/ati.iso
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo map --mem /ATIB/Dos/ati.iso (0xff)
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo map --hook
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo root (0xff)
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo chainloader (0xff)
>>"%HomeDrive%\ATIB\Menu\menu.lst" echo boot
start msgbox "Complete Integrated into the Windows XP Boot Menu" 0 "Complete Integrated"
exit

:finish
copy /y atimenu.lst %HomeDrive%\ATIB\Menu\menu.lst
start msgbox "Complete Integrated into the Windows XP Boot Menu" 0 "Complete Integrated"
exit