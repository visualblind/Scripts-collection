Get-WmiObject -Class Win32_Product | Select-Object Name,IdentifyingNumber

Get-WmiObject -Class Win32_Product | Where-Object {$_.IdentifyingNumber -match '{EnterIdentifyingNumberHere}'} |  Invoke-WmiMethod -Name "Uninstall"