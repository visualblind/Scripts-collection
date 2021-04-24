Set-Location C:\
Clear-Host


Get-Module -ListAvailable Webadministration



Get-PSDrive
Remove-Module WebAdministration
Get-PSDrive

Import-Module WebAdministration
Get-PSDrive IIS
Set-Location IIS:\AppPools

# Two easy ways to create an application pool.  First: 
New-WebAppPool -Name "MyWebAppPool"

# Next: Create it from the IIS PSDrive
New-Item -Path .\AnotherAppPool


"App1","App2","App3" | Foreach-Object {New-Item IIS:\AppPools\$_}
Get-Childitem IIS:\AppPools\app* | Remove-Item
Restart-WebAppPool 
#IIS Drive also has Sites

New-Item "C:\sites\mysite\index.html" -Force -Value "Hello World!"
New-Website -Name "MySite" -Port 8000 -PhysicalPath "C:\sites\mysite" -ApplicationPool MyWebAppPool

Remove-Website MySite

$HTMLContent = Get-ComputerInfo | ConvertTo-Html -Title "$Env:Computername Details" -As List -Property Win*, Bios*
$HTMLContent | Out-File "C:\sites\mysite\ComputerInfo.html"

Get-Service | ConvertTo-Html -as list | Out-File "C:\sites\mysite\Services.html"
Get-Process | ConvertTo-Html | Out-File "C:\sites\mysite\Processes.html"


New-WebBinding -Name MySite -Protocol HTTP -Port 8080

Restart-WebAppPool MyWebsitePool
Stop-Website -Name MySite

Enable-WebRequestTracing -Name "MySite" -StatusCodes "400-450"

