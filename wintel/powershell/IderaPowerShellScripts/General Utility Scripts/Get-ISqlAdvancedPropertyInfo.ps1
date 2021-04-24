<#
	.SYNOPSIS
		Get-ISqlAdvancedPropertyInfo
	.DESCRIPTION
		Retrieve advanced properties by service of a computer using WMI
	.PARAMETER computer
		Computer name
	.EXAMPLE
		.\Get-ISqlAdvancedPropertyInfo -computer MyServer
	.INPUTS
		
	.OUTPUTS
		List of SQL Server advanced properties and settings by service name
	.NOTES
		
	.LINK
		
#> 

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "List Properties of a SQL Server instance using WMI..."

		$serverName = $serverInstance.Split("\")[0]
		$instance = $serverInstance.Split("\")[1]

		$server = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance
		$ver = $server.Information.Version.Major

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

		# Retrieve SQL Server advanced properties and settings using WMI
		if ($isSQLSupported) {
			$output = Get-WmiObject -class sqlserviceadvancedproperty -namespace $WMInamespace -computername $serverName | 
				Sort-Object ServiceName, PropertyName | Select-Object ServiceName, PropertyName, PropertyNumValue, PropertyStrValue
		} else {
			Throw "SQL Server versions earlier than 2005 are not valid."
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