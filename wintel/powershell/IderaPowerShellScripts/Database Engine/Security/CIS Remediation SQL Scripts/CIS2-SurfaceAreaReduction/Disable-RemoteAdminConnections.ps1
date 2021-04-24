<#
	.SYNOPSIS
		Disable-RemoteAdminConnections
	.DESCRIPTION
		Disable Remote Admin Connections Server Configuration Option
		CIS 2.7 Check (Surface Area Reduction)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Disable-RemoteAdminConnections -serverInstance MyServer\SQL2012 
	.NOTES
		The remote admin connections option controls whether a client application on a remote
		computer can use the Dedicated Administrator Connection (DAC).
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])"
)

begin {
	#Load 'sqlps' Module so we can use the Provider
	if (-not(Get-Module -name sqlps)) { 
		if(Get-Module -ListAvailable | Where-Object { $_.name -eq "sqlps" }) { 
			Import-Module -Name sqlps -DisableNameChecking
		} else { 
			Throw "SQL Server 'sqlps' module is not available" 
		} 
	}
}
process {
	try {
		$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
		$SQLScriptFile = $scriptDir + "\Disable-RemoteAdminConnections.sql"
		Invoke-Sqlcmd -InputFile $SQLScriptFile -Serverinstance $serverInstance
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