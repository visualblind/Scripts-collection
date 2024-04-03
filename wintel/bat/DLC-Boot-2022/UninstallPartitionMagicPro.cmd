@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\PQMagic.ima"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "label PQMagic" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "menu label Partition Magic Pro 8.05" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/PQMagic.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "label PQMagic" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "menu label Partition Magic Pro 8.05" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/PQMagic.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "label PQMagic" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "menu label Partition Magic Pro 8.05" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/PQMagic.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "title Partition Magic Pro 8.05" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/PQMagic.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/PQMagic.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "label PQMagic" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "menu label Partition Magic Pro 8.05" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/PQMagic.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "title Partition Magic Pro 8.05" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/PQMagic.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/PQMagic.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\HardDisk.ipxe" "item PartitionMagic Partition Magic Pro 8.05" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\HardDisk.ipxe" "item PartitionMagic Partition Magic Pro 8.05" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\HardDisk.ipxe" "item PartitionMagic Partition Magic Pro 8.05" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\HardDisk.ipxe" "item PartitionMagic Partition Magic Pro 8.05" ""

del /a /f /q "%CurDir%UninstallPartitionMagicPro.cmd"
exit