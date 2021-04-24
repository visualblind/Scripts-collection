Set-Location C:\
Clear-Host

Get-Command -Noun CIM*

#Classes

Get-CimClass -ClassName *Process 
Get-CimClass -ClassName Win32_Process | Select-Object -ExpandProperty CimClassMethods | Format-Table -AutoSize -Wrap



#Instance

Get-CimInstance -ClassName Win32_Process -Filter 'name = "explorer.exe"'
Get-CimInstance -ClassName Win32_Process -Filter 'name LIKE "exp%.exe"'

$OnePrinter = Get-CimInstance -ClassName Win32_Printer | Select-Object -First 1 
$OnePrinter | Get-CimAssociatedInstance -ResultClassName Win32_PrinterConfiguration

$Win32_ProcessClass = Get-CimClass Win32_Process
$Win32_ProcessClass.CimClassMethods | Format-Table -AutoSize -Wrap
Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine="C:\Windows\System32\notepad.exe"}

Get-Process Note*

$Notepad = Get-CimInstance -ClassName Win32_Process -Filter 'name = "notepad.exe"'
Invoke-CimMethod -InputObject $Notepad -MethodName Terminate