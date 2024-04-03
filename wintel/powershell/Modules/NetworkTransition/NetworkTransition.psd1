
@{
    ModuleVersion = '1.0.0.0'
    NestedModules = @("MSFT_Net6to4Configuration.cdxml", "MSFT_NetDnsTransitionConfiguration.cdxml", "MSFT_NetDnsTransitionMonitoring.cdxml", "MSFT_NetIpHTTPsConfiguration.cdxml", "MSFT_NetIpHTTPsState.cdxml", "MSFT_NetISATAPConfiguration.cdxml", "MSFT_NetNatTransitionConfiguration.cdxml", "MSFT_NetNatTransitionMonitoring.cdxml", "MSFT_NetTeredoConfiguration.cdxml", "MSFT_NetTeredoState.cdxml")
    FormatsToProcess = @("MSFT_Net6to4Configuration.format.ps1xml", "MSFT_NetDnsTransitionConfiguration.format.ps1xml", "MSFT_NetDnsTransitionMonitoring.format.ps1xml", "MSFT_NetIpHTTPsConfiguration.format.ps1xml", "MSFT_NetIpHTTPsState.format.ps1xml", "MSFT_NetISATAPConfiguration.format.ps1xml", "MSFT_NetNatTransitionConfiguration.format.ps1xml", "MSFT_NetNatTransitionMonitoring.format.ps1xml", "MSFT_NetTeredoConfiguration.format.ps1xml", "MSFT_NetTeredoState.format.ps1xml")
    TypesToProcess = @("MSFT_Net6to4Configuration.types.ps1xml", "MSFT_NetDnsTransitionConfiguration.types.ps1xml", "MSFT_NetIpHTTPsConfiguration.types.ps1xml", "MSFT_NetISATAPConfiguration.types.ps1xml", "MSFT_NetNatTransitionConfiguration.types.ps1xml", "MSFT_NetTeredoConfiguration.types.ps1xml")
    HelpInfoUri = "http://go.microsoft.com/fwlink/?LinkId=285559"
    GUID = '{EFF9CCF9-53ED-423d-B0DA-23E6772AACAA}'
    Author = 'Microsoft Corporation'
    CompanyName = 'Microsoft Corporation'
    PowerShellVersion = '5.1'
    Copyright = '© Microsoft Corporation. All rights reserved.'
    FunctionsToExport = @("Add-NetIPHttpsCertBinding", "Disable-NetDnsTransitionConfiguration", "Disable-NetIPHttpsProfile", "Disable-NetNatTransitionConfiguration", "Enable-NetDnsTransitionConfiguration", "Enable-NetIPHttpsProfile", "Enable-NetNatTransitionConfiguration", "Get-Net6to4Configuration", "Get-NetDnsTransitionConfiguration", "Get-NetDnsTransitionMonitoring", "Get-NetIPHttpsConfiguration", "Get-NetIPHttpsState", "Get-NetIsatapConfiguration", "Get-NetNatTransitionConfiguration", "Get-NetNatTransitionMonitoring", "Get-NetTeredoConfiguration", "Get-NetTeredoState", "New-NetIPHttpsConfiguration", "New-NetNatTransitionConfiguration", "Remove-NetIPHttpsCertBinding", "Remove-NetIPHttpsConfiguration", "Remove-NetNatTransitionConfiguration", "Rename-NetIPHttpsConfiguration", "Reset-Net6to4Configuration", "Reset-NetDnsTransitionConfiguration", "Reset-NetIPHttpsConfiguration", "Reset-NetIsatapConfiguration", "Reset-NetTeredoConfiguration", "Set-Net6to4Configuration", "Set-NetDnsTransitionConfiguration", "Set-NetIPHttpsConfiguration", "Set-NetIsatapConfiguration", "Set-NetNatTransitionConfiguration", "Set-NetTeredoConfiguration")
    CmdletsToExport = @()
    AliasesToExport = @()
    CompatiblePSEditions = @('Desktop', 'Core')
}
