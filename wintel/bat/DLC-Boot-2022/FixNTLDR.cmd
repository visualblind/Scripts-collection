@echo off
pushd "%~dp0"
For %%I IN (C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (If /i Exist "%%I:\WINDOWS\system32\xpsp1res.dll" set DiskOS=%%I:&goto fix)
start msgbox "Not have any Windows XP Computer" 0 "OS Errors"
exit

:fix
7z.exe x -o"%DiskOS%" -y files\FixNTLDR.7z
start msgbox "Complete fix ntldr is missing" 0 "Finish"
exit