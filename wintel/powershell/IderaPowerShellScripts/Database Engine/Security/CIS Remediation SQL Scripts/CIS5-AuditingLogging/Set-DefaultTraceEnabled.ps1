<#
	.SYNOPSIS
		Set-DefaultTraceEnabled
	.DESCRIPTION
		Set Default Trace Enabled
		CIS 5.2 Check (Auditing and Logging))
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Set-DefaultTraceEnabled -serverInstance MyServer\SQL2012 
	.NOTES
		The default trace provides audit logging of database activity including account creations,
		privilege elevation and execution of DBCC commands.	
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
		$SQLScriptFile = $scriptDir + "\Set-DefaultTraceEnabled.sql"
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