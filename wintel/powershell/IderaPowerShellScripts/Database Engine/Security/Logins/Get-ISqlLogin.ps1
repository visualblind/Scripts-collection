<#
	.SYNOPSIS
		Get-ISqlLogin
	.DESCRIPTION
		Find a login or AD group on server instance
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER login
		Login name to find
	.EXAMPLE
		.\Get-ISqlLogin -serverInstance MyServer\SQL2012 -login DOMAIN\DataAdmin
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$login = "$(Read-Host 'Login Name' [e.g. DOMAIN\DataAdmin])"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')
}
process {
	try {
		$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance
       	$loginMatch = $server.Logins | where {$_.Name -eq $login} | select Parent, Name
		Write-Output $loginMatch
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