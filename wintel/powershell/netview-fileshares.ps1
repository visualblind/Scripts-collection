$Servers = ( Get-ADComputer -Filter { DNSHostName -Like '*' }  | Select -Expand Name )
foreach ($Server in $Servers)
{
    (net view $Server) | % { if($_.IndexOf(' Disk ') -gt 0){ $_.Split('      ')[0] } } | out-file -Append C:\Users\trunyard\test.txt
}