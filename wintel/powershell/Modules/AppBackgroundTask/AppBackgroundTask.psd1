@{
    GUID = '{eb40bd55-3bab-4fa6-88ee-0dcf3cad5a25}'
    Author = 'Microsoft Corporation'
    CompanyName = 'Microsoft Corporation'
    Copyright = '© Microsoft Corporation. All rights reserved.'
    ModuleVersion = '1.0.0.0'
    PowerShellVersion = '3.0'
    HelpInfoUri = "https://go.microsoft.com/fwlink/?LinkID=286813"
    
    NestedModules = @(
	"PS_BackgroundTask.cdxml",
	"microsoft.windows.appbackgroundtask.commands.dll")
    FunctionsToExport = @(
	"Unregister-AppBackgroundTask",
	"Get-AppBackgroundTask",
	"Start-AppBackgroundTask"
    )
    AliasesToExport = @(
	'iru',
	'pfn',
	'tid'
    )
    CmdletsToExport = @(
        "Disable-AppBackgroundTaskDiagnosticLog",
	"Enable-AppBackgroundTaskDiagnosticLog",
	"Set-AppBackgroundTaskResourcePolicy"
    )
    FormatsToProcess = @( 
	'MSFT_BackgroundTask.Format.ps1xml' 
    )
}
