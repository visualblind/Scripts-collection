cls& color 3f

"%~dp0bootice.exe" /Device=%disk%:0 /partitions /delete_letter
"%~dp0bootice.exe" /Device=%disk%:1 /partitions /assign_letter=B

:start
echo.
echo !Phan vung An USB-BOOT da hien len de copy modul!
echo.
set /P copyok=   Khi copy xong, nhap "ok" de An phan vung USB-BOOT [ ok ] = 
IF %copyok%==ok goto :hienBoot
IF %copyok%==OK goto :hienBoot
echo.& echo LOI: PHAI NHAP [ok] DE XAC THUC& echo  AN PHIM BAT KY DE TIEP TUC...& pause>nul& cls& goto :start
echo.

:hienBoot
"%~dp0bootice.exe" /Device=%disk%:0 /partitions /delete_letter
"%~dp0bootice.exe" /Device=%disk%:1 /partitions /assign_letter=B
bin\partassist.exe /hd:%disk% /setletter:0 /letter:auto
goto :end2

:end2
del /Q /F /S bin\log
exit
