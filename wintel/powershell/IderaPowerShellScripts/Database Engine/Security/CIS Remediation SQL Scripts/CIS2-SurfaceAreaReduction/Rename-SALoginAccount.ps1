<#
	.SYNOPSIS
		Rename-SALoginAccount
	.DESCRIPTION
		Rename SA Login Account
		CIS 2.14 Check (Surface Area Reduction)
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER UserName
		User Name
	.EXAMPLE
		.\Rename-SALoginAccount -serverInstance MyServer\SQL2012 -UserName JSmith
	.NOTES
		The sa account is a widely known and often widely used SQL Server login with sysadmin
		privileges. The sa login is the original login created during installation and always has
		principal_id=1 and sid=0x01.	
	.LINK
		https://www.cisecurity.org/benchmark/microsoft_sql_server/
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$UserName = "$(Read-Host 'Rename sa to UserName' [e.g. newsa])"
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
		Write-Warning "You are about to rename the 'sa' account." -WarningAction Inquire
		$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
		$SQLScriptFile = $scriptDir + "\Rename-SALoginAccount.sql"
		$Param1 = "UserName=" + $UserName
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