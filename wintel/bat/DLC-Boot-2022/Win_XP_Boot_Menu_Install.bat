@echo off
Title DLC Boot 2015 Menu for Windows XP on HDD - DLC Corporation

:Start
if not exist "%HomeDrive%\DLC1\DLC1Menu.exe" (
goto SetupMenu
)
echo Please wait while remove the old version...
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
echo Finished remove the old version.
cls
goto SetupMenu

:RemoveWithBootFolder
for %%x in (B7P B8P BOOT.SDI info.txt) do echo del /a /f /q %HomeDrive%\Boot\%%x&& del /a /f /q %HomeDrive%\Boot\%%x
echo.
echo Finished remove the old version.

:SetupMenu
if exist "%HomeDrive%\boot.ini" (
goto IniExit1
)
copy /y "boot.ini" "%HomeDrive%\"
:IniExit1
md %HomeDrive%\DLC1
attrib +h +s "%HomeDrive%\DLC1"
if exist "%HomeDrive%\Boot\BCD" (
goto SetupWithBootFolder
)
md %HomeDrive%\Boot
attrib +h +s "%HomeDrive%\Boot"
:SetupWithBootFolder
attrib -r -h -s "%HomeDrive%\boot.ini" >nul 2>nul
>>"%HomeDrive%\boot.ini" echo.
>>"%HomeDrive%\boot.ini" echo %HomeDrive%\dlc.mbr="DLC Boot 2015"
echo bootcfg /timeout 3&&bootcfg /timeout 3
echo.
attrib +r +h +s "%HomeDrive%\boot.ini"
echo Please wait while copying the necessary files...
copy /y dlc %HomeDrive%\
copy /y dlc.mbr %HomeDrive%\
attrib +r +h +s "%HomeDrive%\dlc"
attrib +r +h +s "%HomeDrive%\dlc.mbr"
xcopy ..\..\..\DLC1\* %HomeDrive%\DLC1 /s /i /y
for %%x in (B7P B8P BOOT.SDI info.txt) do echo copy /y ..\..\..\Boot\%%x %HomeDrive%\Boot && copy /y ..\..\..\Boot\%%x %HomeDrive%\Boot
start msgbox "Complete Integrated into the Windows XP Boot Menu" 0 "Complete Integrated"
exit