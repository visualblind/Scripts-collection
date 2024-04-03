@echo off
pushd %~dp0
SET CurDir=%CD%\
if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64Bit
"%CurDir%RunAdmin32" "%CurDir%Win_6X_Boot_Menu_Install.cmd"
exit

:64Bit
"%CurDir%RunAdmin64" "%CurDir%Win_6X_Boot_Menu_Install.cmd"
exit