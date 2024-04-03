@echo off
Title GHOST Menu for Windows XP on HDD - DLC Corporation

:Start
if not exist "%HomeDrive%\GHOS\Dos\Ghost.ima" (
goto SetupMenu
)
echo Please wait while remove the old version...
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
echo Finished remove the old version.

:SetupMenu
if exist "%HomeDrive%\boot.ini" (
goto IniExit1
)
copy /y "boot.ini" "%HomeDrive%\"
:IniExit1
md %HomeDrive%\GHOS
for %%x in (Boot Dos Menu) do md %HomeDrive%\GHOS\%%x
attrib +h +s "%HomeDrive%\GHOS"
attrib -r -h -s "%HomeDrive%\boot.ini" >nul 2>nul
copy /y "%HomeDrive%\boot.ini" "%HomeDrive%\GHOS\boot.ini"
>>"%HomeDrive%\boot.ini" echo.
>>"%HomeDrive%\boot.ini" echo %HomeDrive%\gho.mbr="Norton Ghost"
echo bootcfg /timeout 3&&bootcfg /timeout 3
echo.
attrib +r +h +s "%HomeDrive%\boot.ini"
echo Please wait while copying the necessary files...
copy /y gho %HomeDrive%\
copy /y gho.mbr %HomeDrive%\
attrib +r +h +s "%HomeDrive%\gho"
attrib +r +h +s "%HomeDrive%\gho.mbr"
copy /y ..\..\Boot\memdisk %HomeDrive%\GHOS\Boot
copy /y ..\..\Dos\Ghost.ima %HomeDrive%\GHOS\Dos

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
copy /y menupass.lst %HomeDrive%\GHOS\Menu\menu.lst
>>"%HomeDrive%\GHOS\Menu\menu.lst" echo.
>>"%HomeDrive%\GHOS\Menu\menu.lst" echo password %password%
>>"%HomeDrive%\GHOS\Menu\menu.lst" echo kernel /GHOS/Boot/memdisk ima raw
>>"%HomeDrive%\GHOS\Menu\menu.lst" echo initrd /GHOS/Dos/Ghost.ima
start msgbox "Complete Integrated into the Windows XP Boot Menu" 0 "Complete Integrated"
exit

:finish
copy /y ghomenu.lst %HomeDrive%\GHOS\Menu\menu.lst
start msgbox "Complete Integrated into the Windows XP Boot Menu" 0 "Complete Integrated"
exit