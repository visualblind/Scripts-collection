<#
	.SYNOPSIS
		Set-SQLServerAuditForFailedAndSuccessfulLogins
	.DESCRIPTION
		Set SQL Server Audit to capture failed and successful logins
		CIS 5.4 Check (Auditing and Logging)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Set-SQLServerAuditForFailedAndSuccessfulLogins -serverInstance MyServer\SQL2012 
	.NOTES
		SQL Server Audit is capable of capturing both failed and successful logins and writing them
		to one of three places: the application event log, the security event log, or the file system.
		We will use it to capture any login attempt to SQL Server, as well as any attempts to change
		audit policy. This will also serve to be a second source to record failed login attempts.	
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
		$SQLScriptFile = $scriptDir + "\Set-SQLServerAuditForFailedAndSuccessfulLogins.sql"
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