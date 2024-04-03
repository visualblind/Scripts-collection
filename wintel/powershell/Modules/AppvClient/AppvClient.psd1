@{
ModuleVersion = '1.0.0.0'

GUID = '596D7B43-928B-44D4-89E7-17D34740ECC2'                

Author = 'Microsoft Corporation'

CompanyName = 'Microsoft Corporation'

Copyright = '© Microsoft Corporation. All rights reserved.'

Description = 'Microsoft Application Virtualization Client Module'

RequiredAssemblies = 'Microsoft.AppV.AppvClientComConsumer.dll'
									
NestedModules = 'Microsoft.AppV.AppVClientPowerShell', 'AppVClientCmdlets.psm1'

ProcessorArchitecture = 'x86'

# Location from which to download updateable help
HelpInfoURI = "https://go.microsoft.com/fwlink/?LinkId=403112 "

FunctionsToExport = 'Get-AppvVirtualProcess', 'Start-AppvVirtualProcess'

}
