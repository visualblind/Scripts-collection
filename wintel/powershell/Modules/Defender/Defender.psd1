
@{
    GUID = 'C46BE3DC-30A9-452F-A5FD-4BF9CA87A854'
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."
    ModuleVersion = '1.0'
    NestedModules = @( 'MSFT_MpComputerStatus.cdxml',
                       'MSFT_MpPreference.cdxml',
                       'MSFT_MpThreat.cdxml',
                       'MSFT_MpThreatCatalog.cdxml',
                       'MSFT_MpThreatDetection.cdxml', 
                       'MSFT_MpScan.cdxml',
                       'MSFT_MpSignature.cdxml',
                       'MSFT_MpWDOScan.cdxml')


    AliasesToExport = @()
    FunctionsToExport = @( 'Get-MpPreference',
                           'Set-MpPreference',
                           'Add-MpPreference',
                           'Remove-MpPreference',
                           'Get-MpComputerStatus',
                           'Get-MpThreat',
                           'Get-MpThreatCatalog',
                           'Get-MpThreatDetection',
                           'Start-MpScan',
                           'Update-MpSignature',
                           'Remove-MpThreat',
                           'Start-MpWDOScan')

    PowerShellVersion = '5.1'
    HelpInfoUri="https://go.microsoft.com/fwlink/?linkid=390762"
    CompatiblePSEditions = @('Desktop', 'Core')
}
