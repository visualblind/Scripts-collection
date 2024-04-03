@echo off
Title ATI Menu for Windows Vista/7/8 on HDD - DLC Corporation

echo Please wait while copying the necessary files...
set dd=%~dp0
copy /y %dd%ati.mbr %HomeDrive%\
copy /y %dd%ati %HomeDrive%\
attrib +r +h +s "%HomeDrive%\ati.mbr"
attrib +r +h +s "%HomeDrive%\ati"

for /f "tokens=3" %%a in ('bcdedit /create /d "Acronis True Image Home" /application BOOTSECTOR') do set guid=%%a
echo bcdedit /set %guid% device boot&&bcdedit /set %guid% device boot
echo bcdedit /set %guid% device partition=%HomeDrive%&&bcdedit /set %guid% device partition=%HomeDrive%
echo bcdedit /set %guid% PATH \ati.mbr&&bcdedit /set %guid% PATH \ati.mbr
echo bcdedit /displayorder %guid% /addlast&&bcdedit /displayorder %guid% /addlast
echo bcdedit /timeout 3&&bcdedit /timeout 3

(
echo @echo off
echo GHOST Menu for Windows Vista/7/8 on HDD - DLC Corporation
echo Please wait while remove menu...
echo bcdedit /delete %guid%
echo exit
)>%HomeDrive%\ATIB\MenuRemove.bat

exit