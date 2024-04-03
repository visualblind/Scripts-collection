@echo off
Title Disable UAC for windows 7/8 - DLC Corporation

:Windows78
if exist %SystemRoot%\System32\OffUAC.DLC goto readyUAC

:Disable
echo Tao file de kiem tra UAC >%SystemRoot%\System32\OffUAC.DLC
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
shutdown -r -t 10
exit

:readyUAC
start msgbox "Sorry but UAC ready disable" 0 "UAC Errors"
exit