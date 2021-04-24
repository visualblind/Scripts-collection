<#
	.SYNOPSIS
		Get-IAzureDBMetric
	.DESCRIPTION
		Get Azure SQL DB metric
	.PARAMETER resourceGroupName
		Azure Resource Group Name
	.PARAMETER serverName
		Azure SQL Server Name
	.PARAMETER databaseName
        Azure SQL Database Name
    .PARAMETER metricName
        Azure SQL Metric Name
	.EXAMPLE
		.\Get-IAzureDBMetric -resourceGroupName MyResource -serverName MyServer -databaseName MyDatabase -metricName dtu_consumption_percent
	.INPUTS
	.OUTPUTS
		Metric values
	.NOTES
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/azurerm.insights/get-azurermmetric
#>

param
(
       [string]$resourceGroupName = "$(Read-Host 'Resource Group Name')",
       [string]$serverName = "$(Read-Host 'SQL Server Name')",
       [string]$databaseName = "$(Read-Host 'Database Name')",
	   [string]$metricName = "$(Read-Host 'Metric Name [e.g. dtu_consumption_percent]')"
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
        # Get the metrics on the database in 5 minute intervals
        $data = Get-AzureRmMetric -ResourceId "/subscriptions/$($(Get-AzureRMContext).Subscription.Id)/resourceGroups/$resourceGroupName/providers/Microsoft.Sql/servers/$serverName/databases/$databaseName" `
            -TimeGrain 00:05:00 -MetricName $metricName
        $results = $data.Data

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
