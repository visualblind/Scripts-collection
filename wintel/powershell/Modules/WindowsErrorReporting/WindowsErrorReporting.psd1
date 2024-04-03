@{
    GUID = "{4BC4DED7-249B-41AC-973F-83AF4D25D82B}"
    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    HelpInfoUri = "https://go.microsoft.com/fwlink/?linkid=390850"
    ModuleVersion = "1.0"
    PowerShellVersion = '5.1'
    ClrVersion = "4.0"
    RootModule = "WindowsErrorReporting.psm1"
    NestedModules = "Microsoft.WindowsErrorReporting.PowerShell.dll"
    TypesToProcess = @()
    FormatsToProcess = @()
    CmdletsToExport = @(
        'Enable-WindowsErrorReporting',
        'Disable-WindowsErrorReporting',
        'Get-WindowsErrorReporting'
    )
    AliasesToExport = @()
    CompatiblePSEditions = @('Desktop', 'Core')
}
