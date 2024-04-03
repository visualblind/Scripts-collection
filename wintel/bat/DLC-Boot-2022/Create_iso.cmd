@ echo off
Title Creat ISO File - DLC Corporation
if exist "..\put_your_file_for_creat_iso\isolinux.cfg" (
goto checkusbfile
)
copy /y isolinux.cfg "..\put_your_file_for_creat_iso"

:checkusbfile
if exist "..\put_your_file_for_creat_iso\DLC1\Programs\BootFromCD" (
goto buildiso
)
ren ..\put_your_file_for_creat_iso\DLC1\Programs\BootFromUSB BootFromCD

:buildiso
mkisofs -R -D -J -l -joliet-long -duplicates-once -o "..\DLC.Boot.2013.iso" -b DLC1/Boot/isolinux.bin -c DLC1/Boot/boot.cat -hide-joliet DLC1/Boot/boot.cat -hide DLC1/Boot/boot.cat -no-emul-boot -N -boot-info-table -V "DLC Boot" -boot-load-size 4 "..\put_your_file_for_creat_iso"