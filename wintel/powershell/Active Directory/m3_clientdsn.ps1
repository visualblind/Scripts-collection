$Username = [Environment]::UserName
$Key = "HKCU:\Software\MPI Software\Millennium Payroll\Startup"
$DBName = "Database"
$Type = "String"
$LastUser = "LastUser"

if (-not (Test-Path $Key)) { 
New-Item $Key -ItemType Registry -Force | Out-Null 
} 

switch -wildcard ($Username) 
    { 
        "shr*" {
        $TrimUser = $Username.split("_")[1]
        $DBValue = "SI_SHR"
        $LastUserName = "10040\" + $TrimUser
        New-ItemProperty $Key -Name $DBName -Value $DBValue -PropertyType $Type -Force | Out-Null
        New-ItemProperty $Key -Name $LastUser -Value $LastUserName -PropertyType $Type -Force | Out-Null
        } 
        "twp*" {
        $TrimUser = $Username.split("_")[1]
        $DBValue = "PS_TWP"
        $LastUserName = "01497\" + $TrimUser
        New-ItemProperty $Key -Name $DBName -Value $DBValue -PropertyType $Type -Force | Out-Null
        New-ItemProperty $Key -Name $LastUser -Value $LastUserName -PropertyType $Type -Force | Out-Null
        } 
        "vna*" {
        $TrimUser = $Username.split("_")[1]
        $DBValue = "PS_10150"
        $LastUserName = "10150\" + $TrimUser
        New-ItemProperty $Key -Name $DBName -Value $DBValue -PropertyType $Type -Force | Out-Null
        New-ItemProperty $Key -Name $LastUser -Value $LastUserName -PropertyType $Type -Force | Out-Null
        } 
    }
