<#
	.SYNOPSIS
		Enable-CheckPolicy
	.DESCRIPTION
		Enable CHECK_POLICY for All SQL Authenticated Logins
		CIS 4.3 Check (Password Policies)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER LoginName
		SQL Authenticated Login name
	.EXAMPLE
		.\Enable-CheckPolicy -serverInstance MyServer\SQL2012 
	.NOTES
		Applies the same password complexity policy used in Windows to passwords used inside SQL Server.
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$LoginName = "$(Read-Host 'SQL Authenticated Login Name' [e.g. JSmith])"
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
		$SQLScriptFile = $scriptDir + "\Enable-CheckPolicy.sql"
		$Param1 = "LoginName=" + $LoginName
		$Params = $Param1
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