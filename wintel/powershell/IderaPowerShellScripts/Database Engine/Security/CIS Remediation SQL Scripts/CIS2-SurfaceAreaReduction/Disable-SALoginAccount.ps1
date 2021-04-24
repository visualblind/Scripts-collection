<#
	.SYNOPSIS
		Disable-SALoginAccount
	.DESCRIPTION
		Disable SA Login Account
		CIS 2.13 Check (Surface Area Reduction)
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Disable-SALoginAccount -serverInstance MyServer\SQL2012 
	.NOTES
		The sa account is a widely known and often widely used SQL Server account with sysadmin
		privileges. This is the original login created during installation and always has the
		principal_id=1 and sid=0x01.	
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
		$SQLScriptFile = $scriptDir + "\Disable-SALoginAccount.sql"
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