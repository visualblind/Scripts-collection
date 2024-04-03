@echo off
Title DLC Boot 2015 Menu for Windows Vista/7/8 on HDD - DLC Corporation

echo Please wait while copying the necessary files...
copy /y dlc.mbr %HomeDrive%\
copy /y dlc %HomeDrive%\
attrib +r +h +s "%HomeDrive%\dlc.mbr"
attrib +r +h +s "%HomeDrive%\dlc"
xcopy ..\..\..\DLC1\* %HomeDrive%\DLC1 /s /i /y
for %%x in (B7P B8P BOOT.SDI BOOTFIX.BIN ETFSBOOT.COM info.txt) do echo copy /y ..\..\..\Boot\%%x %HomeDrive%\Boot && copy /y ..\..\..\Boot\%%x %HomeDrive%\Boot
start msgbox "Complete Integrated into the Windows Vista, 7, 8 Boot Menu" 0 "Complete Integrated"
exit