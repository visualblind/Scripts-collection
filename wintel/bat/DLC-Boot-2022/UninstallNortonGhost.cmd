@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\Ghost.ima"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Backup.cfg" "label GhostNorDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Backup.cfg" "menu label Norton Ghost Normal 11.5.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Backup.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/ghost.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Backup.cfg" "label GhostNorDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Backup.cfg" "menu label Norton Ghost Normal 11.5.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Backup.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/ghost.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.cfg" "label GhostNorDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.cfg" "menu label Norton Ghost Normal 11.5.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/ghost.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.lst" "title Norton Ghost Normal 11.5.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/ghost.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/ghost.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.cfg" "label GhostNorDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.cfg" "menu label Norton Ghost Normal 11.5.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/ghost.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.lst" "title Norton Ghost Normal 11.5.1" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/ghost.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/ghost.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\Backup.ipxe" "item GhostNorDLC Norton Ghost Normal 11.5.1" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\Backup.ipxe" "item GhostNorDLC Norton Ghost Normal 11.5.1" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\Backup.ipxe" "item GhostNorDLC Norton Ghost Normal 11.5.1" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\Backup.ipxe" "item GhostNorDLC Norton Ghost Normal 11.5.1" ""

del /a /f /q "%CurDir%UninstallNortonGhost.cmd"
exit