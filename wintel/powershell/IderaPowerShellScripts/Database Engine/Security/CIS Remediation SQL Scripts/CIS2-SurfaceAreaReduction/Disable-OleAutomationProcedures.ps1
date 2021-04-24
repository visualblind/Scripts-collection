<#
	.SYNOPSIS
		Disable-OleAutomationProcedures
	.DESCRIPTION
		Disable Ole Automation Procedures Server Configuration Option
		CIS 2.5 Check (Surface Area Reduction)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Disable-OleAutomationProcedures -serverInstance MyServer\SQL2012 
	.NOTES
		The Ole Automation Procedures option controls whether OLE Automation objects can be
		instantiated within Transact-SQL batches. These are extended stored procedures that allow
		SQL Server users to execute functions external to SQL Server.	
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
		$SQLScriptFile = $scriptDir + "\Disable-OleAutomationProcedures.sql"
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