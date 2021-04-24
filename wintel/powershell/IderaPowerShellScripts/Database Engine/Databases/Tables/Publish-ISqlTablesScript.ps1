<#
	.SYNOPSIS
		Publish-ISqlTablesScript
	.DESCRIPTION
		Script out tables in a database
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER database
		Database to script tables
	.EXAMPLE
		.\Publish-ISqlTablesScript -serverInstance MyServer\SQL2012 -database Test -output C:\scripts\
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$database = "$(Read-Host 'Database Name' [e.g. Test])",
	[string]$output = "$(Read-Host 'Output for TSQL script' [e.g. C:\scripts\])"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')
}
process {
	try {
		If ($database -eq "") {
			Throw "Database name must be supplied."
		}

		If ($output -eq "") {
			Throw "Output directory must be supplied."
		}

		If ((Test-Path -path $output) -ne $true) {
			Throw "Output directory $output doesn't exist."
		} else {
			If (!$output.EndsWith("\")) {
				$output += "\"
			}

			$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance
			$outfile = $output + "CreateTables-" + $database + ".sql"

			$count = 0

			foreach ($table in $server.Databases[$database].Tables) {
				$count += 1
				$table.Script() | Out-File -FilePath $outfile -append
			}
		}

		If ($count -gt 0) {
			Write-Output "Database: $database tables were scripted to $outfile."
		} else {
			Write-Output "No tables contained in $database to script."
		}
		
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