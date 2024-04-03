@{
    GUID = 'B47767EC-A4D6-488D-915D-5070791AC6D4'
    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    ModuleVersion = '1.0.0.0'
    PowerShellVersion = '5.1'
    NestedModules = @(
        'MSFT_NetVirtualizationProviderAddressSettingData.cdxml', 
        'MSFT_NetVirtualizationGlobalSettingData.cdxml', 
        'MSFT_NetVirtualizationLookupRecordSettingData.cdxml', 
        'MSFT_NetVirtualizationCustomerRouteSettingData.cdxml',
        'MSFT_NetVirtualizationProviderRouteSettingData.cdxml',
        'MSFT_NetVirtualizationNextHopLookup.cdxml'
        )
    FormatsToProcess = @('Wnv.Format.ps1xml')
    TypesToProcess = @('Wnv.Types.ps1xml')
    HelpInfoUri = "https://go.microsoft.com/fwlink/?linkid=390803"
    FunctionsToExport = @(
        'Get-NetVirtualizationProviderAddress',
        'Get-NetVirtualizationGlobal',
        'Get-NetVirtualizationLookupRecord',
        'Get-NetVirtualizationCustomerRoute',
        'Get-NetVirtualizationProviderRoute',
        'Set-NetVirtualizationProviderAddress',
        'Set-NetVirtualizationGlobal',
        'Set-NetVirtualizationLookupRecord',
        'Set-NetVirtualizationCustomerRoute',
        'Set-NetVirtualizationProviderRoute',
        'New-NetVirtualizationProviderAddress',
        'New-NetVirtualizationLookupRecord',
        'New-NetVirtualizationCustomerRoute',
        'New-NetVirtualizationProviderRoute',
        'Remove-NetVirtualizationProviderAddress',
        'Remove-NetVirtualizationLookupRecord',
        'Remove-NetVirtualizationCustomerRoute',
        'Remove-NetVirtualizationProviderRoute'
        'Select-NetVirtualizationNextHop'        
        )
    AliasesToExport = @()
    CmdletsToExport = @()
    CompatiblePSEditions = @('Desktop', 'Core')
}
