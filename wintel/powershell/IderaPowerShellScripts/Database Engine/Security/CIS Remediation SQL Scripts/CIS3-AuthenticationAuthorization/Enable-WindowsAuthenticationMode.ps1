<#
	.SYNOPSIS
		Enable-WindowsAuthenticationMode
	.DESCRIPTION
		Enable Windows Authentication Mode
		CIS 3.1 Check (Authentication and Authorization)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Enable-WindowsAuthenticationMode -serverInstance MyServer\SQL2012 
	.NOTES
		Uses Windows Authentication to validate attempted connections.	
				
		Login into the Server Instance that you want to update
		The SQL Script will automatically select the correct registry hive for that instance
			for example: MSSQL12.MSSQLServer for default or MSSQL12.CS for named instance
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'SQL Server Instance' [e.g. Server01])"
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
		# This only sets the SQL Server default instance
		#    This script and the SQL script will need to be modified 
		#    to set the correct reqistery entry for a named instance
		$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
		$SQLScriptFile = $scriptDir + "\Enable-WindowsAuthenticationMode.sql"
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