Connect-VIServer Server1
Disconnect-VIServer Server1

Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer -Server YourvCenterServerName
Get-VM  | `
  Get-Snapshot |  `
  Where-Object { $_.Created -lt (Get-Date).AddDays(-30) } | `
  Remove-Snapshot -Confirm:$False -Whatif



# Connect to vSphere vCenter Server
Try{
    Connect-VIServer Server1
}
Catch{
    Write-Host "Failed Connecting to VSphere Server."
    #Send-MailMessage -From "" -To "server@domain.com" -Subject "Unable to Connect to VSphere to clean snapshots" -Body `
    # "The powershell script is unable to connect to host your.vmware.server. Please investigate." -SmtpServer "smtp.server.com"
    Break
}
# Variables
$date = get-date -f MMddhhyyyy
$logpath = "E:\Scripts\Script_Logs"

$oneMonthAgo = (Get-Date).AddDays(-30)
Get-VM | Foreach-Object {
Get-Snapshot -VM $_ | Foreach-Object {
if($_.Created -lt $oneMonthAgo) {
Remove-Snapshot $_ -Confirm -WhatIf
}}}



Get-Snapshot -Name "VirtualMachineSnapshot-snapshot-106734"
Get-VM | Get-Snapshot | Select VM, Name, Id

Get-VM  | Get-Snapshot | ? { $_.Created -lt (Get-Date).AddDays(-30) } | Select Created, Name, VM, @{Name="Snapshot Size (GB)";Expression={[math]::Round($_.SizeGB)}}, Description, ParentSnapshot, Parent, VMId, PowerState | ft -AutoSize

