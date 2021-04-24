<#
	.SYNOPSIS
		Enable-MustChangeForNewSQLAuthenticatedLogin
	.DESCRIPTION
		Enable MUST_CHANGE for All SQL Authenticated Logins
		CIS 4.1 Check (Password Policies)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER LoginName
		SQL Authenticated Login Name
	.PARAMETER Password
		SQL Authenticated Password
	.EXAMPLE
		.\Enable-MustChangeForNewSQLAuthenticatedLogin -serverInstance MyServer\SQL2012 -LoginName JSmith -Password passw0rd
	.NOTES
		Whenever this option is set to ON, SQL Server will prompt for an updated password the first
		time the new or altered login is used.
		
		Password must meet Windows security complexity rules
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$LoginName = "$(Read-Host 'Login Name' [e.g. JSmith])",
	[string]$Password = "$(Read-Host 'Password' [e.g. passw0RD])"
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
		$SQLScriptFile = $scriptDir + "\Enable-MustChangeForNewSQLAuthenticatedLogin.sql"
		$Param1 = "LoginName=" + $LoginName
		$Param2 = "Password=" + $Password
		$Params = $Param1, $Param2		
		Invoke-Sqlcmd -InputFile $SQLScriptFile -Variable $Params -Serverinstance $serverInstance
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