@{
    GUID = "80cf4c6d-30b7-4b0f-a035-dbb23a65ef1d"
    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    HelpInfoUri = "https://go.microsoft.com/fwlink/?linkid=285763"
    ModuleVersion = "2.0.0.0"
    PowerShellVersion = '5.1'
    NestedModules = @('MSFT_NetLbfoTeam.cdxml', 'MSFT_NetLbfoTeamMember.cdxml', 'MSFT_NetLbfoTeamNic.cdxml')
    FormatsToProcess = @('MSFT_NetLbfoTeam.format.ps1xml', 'MSFT_NetLbfoTeamMember.format.ps1xml', 'MSFT_NetLbfoTeamNic.format.ps1xml')
    TypesToProcess = @('NetLbfo.Types.ps1xml')
    FunctionsToExport = @(
        'Add-NetLbfoTeamMember',
        'Add-NetLbfoTeamNic',
        'Get-NetLbfoTeam',
        'Get-NetLbfoTeamMember',
        'Get-NetLbfoTeamNic',
        'New-NetLbfoTeam',
        'Remove-NetLbfoTeam',
        'Remove-NetLbfoTeamMember',
        'Remove-NetLbfoTeamNic',
        'Rename-NetLbfoTeam',
        'Set-NetLbfoTeam',
        'Set-NetLbfoTeamMember',
        'Set-NetLbfoTeamNic'
    )
    CmdletsToExport = @()
    AliasesToExport = @()
    CompatiblePSEditions = @('Desktop', 'Core')
}
