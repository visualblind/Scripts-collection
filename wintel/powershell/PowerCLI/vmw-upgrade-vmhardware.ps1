$spec = New-Object -TypeName VMware.Vim.VirtualMachineConfigSpec
$spec.ScheduledHardwareUpgradeInfo = New-Object -TypeName VMware.Vim.ScheduledHardwareUpgradeInfo
$spec.ScheduledHardwareUpgradeInfo.UpgradePolicy = "onSoftPowerOff"
$spec.ScheduledHardwareUpgradeInfo.VersionKey = "vmx-13"

Get-Cluster -Name MyCluster | Get-VM | %{
    $_.ExtensionData.ReconfigVM_Task($spec)
}

