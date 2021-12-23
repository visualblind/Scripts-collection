#Requires -RunAsAdministrator

New-Item -Path Registry::HKLM\SOFTWARE\Policies\Microsoft\Dsh
New-ItemProperty -Path Registry::HKLM\SOFTWARE\Policies\Microsoft\Dsh -Name "AllowNewsAndInterests" -Value 0 -Type DWORD
pause
