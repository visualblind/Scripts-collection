@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\SQT.ima"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "label SSQT" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "menu label Samsung Quick Tool 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/SamsungTool.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "label SSQT" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "menu label Samsung Quick Tool 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/SamsungTool.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "label SSQT" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "menu label Samsung Quick Tool 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/SamsungTool.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "title Samsung Quick Tool 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/SamsungTool.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/SamsungTool.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "label SSQT" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "menu label Samsung Quick Tool 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/SamsungTool.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "title Samsung Quick Tool 1.9" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/SamsungTool.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\HardDisk.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/SamsungTool.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\HardDisk.ipxe" "item SamsungTool Samsung Quick Tool 1.9" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\HardDisk.ipxe" "item SamsungTool Samsung Quick Tool 1.9" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\HardDisk.ipxe" "item SamsungTool Samsung Quick Tool 1.9" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\HardDisk.ipxe" "item SamsungTool Samsung Quick Tool 1.9" ""

del /a /f /q "%CurDir%UninstallSamsungQuickTool.cmd"
exit