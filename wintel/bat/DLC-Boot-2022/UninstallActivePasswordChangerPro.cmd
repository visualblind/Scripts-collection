@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\Active.img"

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "label APC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "menu label Active Password Changer Pro 6.0" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/ActivePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "label APC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "menu label Active Password Changer Pro 6.0" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/ActivePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "label APC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "menu label Active Password Changer Pro 6.0" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/ActivePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "title Active Password Changer Pro 6.0" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/ActivePassword.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/ActivePassword.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "label APC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "menu label Active Password Changer Pro 6.0" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/ActivePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "title Active Password Changer Pro 6.0" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/ActivePassword.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/ActivePassword.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\Other.ipxe" "item ActivePassChangeDLC    Active Password Changer Pro 6.0" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\Other.ipxe" "item ActivePassChangeDLC    Active Password Changer Pro 6.0" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\Other.ipxe" "item ActivePassChangeDLC    Active Password Changer Pro 6.0" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\Other.ipxe" "item ActivePassChangeDLC    Active Password Changer Pro 6.0" ""

del /a /f /q "%CurDir%UninstallActivePasswordChangerPro.cmd"
exit