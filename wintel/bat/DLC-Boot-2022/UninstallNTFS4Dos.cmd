@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\NTFS.ima"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "label NTFS" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "menu label NTFS4Dos 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/NTFS.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "label NTFS" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "menu label NTFS4Dos 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/NTFS.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "label NTFS" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "menu label NTFS4Dos 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/NTFS.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "title NTFS4Dos 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/NTFS.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/NTFS.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "label NTFS" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "menu label NTFS4Dos 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/NTFS.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "title NTFS4Dos 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/NTFS.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/NTFS.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\HardDisk.ipxe" "item NTFS4Dos NTFS4Dos 1.9" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\HardDisk.ipxe" "item NTFS4Dos NTFS4Dos 1.9" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\HardDisk.ipxe" "item NTFS4Dos NTFS4Dos 1.9" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\HardDisk.ipxe" "item NTFS4Dos NTFS4Dos 1.9" ""

del /a /f /q "%CurDir%UninstallNTFS4Dos.cmd"
exit