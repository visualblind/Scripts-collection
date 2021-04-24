<#
	.SYNOPSIS
		Set-MaxNumberErrorLogFiles
	.DESCRIPTION
		Set Maximum number of error log files
		CIS 5.1 Check (Auditing and Logging)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER NumberAbove12
		Number of error logs above 12
	.EXAMPLE
		.\Set-MaxNumberErrorLogFiles -serverInstance MyServer\SQL2012 -NumberAbove12 14
	.NOTES
		SQL Server error log files must be protected from loss. The log files must be backed up
		before they are overwritten. Retaining more error logs helps prevent loss from frequent
		recycling before backups can occur.	
								
		Login into the Server Instance that you want to update
		The SQL Script will automatically select the correct registry hive for that instance
			for example: MSSQL12.MSSQLServer for default or MSSQL12.CS for named instance
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[int]$NumberAbove12 = "$(Read-Host 'NumberAbove12' [e.g. 14])"
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
		$SQLScriptFile = $scriptDir + "\Set-MaxNumberErrorLogFiles.sql"
		$Param1 = "NumberAbove12=" + $NumberAbove12
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