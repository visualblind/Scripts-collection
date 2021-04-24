<#
	.SYNOPSIS
		New-ISqlTCPPortFirewallRules
	.DESCRIPTION
		Create a new TCP inbound and inbound firewall rule for same port
	.PARAMETER dn
		Rule display name
	.EXAMPLE 
		.\New-ISqlInboundPortFirewallRules -dn 'SQL Server Access via Port 1433'
	.INPUTS
	.OUTPUTS
	.NOTES
		SQL Server product related ports:
			SQL Server Default Instance Port = 1433
			SQL Admin Connection Port = 1434
			SQL Server Service Broker Port = 4022
			Transact-SQL Debugger/RPC Port = 135
			SSAS Default Instance Port = 2383
			SQL Server Browser Service Port = 2382
			HTTP Port = 80
			SSL port = 443
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/netsecurity/new-netfirewallrule?view=win10-ps
#>

param
(
	[string]$dn = "$(Read-Host 'Firewall rule display name [e.g. SQL Server Access via Port 1433]')",
	[int]$port = "$(Read-Host 'Local port [e.g. 1433]')"
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
		New-NetFirewallRule -DisplayName $dn -Direction Inbound -Action Allow -Protocol TCP –LocalPort $port -Description "SQL Server Port access Rule"
		New-NetFirewallRule -DisplayName $dn -Direction Outbound -Action Allow -Protocol TCP –LocalPort $port -Description "SQL Server Port access Rule"
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
