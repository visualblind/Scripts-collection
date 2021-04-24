<#
	.SYNOPSIS
		Enable-ISqlFirewallRule
	.DESCRIPTION
		Enable firewall rule for SQL Server
	.PARAMETER dn
		Rule display name
	.EXAMPLE 
		.\Enable-ISqlFirewallRule -dn 'SQL Server access via port 1433'
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param
(
	[string]$dn = "$(Read-Host 'Firewall rule display name [e.g. SQL Server Access via Port 1433]')"
)

begin {
	try {
		if (-not (Get-Module -Name "NetSecurity")) {
			Import-Module NetSecurity
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
process {
	try {
		Enable-NetFirewallRule -DisplayName $dn
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
