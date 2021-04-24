while($true){
    $Timeout = "1000.00"
    $Name = "google.com"
    $Ping = New-Object System.Net.NetworkInformation.Ping
    $Response = $Ping.Send($Name,$Timeout)
#    Write-Host "Common output:"
    Write-Host $Response.RoundtripTime
#    Write-Host "Resonse time (ms): " $Response.RoundtripTime
#    Write-Host "IPv4 Address: "$Response.Address.IPAddressToString
    Write-Host "Success/Timed out?: "$Response.Status
#    Write-Host "Detailed output:"

}
$Response.Address