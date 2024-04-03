<#
Copyright (C) Microsoft. All rights reserved.
#>

#requires -version 5.1

#.ExternalHelp Microsoft.Windows.Appx.PackageManager.Commands.dll-help.xml
Function Get-AppxLastError()
{
    [CmdletBinding(HelpUri="https://go.microsoft.com/fwlink/?LinkId=246401")]
    param()

    Import-LocalizedData -bindingVariable msgTable

    # Search for last Add-AppxPackage related error
    foreach ($err in $global:Error)
    {
        if ($err.FullyQualifiedErrorId -match
            "DeploymentError,Microsoft.Windows.Appx.PackageManager.Commands.AddAppxPackageCommand")
        {
            $command = (Get-History | ? {$_.CommandLine -imatch 
                "Add-AppxPackage"} |Select-Object -Last 1).CommandLine;

            # Read ActivityId from the Exception record
            if ($err.Exception -imatch 
                "\[ActivityId\] ([0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})")
            {
                Write-Host($msgTable.EventLogsFor + ' "' + $command + '"');
                # Retrieve Event Log messages for ActivityId                
                Get-WinEvent -LogName Microsoft-Windows-Appx* -Oldest |
                    Where-Object {$_.Activityid -eq $matches[1]} |
                    ForEach-Object{
                        $null = $_.pstypenames.clear()
                        $null = $_.pstypenames.add('AppxDeploymentEventLog')
                        $_
                    }
                break;
            }
        }
    }
}

#.ExternalHelp Microsoft.Windows.Appx.PackageManager.Commands.dll-help.xml
Function Get-AppxLog()
{
    [CmdletBinding(DefaultParameterSetName="All",
        HelpUri="https://go.microsoft.com/fwlink/?LinkId=246400")]
    param([switch][parameter(parametersetname="All")]$All,
          [string][parameter(parametersetname="ActivityId")]$ActivityId)

    switch($PsCmdlet.ParameterSetName)
    {
    "All"
    {
        if ($All)
        {
            # Get all deployment events
            $logevents = Get-WinEvent -log Microsoft-Windows-AppxDeploy*

            # Select only unique activity IDs of deployment events
            $activityids = $logevents |% {$_.activityid} | select -unique

            # Grab all logs associated with Appx Deployment
            $logevents = Get-WinEvent -log Microsoft-Windows-Appx*
            [array]::Reverse($logevents)
            foreach($id in $activityids)
            {
                $logevents |
                    Where-Object {$_.activityid -eq $id} |
                    ForEach-Object{
                        $null = $_.pstypenames.clear()
                        $null = $_.pstypenames.add('AppxDeploymentEventLog')
                        $_
                    }
            }
        }
        else
        {
            $ActivityId = get-winevent -log Microsoft-Windows-AppxDeploy* -max 1 |% {$_.ActivityId}
            Get-WinEvent -log Microsoft-Windows-Appx* -oldest |
                Where-Object {$_.activityid -eq $ActivityId} |
                ForEach-Object{
                        $null = $_.pstypenames.clear()
                        $null = $_.pstypenames.add('AppxDeploymentEventLog')
                        $_
                }

        }
    }
    "ActivityId" { Get-WinEvent -log Microsoft-Windows-Appx* -oldest |
            Where-Object {$_.activityid -eq $ActivityId} |
            ForEach-Object{
                    $null = $_.pstypenames.clear()
                    $null = $_.pstypenames.add('AppxDeploymentEventLog')
                    $_
            }
       }

    }
}

Microsoft.PowerShell.Utility\Set-Alias Add-AppPackage Add-AppxPackage
Microsoft.PowerShell.Utility\Set-Alias Get-AppPackage Get-AppxPackage
Microsoft.PowerShell.Utility\Set-Alias Get-AppPackageManifest Get-AppxPackageManifest
Microsoft.PowerShell.Utility\Set-Alias Remove-AppPackage Remove-AppxPackage
Microsoft.PowerShell.Utility\Set-Alias Get-AppPackageVolume Get-AppxVolume
Microsoft.PowerShell.Utility\Set-Alias Add-AppPackageVolume Add-AppxVolume
Microsoft.PowerShell.Utility\Set-Alias Remove-AppPackageVolume Remove-AppxVolume
Microsoft.PowerShell.Utility\Set-Alias Mount-AppPackageVolume Mount-AppxVolume
Microsoft.PowerShell.Utility\Set-Alias Dismount-AppPackageVolume Dismount-AppxVolume
Microsoft.PowerShell.Utility\Set-Alias Move-AppPackage Move-AppxPackage
Microsoft.PowerShell.Utility\Set-Alias Get-AppPacakgeDefaultVolume Get-AppxDefaultVolume
Microsoft.PowerShell.Utility\Set-Alias Set-AppPackageDefaultVolume Set-AppxDefaultVolume
Microsoft.PowerShell.Utility\Set-Alias Get-AppPackageLastError Get-AppxLastError
Microsoft.PowerShell.Utility\Set-Alias Get-AppPackageLog Get-AppxLog

Microsoft.PowerShell.Core\Export-ModuleMember -Function 'Get-AppxLastError'
Microsoft.PowerShell.Core\Export-ModuleMember -Function 'Get-AppxLog'
Microsoft.PowerShell.Core\Export-ModuleMember -Alias *
