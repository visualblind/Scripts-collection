<#
	.SYNOPSIS
		Enable-HideInstanceOption
	.DESCRIPTION
		Enable Hide Instance Option
		CIS 2.12 Check (Surface Area Reduction)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Enable-HideInstanceOption -serverInstance MyServer\SQL2012 
	.NOTES
		Non-clustered SQL Server instances within production environments should be designated
		as hidden to prevent advertisement by the SQL Server Browser service.
		
		Login into the Server Instance that you want to update
		The SQL Script will automatically select the correct registry hive for that instance
			for example: MSSQL12.MSSQLServer for default or MSSQL12.CS for named instance
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
		https://sqlandme.com/2011/08/23/sql-server-hide-an-instance-of-sql-server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'SQL Server Instance' [e.g. Server01\Instance])"
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
		$SQLScriptFile = $scriptDir + "\Enable-HideInstanceOption.sql"
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