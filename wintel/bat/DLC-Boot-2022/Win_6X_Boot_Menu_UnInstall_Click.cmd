@echo off
pushd %~dp0
SET CurDir=%CD%\
if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64Bit
"%CurDir%RunAdmin32" "%HomeDrive%\DLC1\Win_6X_Boot_Menu_UnInstall.cmd"
exit

:64Bit
"%CurDir%RunAdmin64" "%HomeDrive%\DLC1\Win_6X_Boot_Menu_UnInstall.cmd"
exit