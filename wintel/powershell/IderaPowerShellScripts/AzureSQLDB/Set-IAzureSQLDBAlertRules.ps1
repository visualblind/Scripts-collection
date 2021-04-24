<#
	.SYNOPSIS
		Set-IAzureDBAlertRules
	.DESCRIPTION
		Set Azure SQL DB sample alert rules
	.PARAMETER resourceGroupName
		Azure Resource Group Name
	.PARAMETER location
		Azure Location
	.PARAMETER serverName
		Azure SQL Server Name
	.PARAMETER databaseName
		Azure SQL Database Name
	.PARAMETER notificationEmailRecepient
		Azure Notification email recepient
	.EXAMPLE
        .\Set-IAzureDBAlertRules -resourceGroupName MyResource -location southcentralus -serverName MyServer
            -databaseName AdventureWorksLTv12 -notificationEmailRecepient myemail@xxx.com
	.INPUTS
	.OUTPUTS
	.NOTES
    .LINK
        https://docs.microsoft.com/en-us/powershell/module/azurerm.insights/new-azurermalertruleemail
        https://docs.microsoft.com/en-us/powershell/module/azurerm.insights/add-azurermmetricalertrule
#>

param
(
       [string]$resourceGroupName = "$(Read-Host 'Resource Group Name')",
       [string]$location = "$(Read-Host 'Location [eg. southcentralus]')",
       [string]$serverName = "$(Read-Host 'SQL Server Name')",
       [string]$databaseName = "$(Read-Host 'Database Name')",
       [string]$notificationEmailRecepient = "$(Read-Host 'Notification Email Recepient')"
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
         # Email address object
        $actionEmail = New-AzureRmAlertRuleEmail -CustomEmail $notificationEmailRecepient

        # Set an alert rule to alert when DTU consumption exceeds 90%
        Add-AzureRmMetricAlertRule -ResourceGroup $resourceGroupName `
            -Name "DTUConsumption" `
            -Description "alert by DTU consumption (%)" `
            -Location $location `
            -TargetResourceId "/subscriptions/$($(Get-AzureRMContext).Subscription.Id)/resourceGroups/$resourceGroupName/providers/Microsoft.Sql/servers/$serverName/databases/$databaseName" `
            -MetricName "dtu_consumption_percent" `
            -Operator GreaterThan `
            -Threshold 90 `
            -WindowSize 00:05:00 `
            -TimeAggregationOperator Average `
            -Actions $ActionEmail `
            -verbose

        # # Set an alert rule to alert when blocked by firewall
        Add-AzureRmMetricAlertRule -ResourceGroup $resourceGroupName `
            -Name "BlockByFireWall" `
            -Description "alert on block by firewall (cnt)" `
            -Location $location `
            -TargetResourceId "/subscriptions/$($(Get-AzureRMContext).Subscription.Id)/resourceGroups/$resourceGroupName/providers/Microsoft.Sql/servers/$serverName/databases/$databaseName" `
            -MetricName "blocked_by_firewall" `
            -Operator GreaterThan `
            -Threshold 0 `
            -WindowSize 00:05:00 `
            -TimeAggregationOperator Total `
            -Actions $ActionEmail `
            -verbose

        # In the Azure Portal - View Alert Rule in Monitor - Alerts

        # Clean up deployment
        # Remove-AzureRMAlertRule -ResourceGroupName $resourceGroupName -Name "DTUConsumption"
        # Remove-AzureRMAlertRule -ResourceGroupName $resourceGroupName -Name "BlockByFireWall"
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
