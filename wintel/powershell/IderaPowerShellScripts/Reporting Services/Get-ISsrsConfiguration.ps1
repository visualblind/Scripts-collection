<#
	.SYNOPSIS
		Get-ISsrsConfiguration
	.DESCRIPTION
		Retrieve SQL Server Reporting Service configuration using WMI
	.PARAMETER computer
		Computer name
	.EXAMPLE
		.\Get-ISsrsConfiguration -computer Server01
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\sql2012])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Retrieve SQL Server Reporting Service configuration using WMI..."

		$serverName = $serverInstance.Split("\")[0]
		if ($serverInstance.Contains("\")) {
			$instance = $serverInstance.Split("\")[1]
		} else {
			$instance = "MSSQLSERVER"
		}

		$smoServer = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance
		$ver = $smoServer.Information.VersionMajor 

		$isSQLSupported = $false
		if ($ver -eq 9) {
			$namespace = 'root\Microsoft\SqlServer\ReportServer\v9\Admin'
			$isSQLSupported = $true
		} elseif ($ver -eq 10) {
			$namespace = 'root\Microsoft\SqlServer\ReportServer\RS_' + $instance + '\v10\Admin'
			$isSQLSupported = $true
		} elseif ($ver -eq 11) {
			$namespace = 'root\Microsoft\SqlServer\ReportServer\RS_' + $instance + '\v11\Admin'
			$isSQLSupported = $true
		} elseif ($ver -eq 12) {
			$namespace = 'root\Microsoft\SqlServer\ReportServer\RS_' + $instance + '\v12\Admin'
			$isSQLSupported = $true
		} elseif ($ver -eq 13) {
			$namespace = 'root\Microsoft\SqlServer\ReportServer\RS_' + $instance + '\v13\Admin'
			$isSQLSupported = $true
		} elseif ($ver -eq 14) {
			# Report Services install decoupled from SQL 2017, WMI Class not supported
			$isSQLSupported = $false
		}

		# Create a WMI namespace for SQL Server
		if ($isSQLSupported) {
			$configSetting = Get-WmiObject -Class MSReportServer_ConfigurationSetting -Namespace $namespace -ComputerName $serverName
		} else {
			Write-Error "SQL Server version $ver not supported"
		}
		
		Write-Output $configSetting		
	}
	catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
}