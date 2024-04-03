@{
    GUID = 'c85588a4-1180-4635-ba9e-a04581bf10c8'
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."
    ModuleVersion = '1.0.0.0'
    PowerShellVersion = '3.0'
    FormatsToProcess = 'StorageBusCache.format.ps1xml'
    TypesToProcess = 'StorageBusCache.types.ps1xml'
    NestedModules = @(
        'StorageBusCache.psm1'
        )

    CmdletsToExport = @()
    FunctionsToExport = @(
        'Clear-StorageBusDisk',
        'Disable-StorageBusCache',
        'Disable-StorageBusDisk',
        'Enable-StorageBusCache',
        'Enable-StorageBusDisk',
        'Get-StorageBusDisk',
        'Get-StorageBusBinding',
        'New-StorageBusCacheStore',
        'New-StorageBusBinding',
        'Remove-StorageBusBinding',
        'Resume-StorageBusDisk',
        'Set-StorageBusProfile',
        'Suspend-StorageBusDisk')
}


