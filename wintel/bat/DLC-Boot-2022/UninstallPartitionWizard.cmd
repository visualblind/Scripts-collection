@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\pw.iso"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "label PW9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "menu label MiniTool Partition Wizard Technician 9.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/PartitionWizard.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "label PW9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "menu label MiniTool Partition Wizard Technician 9.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/PartitionWizard.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "label PW9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "menu label MiniTool Partition Wizard Technician 9.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/PartitionWizard.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "title MiniTool Partition Wizard Technician 9.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/PartitionWizard.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/PartitionWizard.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "label PW9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "menu label MiniTool Partition Wizard Technician 9.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/PartitionWizard.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "title MiniTool Partition Wizard Technician 9.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/PartitionWizard.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/PartitionWizard.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\HardDisk.ipxe" "item PW MiniTool Partition Wizard Technician 9.1" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\HardDisk.ipxe" "item PW MiniTool Partition Wizard Technician 9.1" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\HardDisk.ipxe" "item PW MiniTool Partition Wizard Technician 9.1" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\HardDisk.ipxe" "item PW MiniTool Partition Wizard Technician 9.1" ""

del /a /f /q "%CurDir%UninstallPartitionWizard.cmd"
exit