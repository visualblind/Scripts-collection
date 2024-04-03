@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
del /a /f /q "%CurDir%Programs\Dos\Files\chntpw"
del /a /f /q "%CurDir%Programs\Dos\Files\chntpw.gz"

for %%x in (en\CD vn\CD en\USB vn\USB en\LAN vn\LAN en\Android vn\Android) do (
cscript replace.vbs "%CurDir%Programs\Dos\Menu\%%x\Other.cfg" "label PassChangeDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\%%x\Other.cfg" "menu label Offline XP/Vista/7 Password Changer" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\%%x\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\%%x\Other.lst" "title Offline XP/Vista/7 Password Changer" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\%%x\Other.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\%%x\Other.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\%%x\Other.ipxe" "item PassChangeDLC    Offline XP/Vista/7 Password Changer" ""
)

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "label PassChangeDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "menu label Offline XP/Vista/7 Password Changer" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\CD\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "label PassChangeDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "menu label Offline XP/Vista/7 Password Changer" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\CD\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "label PassChangeDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "menu label Offline XP/Vista/7 Password Changer" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "title Offline XP/Vista/7 Password Changer" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\USB\Other.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "label PassChangeDLC" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "menu label Offline XP/Vista/7 Password Changer" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.cfg" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "title Offline XP/Vista/7 Password Changer" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.lst" ""
cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\USB\Other.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/OfflinePassword.lst" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\LAN\Other.ipxe" "item PassChangeDLC    Offline XP/Vista/7 Password Changer" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\LAN\Other.ipxe" "item PassChangeDLC    Offline XP/Vista/7 Password Changer" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\en\Android\Other.ipxe" "item PassChangeDLC    Offline XP/Vista/7 Password Changer" ""

cscript replace.vbs "%CurDir%Programs\Dos\Menu\vn\Android\Other.ipxe" "item PassChangeDLC    Offline XP/Vista/7 Password Changer" ""

del /a /f /q "%CurDir%UninstallOfflineXPVista7PasswordChanger.cmd"
exit