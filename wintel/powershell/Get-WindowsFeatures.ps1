Invoke-Command -ComputerName win2012-dc4 {
Set-NetFirewallRule -DisplayGroup 'Remote Event Log Management' -Enabled True -PassThru |
select DisplayName, Enabled
} -Credential (Get-Credential)

Invoke-Command -ComputerName win2012-dc4 {
Get-WindowsFeature | where-object {$_.Installed -eq $True} } -Credential (get-credential)