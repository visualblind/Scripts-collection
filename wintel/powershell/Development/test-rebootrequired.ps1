#${function:Test-RebootRequired}

$params = @{
    ComputerName = "win2016core-2"
    Credential = Get-Credential -UserName "SYSINFO\visualblind" -Message "Enter Password"
    Authentication = "Default"
    ScriptBlock = ${function:Test-RebootRequired}
}

#Check Reboot is required to remote computer
$isRebootRequired = Invoke-Command @params

if($isRebootRequired -eq $true)
{
    #Restart and wait until WinRM available
    Restart-Computer -ComputerName $params.ComputerName -Credential $params.Credential -WsmanAuthentication Default -Force -Wait -For WinRM
}

#Check Reboot is required to remote computer
$isRebootRequired = Invoke-Command @params
if($isRebootRequired -eq $true)
{
    throw "Reboot required once more!"
}


get-item wsman:\localhost\Client\TrustedHosts
set-item wsman:\localhost\Client\TrustedHosts -value win2016core-1



$TrustedHosts = get-item wsman:\localhost\Client\TrustedHosts

set-item wsman:\localhost\Client\TrustedHosts -value ""
set-item wsman:\localhost\Client\TrustedHosts -value "win2016core-1"
set-item wsman:\localhost\Client\TrustedHosts -value $TrustedHosts.value + win2016core-2


$curValue = (get-item wsman:\localhost\Client\TrustedHosts).value
set-item wsman:\localhost\Client\TrustedHosts -value $curValue, win2016core-2
set-item wsman:\localhost\Client\TrustedHosts -value win2016core-2 -Concatenate