@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
rd /s /q "%CurDir%DLC1"
if not exist "%HomeDrive%\Boot\BCD" (
rd /s /q "%CurDir%Boot"
)
del /a /f /q "%CurDir%Boot\832"
del /a /f /q "%CurDir%Boot\864"
rd /s /q "%CurDir%efi"
del /a /f /q DLCBoot.exe
del /a /f /q bootmgr
del /a /f /q bootmgr.efi
del /a /f /q livecd
del /a /f /q dlc
del /a /f /q dlc.mbr
del /a /f /q comdlg32.ocx
del /a /f /q msinet.ocx

nircmd killprocess msgbox.exe
start /wait msgbox "Complete removal DLC BootUSB." 0 "Complete removal"
del /a /f /q msgbox.exe
del /a /f /q nircmd.exe
del /a /f /q DLCBootUninstall.cmd
exit