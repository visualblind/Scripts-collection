<#
	.SYNOPSIS
		Drop-BuiltinGroups
	.DESCRIPTION
		Drop BUILTIN groups
		CIS 3.9 Check (Authentication and Authorization)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER GroupName
		Builtin Group Name
	.EXAMPLE
		.\Drop-BuiltinGroups -serverInstance MyServer\SQL2012 -GroupName Administrators
	.NOTES
		Prior to SQL Server 2008, the BUILTIN\Administrators group was added a SQL Server
		login with sysadmin privileges during installation by default. Best practices promote
		creating an Active Directory level group containing approved DBA staff accounts and using
		this controlled AD group as the login with sysadmin privileges. The AD group should be
		specified during SQL Server installation and the BUILTIN\Administrators group would
		therefore have no need to be a login.	
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$GroupName = "$(Read-Host 'Group Name' [e.g. Administrators])"
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
		$SQLScriptFile = $scriptDir + "\Drop-BuiltinGroups.sql"
		$Param1 = "GroupName=" + $GroupName
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