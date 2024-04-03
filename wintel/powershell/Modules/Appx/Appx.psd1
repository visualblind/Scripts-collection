@{
    GUID = "{AEEF2BEF-EBA9-4A1D-A3D2-D0B52DF76DEB}"
    AliasesToExport = @(
        'Add-AppPackage',
        'Get-AppPackage',
        'Get-AppPackageManifest',
        'Remove-AppPackage',
        'Get-AppPackageVolume',
        'Add-AppPackageVolume',
        'Remove-AppPackageVolume',
        'Mount-AppPackageVolume',
        'Dismount-AppPackageVolume',
        'Move-AppPackage',
        'Get-AppPackageDefaultVolume',
        'Set-AppPackageDefaultVolume',
        'Get-AppPackageLastError',
        'Get-AppPackageLog'
    )
    Author = "Microsoft Corporation"
    CmdletsToExport = 'Add-AppxPackage', 'Get-AppxPackage', 'Get-AppxPackageManifest', 'Remove-AppxPackage', 'Get-AppxVolume', 'Add-AppxVolume', 'Remove-AppxVolume', 'Mount-AppxVolume', 'Dismount-AppxVolume', 'Move-AppxPackage', 'Get-AppxDefaultVolume', 'Set-AppxDefaultVolume', 'Invoke-CommandInDesktopPackage'
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    FunctionsToExport = 'Get-AppxLastError', 'Get-AppxLog'
    HelpInfoUri="https://go.microsoft.com/fwlink/?linkid=849912"
    ModuleVersion = "2.0.1.0"
    ModuleToProcess = 'Microsoft.Windows.Appx.PackageManager.Commands'
    FormatsToProcess = 'Appx.format.ps1xml'
    NestedModules = 'Appx.psm1'
    CompatiblePSEditions = @('Desktop','Core')
    PowerShellVersion="5.1"
}
