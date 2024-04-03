@echo off
Title GHOST Menu for Windows Vista/7/8 on HDD - DLC Corporation

echo Please wait while copying the necessary files...
set dd=%~dp0
copy /y %dd%gho.mbr %HomeDrive%\
copy /y %dd%gho %HomeDrive%\
attrib +r +h +s "%HomeDrive%\gho.mbr"
attrib +r +h +s "%HomeDrive%\gho"

for /f "tokens=3" %%a in ('bcdedit /create /d "Norton Ghost" /application BOOTSECTOR') do set guid=%%a
echo bcdedit /set %guid% device boot&&bcdedit /set %guid% device boot
echo bcdedit /set %guid% device partition=%HomeDrive%&&bcdedit /set %guid% device partition=%HomeDrive%
echo bcdedit /set %guid% PATH \gho.mbr&&bcdedit /set %guid% PATH \gho.mbr
echo bcdedit /displayorder %guid% /addlast&&bcdedit /displayorder %guid% /addlast
echo bcdedit /timeout 3&&bcdedit /timeout 3

(
echo @echo off
echo GHOST Menu for Windows Vista/7/8 on HDD - DLC Corporation
echo Please wait while remove menu...
echo bcdedit /delete %guid%
echo exit
)>%HomeDrive%\GHOS\MenuRemove.bat

exit