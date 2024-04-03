@{
    GUID = '3389cc73-daa3-4d25-bd50-b1730925d2df'
    Author = 'Microsoft Corporation'
    CompanyName = 'Microsoft Corporation'
    Copyright = '© Microsoft Corporation. All rights reserved.'
    ModuleVersion = '2.0.0.0'
    PowerShellVersion = '5.1'

    FormatsToProcess = 'VpnClientPsProvider.Format.ps1xml'
    TypesToProcess = 'VpnClientPSProvider.Types.ps1xml'

    HelpInfoUri="http://go.microsoft.com/fwlink/?linkid=390842"
		    
    NestedModules = @("PS_VpnConnection_v1.0.0.cdxml", "PS_EapConfiguration_v1.0.0.cdxml", "PS_VpnConnectionProxy_v1.0.cdxml", "PS_VpnServerAddress_v1.0.cdxml", "PS_VpnConnectionRoute_v1.0.cdxml", "PS_VpnConnectionIPsecConfiguration_v1.0.cdxml", "PS_VpnConnectionTrigger_v1.0.cdxml", "PS_VpnConnectionTriggerApplication_v1.0.cdxml","PS_VpnConnectionTriggerDnsConfiguration_v1.0.cdxml","PS_VpnConnectionTriggerTrustedNetwork_v1.0.cdxml")

    AliasesToExport = @()
    CmdletsToExport = @()
    FunctionsToExport = @("Add-VpnConnection", "Set-VpnConnection", "Remove-VpnConnection", "Get-VpnConnection", "New-EapConfiguration", "Set-VpnConnectionProxy", "New-VpnServerAddress", "Add-VpnConnectionRoute", "Remove-VpnConnectionRoute", "Set-VpnConnectionIPsecConfiguration", "Add-VpnConnectionTriggerApplication","Remove-VpnConnectionTriggerApplication","Add-VpnConnectionTriggerDnsConfiguration","Remove-VpnConnectionTriggerDnsConfiguration","Set-VpnConnectionTriggerDnsConfiguration", "Get-VpnConnectionTrigger", "Add-VpnConnectionTriggerTrustedNetwork", "Remove-VpnConnectionTriggerTrustedNetwork", "Set-VpnConnectionTriggerTrustedNetwork")
    CompatiblePSEditions = @('Desktop', 'Core')
}
