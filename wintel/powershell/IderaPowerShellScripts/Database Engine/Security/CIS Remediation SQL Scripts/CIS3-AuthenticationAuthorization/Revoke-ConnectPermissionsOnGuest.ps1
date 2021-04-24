<#
	.SYNOPSIS
		Revoke-ConnectPermissionsOnGuest
	.DESCRIPTION
		Revoke Connect Permissions on Guest
		CIS 3.2 Check (Authentication and Authorization)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER DBName
		Database Name
	.EXAMPLE
		.\Revoke-ConnectPermissionsOnGuest -serverInstance MyServer\SQL2012 -DBName AdventureWorks2012
	.NOTES
		Remove the right of the guest user to connect to SQL Server databases, except for master,
		msdb, and tempdb.	
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$DBName = "$(Read-Host 'Database Name' [e.g. AdventureWorks2012])"
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
		$SQLScriptFile = $scriptDir + "\Revoke-ConnectPermissionsOnGuest.sql"
		$Param1 = "DBName=" + $DBName
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