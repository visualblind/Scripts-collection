<#
	.SYNOPSIS
		Get-IAzureSQLInstances
	.DESCRIPTION
		Get all instances of SQL Server in the subscription
	.EXAMPLE
		.\Get-IAzureSQLInstances
	.INPUTS
	.OUTPUTS
		Azure SQL Server instances
	.NOTES
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/get-azurermresourcegroup
		https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/get-azurermsqlserver
#>

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
		# Get all SQL Server instances from all resource groups that are part of the Subscription
		$results = Get-AzureRMResourceGroup | Get-AzureRmSqlServer

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
