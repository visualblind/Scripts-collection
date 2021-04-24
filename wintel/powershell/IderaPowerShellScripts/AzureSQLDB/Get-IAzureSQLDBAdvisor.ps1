<#
	.SYNOPSIS
		Get-IAzureDBAdvisor
	.DESCRIPTION
		Get Azure SQL DB advisor recommendations
	.PARAMETER resourceGroupName
		Azure Resource Group Name
	.PARAMETER serverName
		Azure SQL Server Name
	.PARAMETER databaseName
        Azure SQL Database Name
	.EXAMPLE
		.\Get-IAzureDBAdvisor -resourceGroupName MyResource -serverName MyServer -databaseName MyDatabase
	.INPUTS
	.OUTPUTS
		Database Advisor recommendations
	.NOTES
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/get-azurermsqldatabaseadvisor
#>

param
(
       [string]$resourceGroupName = "$(Read-Host 'Resource Group Name')",
       [string]$serverName = "$(Read-Host 'SQL Server Name')",
       [string]$databaseName = "$(Read-Host 'Database Name')"
)

begin {
	if (Get-InstalledModule -Name AzureRM) {
		# You are good to go!
	} else {
		Throw "The Idera Azure SQLDB scripts require the AzureRM module to be installed. See Initialize-IAzurePowerShell script to install it."
	}

    # Login to Azure Resource Management Account if not already logged in
	Try {
		$result = Get-AzureRmContext -ErrorAction Continue
		If ($result.Account -eq $null) {
			Login-AzureRmAccount
		}
	} Catch [System.Management.Automation.PSInvalidOperationException] {
		Login-AzureRmAccount
	}
}
process {
	try {
        $results = Get-AzureRmSqlDatabaseAdvisor -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName

		Write-Output $results
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


