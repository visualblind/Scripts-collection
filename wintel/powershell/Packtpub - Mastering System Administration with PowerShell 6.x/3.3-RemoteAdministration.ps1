Set-Location C:\
Clear-Host

#Working with the CIM Cmdlets
Get-CimInstance Win32_OperatingSystem | Format-Table -Property CSName, Caption, Version
Get-CimInstance Win32_OperatingSystem -Computername "Win2016-Srv01" | Format-Table -Property CSName, Caption, Version

$CimCredential = Get-Credential -Credential "Win2016-Srv01\MSimmons"
$CimSessionOptions = New-CimSessionOption -SkipCNCheck
$CimSession = New-CimSession -ComputerName "Win2016-Srv01" -Credential $CimCredential -SessionOption $CimSessionOptions

Get-CimInstance Win32_Service -CimSession $CimSession -Filter 'name = "Docker"'
Get-CimInstance Win32_Service -CimSession $CimSession -Filter 'name = "Docker"' | Invoke-CimMethod -MethodName StopService
Get-CimInstance Win32_Service -CimSession $CimSession -Filter 'name = "Docker"'
Get-CimInstance Win32_Service -CimSession $CimSession -Filter 'name = "Docker"' | Invoke-CimMethod -MethodName StartService


Get-ComputerInfo -Property Windows*
Get-Uptime


Invoke-Command -ComputerName "Win2016-Srv01" -ScriptBlock {Get-ComputerInfo -Property Windows*}
Invoke-Command -ComputerName "Win2016-Srv01" -ScriptBlock {$SavedInfo = Get-ComputerInfo -Property Windows*; $SavedInfo}
Invoke-Command -ComputerName "Win2016-Srv01" -ScriptBlock {$SavedInfo}



$PSSession = New-PSSession -ComputerName "Win2016-Srv01" -Credential $CimCredential
Invoke-Command -Session $PSSession -ScriptBlock { 
    if (Get-Command -Noun "Uptime") { 
        Get-Uptime
    } else {
        #"Not running PowerShell Core 6"
        $Uptime = pwsh.exe -command {Get-Uptime -Since}
        "Server: $Env:COMPUTERNAME was booted on $Uptime"
    }
}

Enter-PSSession $PSSession 

$DockerOnServer = Invoke-Command -Session $PSSession -ScriptBlock {Get-Service Docker}
$DockerOnServer

$Read = Read-Host "Enter a word"
"Read variable: $Read"
Invoke-Command -Session $PSSession -ArgumentList $Read -ScriptBlock {
    $Args0 = $args[0]
    "Variable passed as argument 0: $args0"
}

Invoke-Command -Session $PSSession -ScriptBlock {
    "Automatic passing between sessions with 'using' variable scope: $using:Read" 
}


$file = New-Item -ItemType File -Path C:\temp\MyNewestCreation.txt -Value "Going to copy this through sessions" -Force 
$file
$file | Get-Content

Get-Childitem "C:\temp\MyNewestCreation.txt"
Invoke-Command -Session $PSSession {Test-Path "C:\temp\MyNewestCreation.txt"}

Copy-Item $file C:\temp\MyNewestCreation.txt -Force -ToSession $PSSession
Invoke-Command -Session $PSSession {Test-Path "C:\temp\MyNewestCreation.txt"}

