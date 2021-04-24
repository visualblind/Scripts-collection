Set-Location C:\
Clear-Host

powershell.exe
PowerShell.exe -NoLogo
PowerShell.exe -NoExit
PowerShell.exe -NoProfile
PowerShell.exe -ExecutionMode "Bypass"
PowerShell.exe -File "C:\PathTo\PowerShellScript.ps1"
PowerShell.exe -Command "& {Get-Process | Out-File C:\Temp\ProcessList.txt}"
PowerShell.exe -Command {Get-Service | Out-File C:\Temp\ServiceList.txt}
