@echo off
pushd %~dp0
SET CurDir=%CD%\
reg import apy.reg /reg:64
reg import eav64.reg /reg:64

REG ADD "HKLM\SOFTWARE\ESET\Eset security\CurrentVersion\info" /f /v "InstallDir" /t REG_SZ /d "%CurDir%
REG ADD "HKLM\SOFTWARE\ESET\Eset security\CurrentVersion\Plugins\01000100" /f /v "Client" /t REG_SZ /d "%CurDir%eguiScan.dll"
REG ADD "HKLM\SOFTWARE\ESET\Eset security\CurrentVersion\Plugins\01000100" /f /v "Filename" /t REG_SZ /d "%CurDir%x86\ekrnScan.dll"
REG ADD "HKLM\SOFTWARE\ESET\Eset security\CurrentVersion\Plugins\01000400" /f /v "Client" /t REG_SZ /d "%CurDir%eguiUpdate.dll"
REG ADD "HKLM\SOFTWARE\ESET\Eset security\CurrentVersion\Plugins\01000400" /f /v "Filename" /t REG_SZ /d "%CurDir%x86\ekrnUpdate.dll"

if not exist "%CurDir%EAV\updfiles\upd.ver" goto a
rd /s /q "%CurDir%EAV\Logs"
rd /s /q "%CurDir%EAV\updfiles"

:a
REG ADD "HKLM\SOFTWARE\ESET\Eset security\CurrentVersion\info" /f /v "AppDataDir" /t REG_SZ /d "%CurDir%EAV\
REG ADD "HKLM\SOFTWARE\ESET\Eset security\CurrentVersion\Plugins\01000400\Profiles\@My profile" /f /v "MirrorFolder" /t REG_SZ /d "%CurDir%EAV\
nircmd qbox "Setup Virtual Memory & Select Hardisk partition, do not select (Ramdisk B, Y, X, Y, A). Click Yes to continue" "question" SetPageFile.exe /t30000 /a1 /i2048 /fpagefile.sys
nircmd cmdwait 12000 shellrefresh
sc create ekrn type= own start= auto binpath= "%CurDir%x86\ekrn.EXE" displayname= "ESET Service"
net start ekrn
Echo Starting ESET SysRescue
start "%CurDir%" "egui.exe" /waitservice
exit