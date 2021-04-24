<#
	.SYNOPSIS
		Disable-AdHocDistributedQueries
	.DESCRIPTION
		Disable Ad Hoc Distributed Queries Server Configuration Option
        CIS 2.1 Check (Surface Area Reduction)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Disable-AdHocDistributedQueries -serverInstance MyServer\SQL2012 
	.NOTES
		Enabling Ad Hoc Distributed Queries allows users to query data and execute statements on
		external data sources. This functionality should be disabled.
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
		$SQLScriptFile = $scriptDir + "\Disable-AdHocDistributedQueries.sql"
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