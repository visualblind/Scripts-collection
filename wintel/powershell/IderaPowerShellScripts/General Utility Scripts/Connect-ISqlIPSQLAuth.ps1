<#
	.SYNOPSIS
		Connect-ISqlIPSQLAuth
	.DESCRIPTION
		Connect to SQL Server instance using and IP address and 
		SQL Server authentication.
	.PARAMETER ipAddress
		< xxx.xxx.xxx.xxx | xxx.xxx.xxx.xxx\instance >
	.EXAMPLE
		.\Connect-ISqlIPSQLAuth -ipAddress 127.0.0.1\sql2012
	.INPUTS
		
	.OUTPUTS
		Database names and owners
	.NOTES
		When prompt for a login using your SQL authentication credentials
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
		Write-Verbose "Connect to $ipAddress using SQL Server authentication..."

		$dbs = @()

		$smoServer = new-object Microsoft.SqlServer.Management.Smo.Server $ipAddress

		# The connection will use SQL Authentication, so set LoginSecure to FALSE
		$smoServer.ConnectionContext.set_LoginSecure($False)

		# Pop a credentials box to get User Name and Password
		$LoginCredentials = Get-Credential

		$Login = $LoginCredentials.UserName
		if ($Login.StartsWith("\")) {
			$Login = $Login.Substring(1)
		}

		# Set properties of ConnectionContext
		$smoServer.ConnectionContext.set_EncryptConnection($False)
		$smoServer.ConnectionContext.set_Login($Login)
		$smoServer.ConnectionContext.set_SecurePassword($LoginCredentials.Password)

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