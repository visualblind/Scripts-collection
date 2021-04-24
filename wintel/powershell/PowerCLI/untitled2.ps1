Get-Vm

$AllSnapShots = Get-View -ViewType virtualmachine -Property snapshot `
-Filter @{"Snapshot"="VMware.Vim.VirtualMachineSnapshotInfo"}