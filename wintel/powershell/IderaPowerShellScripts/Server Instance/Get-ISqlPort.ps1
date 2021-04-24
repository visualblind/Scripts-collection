<#
	.SYNOPSIS
		Get-ISqlPort
	.DESCRIPTION
		Retrieve SQL Server port configured for use using WMI
	.PARAMETER serverInstance
		SQL Server Instance
	.EXAMPLE
		.\Get-ISqlPort -serverInstance Server01\sql2012
	.INPUTS
	.OUTPUTS
		SQL Server Port #
	.NOTES
		Use server name only to target default instance
	.LINK
#> 

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")
}
process {
	try {
		Write-Verbose "Retrieve SQL Server port configured for use using WMI..."

		$serverName = $serverInstance.Split("\")[0]
		$instance = $serverInstance.Split("\")[1]

		if ($instance -eq $null) {
			$instance = "MSSQLSERVER"
		} 

		$smoServer = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance
		$ver = $smoServer.Information.VersionMajor 

		# Create a WMI query
		$WQL = "SELECT PropertyName, PropertyStrVal "
		$WQL += "FROM ServerNetworkProtocolProperty "
		$WQL += "WHERE InstanceName = '" + $instance + "' AND "
		$WQL += "IPAddressName = 'IPAll' AND "
		$WQL += "ProtocolName = 'Tcp'"

		Write-Debug $WQL

		# Create a WMI namespace for SQL Server
		$isSQLSupported = $false
		if ($ver -eq 9) {
			$WMInamespace = 'root\Microsoft\SqlServer\ComputerManagement'
			$isSQLSupported = $true
		} elseif ($ver -eq 10) {
			$WMInamespace = 'root\Microsoft\SqlServer\ComputerManagement10'
			$isSQLSupported = $true
		} elseif ($ver -eq 11) {
			$WMInamespace = 'root\Microsoft\SqlServer\ComputerManagement11'
			$isSQLSupported = $true 
		} elseif ($ver -eq 12) {
			$WMInamespace = 'root\Microsoft\SqlServer\ComputerManagement12'
			$isSQLSupported = $true 
		} elseif ($ver -eq 13) {
			$WMInamespace = 'root\Microsoft\SqlServer\ComputerManagement13'
			$isSQLSupported = $true 
		} elseif ($ver -eq 14) {
			$WMInamespace = 'root\Microsoft\SqlServer\ComputerManagement14'
			$isSQLSupported = $true 
		}

		# Use PowerShell Get-WmiObject to run a WMI query 
		if ($isSQLSupported) {
			$output = Get-WmiObject -query $WQL -computerName $serverName -namespace $WMInamespace | 
			Select-Object PropertyName, PropertyStrVal
		} else {
			$output = "SQL Server version is unsupported"
		}

		Write-Output $output
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