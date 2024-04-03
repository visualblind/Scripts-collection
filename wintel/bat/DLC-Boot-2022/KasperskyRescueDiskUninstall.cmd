@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
rem del /a /f /q "%CurDir%Files\NDD.ima"
for %%x in (en\CD vn\CD en\USB vn\USB) do (
cscript replace.vbs "%CurDir%Menu\%%x\AntiRescue.cfg" "label KAS" ""
cscript replace.vbs "%CurDir%Menu\%%x\AntiRescue.cfg" "menu label Kaspersky Rescue Disk" ""
cscript replace.vbs "%CurDir%Menu\%%x\AntiRescue.cfg" "kernel /DLC1/Boot/menu.c32 append /DLC1/Programs/Dos/Menu/LoadSoft/kas.cfg" ""

cscript replace.vbs "%CurDir%Menu\%%x\AntiRescue.lst" "title Kaspersky Rescue Disk" ""
cscript replace.vbs "%CurDir%Menu\%%x\AntiRescue.lst" "find --set-root /DLC1/Programs/Dos/Menu/LoadSoft/kas.lst" ""
cscript replace.vbs "%CurDir%Menu\%%x\AntiRescue.lst" "configfile /DLC1/Programs/Dos/Menu/LoadSoft/kas.lst" ""

rem cscript replace.vbs "%CurDir%Menu\%%x\AntiRescue.ipxe" "item Kaspersky Rescue Disk" ""
)


cscript replace.vbs "%CurDir%ProgramList.txt" "liveusb?File?0" ""
cscript replace.vbs "%CurDir%ProgramList.txt" "rescue?Folder?303595520" ""
cscript replace.vbs "%CurDir%ProgramList.txt" "DLC1?Folder?40960" ""

del /a /f /q "%CurDir%KasperskyRescueDiskUninstall.cmd"
exit