@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\DiskPatch.ima"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "label DP4" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "menu label Disk Patch 4.0.300" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/DiskPatch.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "label DP4" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "menu label Disk Patch 4.0.300" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/DiskPatch.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "label DP4" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "menu label Disk Patch 4.0.300" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/DiskPatch.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "title Disk Patch 4.0.300.3" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/DiskPatch.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/DiskPatch.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "label DP4" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "menu label Disk Patch 4.0.300" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/DiskPatch.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "title Disk Patch 4.0.300.3" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/DiskPatch.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/DiskPatch.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\HardDisk.ipxe" "item DP4 Disk Patch 4.0.300" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\HardDisk.ipxe" "item DP4 Disk Patch 4.0.300" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\HardDisk.ipxe" "item DP4 Disk Patch 4.0.300" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\HardDisk.ipxe" "item DP4 Disk Patch 4.0.300" ""

del /a /f /q "%CurDir%UninstallDiskPatch.cmd"
exit