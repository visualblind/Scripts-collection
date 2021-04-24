<#
	.SYNOPSIS
		Get-ISqlDBUsingSMO
	.DESCRIPTION
		Show all databases using SMO for a given server instance
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlDBUsingSMO -serverInstance MyServer\SQL2012
	.INPUTS
	.OUTPUTS
		Database IDs and Names
	.NOTES
	.LINK
#>
param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName( "Microsoft.SqlServer.Smo" )
}
process {
	try {
		Write-Verbose "Show all databases using SMO for a given server instance..."

		$smoServer = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		$dbs = @()

		foreach ($database in $smoServer.databases) {
			$db = New-Object -TypeName PSObject -Property @{
				DbID = $database.ID
				DbName = $database.Name
			}
			$dbs += $db
		}
		Write-Output $dbs
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