Connect-VIServer SERVER1

Pushd $env:USERPROFILE
cd Documents
get-snapshot -VM * | Select Created, Name, VM, @{Name="Snapshot Size (GB)";Expression={[math]::Round($_.SizeGB)}}, Description, ParentSnapshot, Parent, VMId, PowerState | ft -AutoSize | Tee-Object -file snapshots-prod.txt

VM | Sort-Object MemoryGB -Descending
VM -Name SERVER2 | fl