@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\memtest.gz"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "label mt" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "menu label MemTest86" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/MemTest.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "label mt" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "menu label MemTest86" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/MemTest.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "label mt" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "menu label MemTest86" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/MemTest.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "title MemTest86" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/MemTest.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/MemTest.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "label mt" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "menu label MemTest86" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/MemTest.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "title MemTest86" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/MemTest.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/MemTest.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\Other.ipxe" "item MemTest86    MemTest86" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\Other.ipxe" "item MemTest86    MemTest86" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\Other.ipxe" "item MemTest86    MemTest86" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\Other.ipxe" "item MemTest86    MemTest86" ""

del /a /f /q "%CurDir%UninstallMemTest86.cmd"
exit