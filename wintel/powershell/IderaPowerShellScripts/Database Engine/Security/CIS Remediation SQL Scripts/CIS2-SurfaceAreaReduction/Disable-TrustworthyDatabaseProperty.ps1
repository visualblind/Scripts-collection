<#
	.SYNOPSIS
		Disable-TrustworthyDatabaseProperty
	.DESCRIPTION
		Disable Trustworthy Database Property
		CIS 2.9 Check (Surface Area Reduction)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER DBName
		Database name
	.EXAMPLE
		.\Disable-TrustworthyDatabaseProperty -serverInstance MyServer\SQL2012 -DBName AdventureWorks2012
	.NOTES
		The TRUSTWORTHY database option allows database objects to access objects in other
		databases under certain circumstances.
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
		$SQLScriptFile = $scriptDir + "\Disable-TrustworthyDatabaseProperty.sql"
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