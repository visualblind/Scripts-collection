<#
	.SYNOPSIS
		Remove-PublicInMsdbFromSQLAgentProxies
	.DESCRIPTION
		Remove Public in MSDB from SQL Agent Proxies
		CIS 3.11 Check (Authentication and Authorization)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER ProxyName
		SQL Server Agent Proxy name
	.EXAMPLE
		.\Remove-PublicInMsdbFromSQLAgentProxies -serverInstance MyServer\SQL2012 -ProxyName TestProxy
	.NOTES
		The public database role contains every user in the msdb database. SQL Agent proxies
		define a security context in which a job step can run.	
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
		https://technet.microsoft.com/en-us/library/ms188763(v=sql.105).aspx
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$ProxyName = "$(Read-Host 'Proxy Name' [e.g. TestProxy])"
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
		$SQLScriptFile = $scriptDir + "\Remove-PublicInMsdbFromSQLAgentProxies.sql"
		$Param1 = "ProxyName=" + $ProxyName
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