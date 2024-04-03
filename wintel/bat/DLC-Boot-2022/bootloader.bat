:bootloader
cls& echo.& echo Chon loai Bootloader?& color 3F
echo.& echo  [1]: MBR = NT6.x (Mac dinh cho main G31 Foxcon)& color 3f& echo  [2]: MBR = Grub2 (Nen chon neu may moi)& echo  [3]: MBR = Grub4dos& echo.
set ChonBOOT=
set /P ChonBOOT= LUA CHON [ ? ] = 
IF %ChonBOOT%==1 goto :default
IF %ChonBOOT%==2 goto :grub2
IF %ChonBOOT%==3 goto :grub4
if not errorlevel 1 ( echo.& echo.& echo LOI: BAN PHAI NHAP CAC LUA CHON TREN& color 4f& echo AN PHIM BAT KY DE LUA CHON LAI...& pause>nul& cls& goto :bootloader
)
:default
"%~dp0bootice.exe" /DEVICE=%disk% /mbr /install /type=nt60 /keep_dpt /quiet
goto :end1
exit

:grub2
"%~dp0bootice.exe" /DEVICE=%disk% /mbr /restore /file=g2ldrmbr /keep_dpt /quiet
goto :end1
exit

:grub4
"%~dp0bin\bootice.exe" /DEVICE=%disk% /mbr /install /type=GRUB4DOS /boot_file=GRLDR /keep_dpt /quiet
goto :end1
exit

:end1
del /Q /F /S bin\log
exit
