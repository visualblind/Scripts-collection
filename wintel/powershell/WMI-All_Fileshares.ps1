
$ComputerNames = Get-ADComputer -Filter "name -like '*'" -Properties dNSHostName |Select-Object -ExpandProperty dNSHostName



$AllComputerShares = @()

foreach($Computer in $ComputerNames)
{
    try{
        $Shares = Get-WmiObject -ComputerName $Computer -Class Win32_Share -ErrorAction Stop
        $AllComputerShares += $Shares
    }
    catch{
        Write-Error "Failed to connect retrieve Shares from $Computer"
    }
}

# Select the computername and the name, path and comment of the share and Export
$AllComputerShares |Select-Object -Property PSComputerName,Name,Path,Description | ft -Autosize | Tee-Object -file C:\Users\trunyard\Desktop\TSTGTVCLO.txt | Export-Csv -Path C:\Users\trunyard\Desktop\TSTGTVCLO.csv -NoTypeInformation