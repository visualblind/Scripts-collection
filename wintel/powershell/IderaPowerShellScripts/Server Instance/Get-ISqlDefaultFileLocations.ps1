<#
	.SYNOPSIS
		Get-ISqlDefaultFileLocations
	.DESCRIPTION
		Get default file locations for a SQL Server instance
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlDefaultFileLocations -serverInstance server01\sql2012
	.INPUTS
	.OUTPUTS
		Default file locations
	.NOTES
	.LINK
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Get SQL Server default file locations..."

		$server = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		$dataLoc = $server.Settings.DefaultFile
		$logLoc = $server.Settings.DefaultLog
		if ($dataLoc.Length -eq 0) {
			$dataLoc = $server.Information.MasterDBPath
		}
		if ($logLoc.Length -eq 0) {
			$logLoc = $server.Information.MasterDBLogPath
		}

		$defaultLoc = New-Object -TypeName PSObject -Property @{
			DataPath = $dataLoc
			LogPath = $logLoc
		}
		Write-Output $defaultLoc
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