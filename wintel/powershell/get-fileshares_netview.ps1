$Servers = ( Get-ADComputer -Filter { (DNSHostName -Like '*') -and (Enabled -eq $true) }  | Select -Expand Name )
foreach ($Server in $Servers)
{
    (net view $Server) | % { if($_.IndexOf(' Disk ') -gt 0){ $_.Split('      ')[0] } } | out-file C:\file_shares\$Server.txt
}