$webClient = New-Object System.Net.WebClient
$webString = $webClient.DownloadString("https://sysinfo.io/scripts/")

write-host $webstring