@{  
    GUID = "{B9AF2675-4726-42FD-ADAB-38228176A516}"  
    Author = "Microsoft Corporation"  
    CLRVersion = "4.0"  
    CompanyName = "Microsoft Corporation"  
    Copyright = "(c) Microsoft Corporation. All rights reserved."  
    AliasesToExport = @()  
    FunctionsToExport = @()  
    CmdletsToExport = "Get-DeliveryOptimizationStatus", 
                      "Get-DeliveryOptimizationPerfSnap", 
                      "Get-DeliveryOptimizationLog", 
                      "Get-DOConfig",
                      "Get-DODownloadMode", 
                      "Set-DODownloadMode", 
                      "Get-DOPercentageMaxForegroundBandwidth", 
                      "Set-DOPercentageMaxForegroundBandwidth", 
                      "Get-DOPercentageMaxBackgroundBandwidth", 
                      "Set-DOPercentageMaxBackgroundBandwidth", 
                      "Get-DeliveryOptimizationPerfSnapThisMonth"
    PowerShellVersion = '5.1'
    ModuleVersion = "1.0.1.0"
    ModuleToProcess = "Microsoft.Windows.DeliveryOptimization.AdminCommands"  
    CompatiblePSEditions = @('Desktop')
}
