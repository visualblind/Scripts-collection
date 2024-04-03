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
cscript replace.vbs "..\DLC.xml" "" ""
del /a /f /q "%CurDir%AomeiPartitionAssistant.cmd"
del /a /f /q "%CurDir%Icon\Disk Tools\AomeiPartitionAssistant.jpg"
del /a /f /q "%CurDir%Files\AomeiPartitionAssistant.7z"
start /wait msgbox "Complete Remove DLC Soft. Click OK for Exit Program..." 0 "Soft Remove"
start "" /D"..\.." "DLCBoot.exe"
del /a /f /q "%CurDir%AomeiPartitionAssistantUninstall.cmd"
exit