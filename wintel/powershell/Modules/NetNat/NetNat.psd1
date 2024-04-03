@{
    GUID = 'E5439F56-42AA-4FDF-8705-50C782A89345'
    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    ModuleVersion = '1.0.0.0'
    PowerShellVersion = '5.1'
    NestedModules = @(
        'MSFT_NetNat.cdxml', 
        'MSFT_NetNatExternalAddress.cdxml', 
        'MSFT_NetNatStaticMapping.cdxml', 
        'MSFT_NetNatSession.cdxml'
        'MSFT_NetNatGlobal.cdxml'
        )
    FormatsToProcess = @('MSFT_NetNat.Format.ps1xml')
    TypesToProcess = @('MSFT_NetNat.Types.ps1xml')
    HelpInfoUri = "https://go.microsoft.com/fwlink/?linkid=285219"
    FunctionsToExport = @(
        'Get-NetNat',
        'Get-NetNatExternalAddress',
        'Get-NetNatStaticMapping',
        'Get-NetNatSession',
        'Get-NetNatGlobal',
        'Set-NetNat',
        'Set-NetNatGlobal',
        'New-NetNat',
        'Add-NetNatExternalAddress',
        'Add-NetNatStaticMapping',
        'Remove-NetNat',
        'Remove-NetNatExternalAddress',
        'Remove-NetNatStaticMapping'
        )
    CompatiblePSEditions = @('Desktop', 'Core')
}
