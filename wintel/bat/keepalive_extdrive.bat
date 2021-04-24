@echo off
:start

REM --- Change the drive letter D below to match your HDDs. To add another drive replicate the copy and del lines ---
copy NUL E:\HDDActive.txt
del E:\HDDActive.txt

TIMEOUT /T 5 /NOBREAK
goto start