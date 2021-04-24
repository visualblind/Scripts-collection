<#
	.SYNOPSIS
		Set-ISqlDefaultFileLocations
	.DESCRIPTION
		Set default file locations for a SQL Server instance
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER dataPath
		New data path to set 
	.PARAMETER logPath
		New log path to set
	.EXAMPLE
		.\Set-ISqlDefaultFileLocations -serverInstance server01\sql2012 -dataPath D:\SQL\Data -logPath D:\SQL\Data
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')",
	[string]$dataPath = "$(Read-Host 'Default data path [e.g. D:\SQL\Data]')",
	[string]$logPath = "$(Read-Host 'Default log path [e.g. D:\SQL\Data]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Set SQL Server default file locations..."

		$server = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		if ((Test-Path -path $dataPath) -ne $true) {
			#New-Item $dataPath -type directory
			Throw "Data Path: $dataPath doesn't exist"
		}
		
		if ((Test-Path -path $logPath) -ne $true) {
			#New-Item $logPath -type directory
			Throw "Log Path: $logPath doesn't exist"
		}

		$server.Settings.DefaultFile = $dataPath
		$server.Settings.DefaultLog = $logPath
		$server.Settings.Alter()

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