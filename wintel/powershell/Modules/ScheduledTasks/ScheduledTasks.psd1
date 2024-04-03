
@{
    GUID = '5378EE8E-E349-49BB-83B9-F3D9C396C0A6'

    Author = 'Microsoft Corporation'

    CompanyName = 'Microsoft Corporation'

    ClrVersion = '4.0'
    
    Copyright = '© Microsoft Corporation. All rights reserved.'

    ModuleVersion = '1.0.0.0'

    PowerShellVersion = '5.1'

    HelpInfoUri = "https://go.microsoft.com/fwlink/?linkid=390822"

    NestedModules = @( 'MSFT_ScheduledTask_v1.0.cdxml', 
                       'PS_ScheduledTask_v1.0.cdxml', 
                       'PS_ClusteredScheduledTask_v1.0.cdxml')

    TypesToProcess = @( 'MSFT_ScheduledTask.types.ps1xml',
                        'PS_ScheduledTask.types.ps1xml' )

    FormatsToProcess = @( 'MSFT_ScheduledTask.format.ps1xml' )

    AliasesToExport = @()

    CmdletsToExport = @()

    FunctionsToExport = @( 'Get-ScheduledTask', 
                           'Set-ScheduledTask', 
                           'Register-ScheduledTask', 
                           'Unregister-ScheduledTask',
                           'Enable-ScheduledTask', 
                           'Disable-ScheduledTask',
                           'Export-ScheduledTask',
                           'New-ScheduledTask',
                           'New-ScheduledTaskAction', 
                           'New-ScheduledTaskPrincipal', 
                           'New-ScheduledTaskSettingsSet', 
                           'New-ScheduledTaskTrigger', 
                           'Start-ScheduledTask', 
                           'Stop-ScheduledTask',
                           'Get-ScheduledTaskInfo'
                           'Get-ClusteredScheduledTask', 
                           'Set-ClusteredScheduledTask', 
                           'Register-ClusteredScheduledTask',
                           'Unregister-ClusteredScheduledTask' )
    CompatiblePSEditions = @('Desktop', 'Core')
}
