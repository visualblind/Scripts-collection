@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\ati16.iso"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Backup.cfg" "label ATI" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Backup.cfg" "menu label Acronis True Image 2017" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Backup.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/TrueImage.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Backup.cfg" "label ATI" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Backup.cfg" "menu label Acronis True Image 2017" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Backup.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/TrueImage.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.cfg" "label ATI" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.cfg" "menu label Acronis True Image 2017" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/TrueImage.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.lst" "title Acronis True Image 2017" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/TrueImage.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Backup.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/TrueImage.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.cfg" "label ATI" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.cfg" "menu label Acronis True Image 2017" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/TrueImage.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.lst" "title Acronis True Image 2017" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/TrueImage.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Backup.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/TrueImage.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\Backup.ipxe" "item TrueImageDLC Acronis True Image 2017" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\Backup.ipxe" "item TrueImageDLC Acronis True Image 2017" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\Backup.ipxe" "item TrueImageDLC Acronis True Image 2017" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\Backup.ipxe" "item TrueImageDLC Acronis True Image 2017" ""

del /a /f /q "%CurDir%UninstallAcronisTrueImage.cmd"
exit