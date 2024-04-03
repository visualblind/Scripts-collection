@{
    PowerShellVersion = '5.1'

    GUID='d57aee1e-6fe7-4bbc-8c57-8675a3a83e0d'
    ModuleVersion='1.0.0.0'
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."

    HelpInfoUri="https://go.microsoft.com/fwlink/?linkid=390757"

    FormatsToProcess = 'BranchCache.format.ps1xml'
    TypesToProcess = 'BranchCache.types.ps1xml'

    NestedModules = @('BranchCacheClientSettingData.cdxml', 'BranchCacheContentServerSettingData.cdxml', 'BranchCacheHostedCacheServerSettingData.cdxml', 'BranchCacheNetworkSettingData.cdxml', 'BranchCacheOrchestrator.cdxml', 'BranchCachePrimaryPublicationCacheFile.cdxml', 'BranchCachePrimaryRepublicationCacheFile.cdxml', 'BranchCacheSecondaryRepublicationCacheFile.cdxml', 'BranchCacheStatus.cdxml')

    FunctionsToExport = @('Add-BCDataCacheExtension', 'Clear-BCCache', 'Disable-BC', 'Disable-BCDowngrading', 'Disable-BCServeOnBattery', 'Enable-BCDistributed', 'Enable-BCDowngrading', 'Enable-BCHostedClient', 'Enable-BCHostedServer', 'Enable-BCLocal', 'Enable-BCServeOnBattery', 'Export-BCCachePackage', 'Export-BCSecretKey', 'Get-BCClientConfiguration', 'Get-BCContentServerConfiguration', 'Get-BCHostedCacheServerConfiguration', 'Get-BCNetworkConfiguration', 'Get-BCHashCache', 'Get-BCDataCache', 'Get-BCDataCacheExtension', 'Get-BCStatus', 'Import-BCCachePackage', 'Import-BCSecretKey', 'Publish-BCFileContent', 'Publish-BCWebContent', 'Remove-BCDataCacheExtension', 'Reset-BC', 'Set-BCAuthentication', 'Set-BCCache', 'Set-BCMinSMBLatency', 'Set-BCSecretKey', 'Set-BCDataCacheEntryMaxAge')

    CmdletsToExport = @()
    AliasesToExport = @()
    CompatiblePSEditions = @('Desktop', 'Core')
}
