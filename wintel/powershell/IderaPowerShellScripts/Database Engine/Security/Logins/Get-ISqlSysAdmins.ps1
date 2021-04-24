<#
	.SYNOPSIS
		Get-ISqlSysAdmins
	.DESCRIPTION
		Get SysAdmins on a server instance
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlSysAdmins -serverInstance MyServer\SQL2012 
	.INPUTS
	.OUTPUTS
		SysAdmin members
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')
}
process {
	try {
		$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance
		$svrole = $server.Roles | where {$_.Name -eq 'sysadmin'}
		$sysadmins = $svrole.EnumServerRoleMembers()
		Write-Output $sysadmins
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