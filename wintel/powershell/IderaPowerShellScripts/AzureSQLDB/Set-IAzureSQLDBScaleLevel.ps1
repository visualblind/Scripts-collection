<#
	.SYNOPSIS
		Set-IAzureSQLDBScaleLevel
	.DESCRIPTION
		Common exanples for setting Azure SQL DB scaling
	.PARAMETER resourceGroupName
		Azure Resource Group Name
	.PARAMETER serverName
		Azure SQL Server Name
	.PARAMETER databaseName
		Azure SQL Database Name
	.EXAMPLE
		.\Set-IAzureSQLDBScaleLevel -resourceGroupName MyResource -serverName MyServer -databaseName MyDatabase
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/set-azurermsqldatabase
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
		# Common Single Database Editions:
		#   "Basic", "Standard", "Premuim"

        # Common Single Database Performance Levels:
        #   Basic - none
        #   Standard - S0..S9, S12
		#   Premium - P1,P2,P4,P6,P11,P15

        # See pricing calculator - https://azure.microsoft.com/en-us/pricing/calculator/?service=sql-database

		# See Links section above for more details about using the Set-AzureRmSqlDatabase and more options that are available

		$edition = "Basic"

		#$edition = "Standard"
		#$perfLevel = "S0"

		#$edition = "Premium"
		#$perfLevel = "P1"

        # Run this for Basic, -RequestedServiceObjectiveName (PerfLevel not required)
		Set-AzureRmSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databasename `
			-Edition $edition -Confirm

		# Run this for Standard or Premium and make sure to set the appropriate performance level for the edition
        #Set-AzureRmSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databasename `
        #    -Edition $edition -RequestedServiceObjectiveName $perfLevel -Confirm
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
