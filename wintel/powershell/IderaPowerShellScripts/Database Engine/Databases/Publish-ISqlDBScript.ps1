<#
	.SYNOPSIS
		Publish-ISqlDBScript
	.DESCRIPTION
		Script out database
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER database
		Database to script
	.EXAMPLE
		.\Publish-ISqlDBScript -serverInstance MyServer\SQL2012 -database Test -output C:\scripts\
	.INPUTS
	.OUTPUTS
		Script to generate database schema
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$database = "$(Read-Host 'Database Name' [e.g. Test])",
	[string]$output = "$(Read-Host 'Output to TSQL Path' [e.g. C:\scripts\])",
	[boolean]$append = $true
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName( 'Microsoft.SqlServer.SMO')
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
			$outfile = $output + "CreateDB-" + $database + ".sql"
			$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance
			
			If ($append) {
				$server.Databases[$database].Script() | Out-File -FilePath $outfile -Append
			} else {
				$server.Databases[$database].Script() | Out-File -FilePath $outfile
			}
		}

		Write-Output "Database: $database was scripted to $outfile."
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