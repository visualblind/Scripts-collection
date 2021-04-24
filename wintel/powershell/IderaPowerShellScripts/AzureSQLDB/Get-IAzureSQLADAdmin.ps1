<#
	.SYNOPSIS
		Get-IAzureSQLADAdmin
	.DESCRIPTION
		Get Azure SQL Server AD Administrator
	.PARAMETER resourceGroupName
		Azure Resource Group Name
	.PARAMETER serverName
		Azure SQL Server Name
	.EXAMPLE
		.\Get-IAzureSQLADAdmin -resourceGroupName MyResource -serverName MyServer
	.INPUTS
	.OUTPUTS
		AD Administrator
	.NOTES
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/get-azurermsqlserveractivedirectoryadministrator
#>

param
(
       [string]$resourceGroupName = "$(Read-Host 'Resource Group Name')",
       [string]$serverName = "$(Read-Host 'SQL Server Name')"
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
        $results = Get-AzureRmSqlServerActiveDirectoryAdministrator -ResourceGroupName $resourceGroupName -ServerName $serverName

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