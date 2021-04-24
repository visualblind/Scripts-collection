# Import the AD module to the session
Import-Module ActiveDirectory

# Retrieve the dNSHostName attribute from all computer accounts in AD
$ComputerNames = Get-ADComputer -Filter * -Properties dNSHostName | Select-Object -ExpandProperty dNSHostName $AllComputerShares = @()
foreach ($Computer in $ComputerNames)
{
	try { $Shares = Get-WmiObject -ComputerName $Computer -Class Win32_Share -ErrorAction Stop $AllComputerShares += $Shares }
	catch { Write-Error "Failed to connect retrieve Shares from $Computer" }
}

# Select the computername and the name, path and comment of the share and Export
$AllComputerShares |Select-Object -Property PSComputerName,Name,Path,Description |Export-Csv -Path C:\Where\Ever\You\Like.csv -NoTypeInformation