<#
	.SYNOPSIS
		Disable-ScanForStartupProcs
	.DESCRIPTION
		Disable Scan For Startup Procs Server Configuration Option
		CIS 2.8 Check (Surface Area Reduction)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Disable-ScanForStartupProcs -serverInstance MyServer\SQL2012 
	.NOTES
		The scan for startup procs option, if enabled, causes SQL Server to scan for and
		automatically run all stored procedures that are set to execute upon service startup.
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
		Write-Warning "This may require a SQL Server restart to set the running value."
		$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
		$SQLScriptFile = $scriptDir + "\Disable-ScanForStartupProcs.sql"
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