@ echo off
Title Extract Your WIM File - DLC Corporation
start /wait wincmd load getyourwim.ini
call setyourwimpath.cmd
del setyourwimpath.cmd
IF '%yourwimpath%'=='' goto fail
if not exist %yourwimpath% (
goto fail
)

7z x %yourwimpath% -o"..\put_your_file_for_creat_wim" -y
exit

:fail
echo No WIM file is selected.
pause >nul
exit