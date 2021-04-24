<#
	.SYNOPSIS
		Set-ClrAssemblyPermissionToSafeAccess
	.DESCRIPTION
		Set CLR Assembly Permission to SAFE_ACCESS
		CIS 6.2 Check (Application Development)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER AssemblyName
		Assembly Name
	.EXAMPLE
		.\Set-ClrAssemblyPermissionToSafeAccess -serverInstance MyServer\SQL2012 -AssemblyName ComplexNumber
	.NOTES
		Setting CLR Assembly Permission Sets to SAFE_ACCESS will prevent assemblies from
		accessing external system resources such as files, the network, environment variables, or
		the registry.	
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$AssemblyName = "$(Read-Host 'Assembly Name' [e.g. ComplexNumber])"
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
		$SQLScriptFile = $scriptDir + "\Set-ClrAssemblyPermissionToSafeAccess.sql"
		$Param1 = "AssemblyName=" + $AssemblyName
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