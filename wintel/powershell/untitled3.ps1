#Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
Connect-VIServer vcsa67.ad.sysinfo.io
#Get-VIServer
Pushd $env:USERPROFILE\Documents
get-snapshot -VM * | Select Created, Name, VM, @{Name="Snapshot Size (GB)";Expression={[math]::Round($_.SizeGB)}}, Description, ParentSnapshot, Parent, VMId, PowerState | ft -AutoSize | Tee-Object -file snapshots-prod.txt

Get-Snapshot -VM * | ft -AutoSize


$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration | ? { $_.IPEnabled -eq "True" -and $_.IPAddress -eq "10.10.10.74" } | fl

foreach  ( $NIC in $NICs ) {

 $NIC.SetDynamicDNSRegistration("0")
 $NIC.DomainDNSRegistrationEnabled("0")

}

Clear-Variable NICs
Clear-Variable NIC



Get-NetIPConfiguration | ? {$_.InterfaceAlias -eq 'Ethernet1'} | Get-NetConnectionProfile | Set-DnsClient -RegisterThisConnectionsAddress:$False