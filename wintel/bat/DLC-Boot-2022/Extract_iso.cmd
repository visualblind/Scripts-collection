@ echo off
Title Extract Your ISO File - DLC Corporation
start /wait wincmd load getyouriso.ini
call setyourisopath.cmd
del setyourisopath.cmd
IF '%yourisopath%'=='' goto fail
if not exist %yourisopath% (
goto fail
)

7z x %yourisopath% -o"..\put_your_file_for_creat_iso" -y -x"![BOOT]\*.img"
exit

:fail
echo No ISO file is selected.
pause >nul
exit