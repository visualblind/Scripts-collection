@echo off
Title DLC Boot 2016 Menu for Windows Vista/7/8 on HDD - DLC Corporation

for /f "tokens=3" %%a in ('bcdedit /create /d "DLC Boot 2016" /application BOOTSECTOR') do set guid=%%a
echo bcdedit /set %guid% device boot&&bcdedit /set %guid% device boot
echo bcdedit /set %guid% device partition=%HomeDrive%&&bcdedit /set %guid% device partition=%HomeDrive%
echo bcdedit /set %guid% PATH \dlc.mbr&&bcdedit /set %guid% PATH \dlc.mbr
echo bcdedit /displayorder %guid% /addlast&&bcdedit /displayorder %guid% /addlast
echo bcdedit /timeout 3&&bcdedit /timeout 3
(
echo @echo off
echo Title DLC Boot 2016 Menu for Windows Vista/7/8 on HDD - DLC Corporation
echo Please wait while remove menu...
echo bcdedit /delete %guid%
echo exit
)>%HomeDrive%\DLC1\MenuRemove.bat

exit