<#
	.SYNOPSIS
		Get-ISqlMaxMemory
	.DESCRIPTION
		Get max memory property from SQL Server instance
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlMaxMemory -serverInstance MyServer
	.INPUTS
	.OUTPUTS
		Integer in MB, 
			-1 if memory is set to default of 2GB,
			-2 if no connection to the desired DB can be obtained		
	.NOTES
		Adapted from Jakob Bindslet script
	.LINK
		
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")
}
process {
	try {
		Write-Verbose "Get max memory property from SQL Server..."

		$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		$maxMemory = $server.Configuration.MaxServerMemory.Maximum
		if ($maxMemory -eq 2147483647) {
			Write-Verbose "Max memory is set to unlimited"
			$maxMemory = -1
		}

		Write-Output "Max memory is set to $maxMemory (-1 = 2GB)"
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