@{
    GUID = 'e1383a06-d48b-45e0-81e4-5ead146e81a8'

    NestedModules = @('ps_mmagent_v1.0.cdxml')

    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    PowerShellVersion = '5.1'
    HelpInfoUri = "https://go.microsoft.com/fwlink/?linkid=285551"

    FormatsToProcess = @()
    TypesToProcess = @()

    ModuleVersion = '1.0'

    AliasesToExport = @()
    CmdletsToExport = @()
    FunctionsToExport = @('Disable-MMAgent', 'Enable-MMAgent', 'Set-MMAgent', 'Get-MMAgent', 'Debug-MMAppPrelaunch')
    CompatiblePSEditions = @('Desktop', 'Core')
}
