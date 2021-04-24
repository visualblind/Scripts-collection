<#
	.SYNOPSIS
		Get-IAzureDBAlertDefinitions
	.DESCRIPTION
		Get Azure SQL DB alert definitions
	.PARAMETER resourceGroupName
		Azure Resource Group Name
	.PARAMETER serverName
		Azure SQL Server Name
	.PARAMETER databaseName
		Azure SQL Database Name
	.EXAMPLE
		.\Get-IAzureDBAlertDefinitions -resourceGroupName MyResource -serverName MyServer -databaseName MyDatabase
	.INPUTS
	.OUTPUTS
		Alert definitions
	.NOTES
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/get-azurermresource
		https://docs.microsoft.com/en-us/powershell/module/azurerm.insights/get-azurermmetricdefinition
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
         # Get resource id
        $resourceId = (Get-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceName "$serverName/$databaseName").ResourceID

        # Get list of alert definitions
        $results = Get-AzureRmMetricDefinition -ResourceId $resourceId |
                        Select-Object @{Name="Item";Expression={$_."Name"."Value"}},
                                    @{Name="Tag";Expression={$_."Name"."LocalizedValue"}},
                                    @{Name="Unit";Expression={$_."Unit"}},
                                    @{Name="Type";Expression={$_."PrimaryAggregationType"}}

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

