#Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
Connect-VIServer vcsa67.ad.sysinfo.io
#Get-VIServer
Pushd $env:USERPROFILE\Documents
get-snapshot -VM * | Select Created, Name, VM, @{Name="Snapshot Size (GB)";Expression={[math]::Round($_.SizeGB)}}, Description, ParentSnapshot, Parent, VMId, PowerState | ft -AutoSize | Tee-Object -file snapshots-prod.txt

Get-Snapshot -VM * | ft -AutoSize
