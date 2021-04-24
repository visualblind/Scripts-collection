<#
	.SYNOPSIS
		Drop-OrphanedUsers
	.DESCRIPTION
		Drop Orphaned Users	
		CIS 3.3 Check (Authentication and Authorization)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER DBName
		Database Name
	.PARAMETER UserName
		User name
	.EXAMPLE
		.\Drop-OrphanedUsers -serverInstance MyServer\SQL2012 -DBName AdventureWorks2012 -UserName -JSmith
	.NOTES
		A database user for which the corresponding SQL Server login is undefined or is incorrectly
		defined on a server instance cannot log in to the instance and is referred to as orphaned
		and should be removed.	
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$DBName = "$(Read-Host 'Database Name' [e.g. AdventureWorks2012])",
	[string]$UserName = "$(Read-Host 'User Name' [e.g. JSmith])"
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
		$SQLScriptFile = $scriptDir + "\Drop-OrphanedUsers.sql"
		$Param1 = "DBName=" + $DBName
		$Param2 = "UserName=" + $UserName
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