<#
	.SYNOPSIS
		Connect-ISqlIPWindowsAuth
	.DESCRIPTION
		Connect to SQL Server instance using IP address and Windows authentication
	.PARAMETER ipAddress
		< xxx.xxx.xxx.xxx | xxx.xxx.xxx.xxx\instance >
	.EXAMPLE
		.\Connect-ISqlIPWindowsAuth -ipAddress 127.0.0.1\sql2012
	.INPUTS
		
	.OUTPUTS
		Database names and owners
	.NOTES
		
	.LINK
		
#>

param (
	[string]$ipAddress = "$(Read-Host 'IP Address' [e.g. 127.0.0.1\instance])"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Connect to SQL Server using IP address, instance and Windows authentication..."

		$dbs = @()

		Write-Verbose "Creating SMO Server object..."
		$smoServer = new-object Microsoft.SqlServer.Management.Smo.Server $ipAddress

		# Use Windows Authentication by setting LoginSecure to TRUE
		Write-Verbose "Setting Windows Authentication mode..."
		$smoServer.ConnectionContext.set_LoginSecure($True)

		# Output object that contains a of the databases
		foreach ($Database in $smoServer.Databases) {
			$db = New-Object -TypeName PSObject -Property @{
				DbName = $Database.Name
				DbOwner = $Database.Owner
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