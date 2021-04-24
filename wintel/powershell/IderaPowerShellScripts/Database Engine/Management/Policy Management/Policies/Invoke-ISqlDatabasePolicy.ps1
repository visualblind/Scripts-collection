<#
	.SYNOPSIS
		Invoke-ISqlDatabasePolicy
	.DESCRIPTION
		Retrieve Analysis Services databases
	.PARAMETER serverInstance
		SQL Server 2012 Instance
	.PARAMETER databaseName
		Database name
	.PARAMETER policyName
		Policy name to invoke (stored in Policy Store)
	.EXAMPLE
		.\Invoke-ISqlDatabasePolicy -serverInstance server01\instance -databaseName AdventureWorks2012 -policyName Database Page Status
	.INPUTS
	.OUTPUTS
		Policy evaluation results
	.NOTES
	.LINK
		
#>
param (
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')",
	[string]$policyName = "$(Read-Host 'Policy Name [e.g. Database Page Status]')"
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
		Write-Verbose "Invoke Policy Evaluation on selected database..."

		$server = New-Object Microsoft.SqlServer.Management.Smo.Server $serverInstance
		$ver = $server.Information.VersionMajor 

		$isSQLSupported = $false
		if ($ver -eq 9) {
			$isSQLSupported = $false
		} elseif ($ver -eq 10) {
			$isSQLSupported = $false
		} elseif ($ver -eq 11) {
			$isSQLSupported = $true
		} elseif ($ver -eq 12) {
			$isSQLSupported = $true
		} elseif ($ver -eq 13) {
			$isSQLSupported = $true
		} elseif ($ver -eq 14) {
			$isSQLSupported = $true
		}

		if ($isSQLSupported) {
			$instance = $serverInstance.split("\")[1]
			if ($instance -eq $null) { 
				$results = Get-ChildItem SQLSERVER:\SQLPolicy\$serverInstance\DEFAULT\Policies |
					Where-Object { $_.Name -eq $policyName } | 
					Invoke-PolicyEvaluation -TargetServer $serverInstance
			} else { 
				$results = Get-ChildItem SQLSERVER:\SQLPolicy\$serverInstance\Policies |
					Where-Object { $_.Name -eq $policyName } | 
					Invoke-PolicyEvaluation -TargetServer $serverInstance
			}
	
			Write-Output $results
		} else {
			Write-Output "SQL Server version is not supported"
		}

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