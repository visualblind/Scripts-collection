@{
    GUID = "80CB11CF-96B5-4D48-84BD-F85F65DE78AE"
    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    ModuleVersion = "1.0.0.0"
    PowerShellVersion = '5.1'
    HelpInfoUri = "http://go.microsoft.com/fwlink/?linkid=524348"

    NestedModules = @(
        'MSFT_EtwTraceSession_v1.0.cdxml',
        'MSFT_EtwTraceProvider_v1.0.cdxml',
        'MSFT_AutologgerConfig_v1.0.cdxml',
        'EventTracingManagement.psm1')

    FormatsToProcess = @(
        'MSFT_AutologgerConfig_v1.0.format.ps1xml',
        'MSFT_EtwTraceProvider_v1.0.format.ps1xml',
        'MSFT_EtwTraceSession_v1.0.format.ps1xml')

    TypesToProcess = @('EventTracingManagement.Types.ps1xml')

    FunctionsToExport = @(
        'Start-EtwTraceSession',
        'New-EtwTraceSession',
        'Get-EtwTraceSession',
        'Update-EtwTraceSession',
        'Set-EtwTraceSession',
        'Send-EtwTraceSession',
        'Save-EtwTraceSession',
        'Flush-EtwTraceSession',
        'Stop-EtwTraceSession',
        'Remove-EtwTraceSession',
        'Add-EtwTraceProvider',
        'Get-EtwTraceProvider',
        'Set-EtwTraceProvider',
        'Remove-EtwTraceProvider',
        'New-AutologgerConfig',
        'Get-AutologgerConfig',
        'Update-AutologgerConfig',
        'Set-AutologgerConfig',
        'Start-AutologgerConfig',
        'Remove-AutologgerConfig')
    CompatiblePSEditions = @('Desktop', 'Core')
}
