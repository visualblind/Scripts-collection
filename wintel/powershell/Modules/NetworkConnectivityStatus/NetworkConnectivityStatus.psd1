
@{
    ModuleVersion = '1.0.0.0'
    NestedModules = @("MSFT_DAConnectionStatus.cdxml", "MSFT_NCSIPolicyConfiguration.cdxml")
    FormatsToProcess = @("MSFT_DAConnectionStatus.format.ps1xml", "MSFT_NCSIPolicyConfiguration.format.ps1xml")
    TypesToProcess = @("MSFT_DAConnectionStatus.types.ps1xml")
    HelpInfoUri = "http://go.microsoft.com/fwlink/?LinkId=285557"
    GUID = '{6C9A449B-B0C6-4386-B139-EE0A55638803}'
    Author = 'Microsoft Corporation'
    CompanyName = 'Microsoft Corporation'
    PowerShellVersion = '5.1'
    Copyright = '© Microsoft Corporation. All rights reserved.'
    FunctionsToExport = @("Get-DAConnectionStatus", "Get-NCSIPolicyConfiguration", "Reset-NCSIPolicyConfiguration", "Set-NCSIPolicyConfiguration")
    CmdletsToExport = @()
    AliasesToExport = @()
    CompatiblePSEditions = @('Desktop', 'Core')
}
