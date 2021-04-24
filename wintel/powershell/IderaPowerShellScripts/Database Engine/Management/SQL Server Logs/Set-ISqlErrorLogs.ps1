<#
	.SYNOPSIS
		Set-ISqlErrorLogs
	.DESCRIPTION
		Set number of error logs to cycle on a server instance
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER numErrorLogs
		Number of error logs to cycle
	.EXAMPLE
		.\Set-ISqlErrorLogs -serverInstance MyServer\SQL2012 -numErrorLogs 8
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[int]$numErrorLogs = "$(Read-Host 'Number of error logs' [e.g. default=7])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		$server = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		$currentCount = $server.NumberOfLogFiles
		if ($currentCount -eq -1) {
			$currentCount = 7
		} 

		Write-Verbose "Number of error logs currently: $currentCount"

		$server.NumberOfLogFiles = $numErrorLogs
		$server.Alter()

		Write-Output "Cycled error logs on $serverInstance now set to $numErrorLogs"
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