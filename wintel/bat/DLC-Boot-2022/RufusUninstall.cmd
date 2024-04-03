@ECHO OFF
pushd %~dp0
SET CurDir=%CD%\
echo Tao file de kiem tra xem DLC chay tu CD hay USB >Check.DLC
if exist "%CurDir%\Check.DLC" (
del /a /f /q "%CurDir%\Check.DLC"
goto Uninstall
)
cls
msgbox "Can't Remove DLC Software from CD. Click OK for Exit Program..." 0 "Error"
exit

:Uninstall
nircmd killprocess DLCBoot.exe
cscript replace.vbs "..\DLC.xml" "<file><name>Rufus 1.3.2.232</name><path>DLC1\Programs\Rufus.exe</path><uninstall>DLC1\Programs\RufusUninstall.cmd</uninstall><icon>DLC1\Programs\Icon\USB Tools\Rufus.jpg</icon></file>" ""
del /a /f /q "%CurDir%Rufus.exe"
del /a /f /q "%CurDir%Icon\USB Tools\Rufus.jpg"
start /wait msgbox "Complete Remove DLC Soft. Click OK for Exit Program..." 0 "Soft Remove"
start "" /D"..\.." "DLCBoot.exe"
del /a /f /q "%CurDir%RufusUninstall.cmd"
exit