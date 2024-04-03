@{
    GUID = '53E1C251-4283-4B07-AB02-FC492C7AB8C5'
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."
    ModuleVersion = '1.0.0.0'
    PowerShellVersion = '3.0'
    FormatsToProcess = @()
    TypesToProcess = @()
    NestedModules = @("iSCSIConnection.cdxml", "iSCSISession.cdxml", "iSCSITarget.cdxml", "iSCSITargetPortal.cdxml")
    AliasesToExport = @()
    FunctionsToExport = @(
    'Get-IscsiTargetPortal',
    'New-IscsiTargetPortal',
    'Remove-IscsiTargetPortal',
    'Update-IscsiTargetPortal',
    'Get-IscsiTarget',
    'Connect-IscsiTarget',
    'Disconnect-IscsiTarget',
    'Update-IscsiTarget',
    'Get-IscsiSession',
    'Register-IscsiSession',
    'Unregister-IscsiSession',
    'Get-IscsiConnection',
    'Set-IscsiChapSecret')
    HelpInfoUri="https://go.microsoft.com/fwlink/?linkid=390778"
}
