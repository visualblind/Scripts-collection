<#
	.SYNOPSIS
		Enable-LoginAuditingForFailedLogins
	.DESCRIPTION
		Enable Login Auditing for failed logins
		CIS 5.3 Check (Auditing and Logging)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Enable-LoginAuditingForFailedLogins -serverInstance MyServer\SQL2012 
	.NOTES
		This setting will record failed authentication attempts for SQL Server logins to the SQL
		Server Errorlog. This is the default setting for SQL Server.
		
		Historically, this setting has been available in all versions and editions of SQL Server. Prior
		to the availability of SQL Server Audit, this was the only provided mechanism for
		capturing logins (successful or failed).	
						
		Login into the Server Instance that you want to update
		The SQL Script will automatically select the correct registry hive for that instance
			for example: MSSQL12.MSSQLServer for default or MSSQL12.CS for named instance
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
		Write-Warning "The server instance may need to be restarted in order for changes to take effect." -WarningAction Inquire
		$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
		$SQLScriptFile = $scriptDir + "\Enable-LoginAuditingForFailedLogins.sql"
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