<#
	.SYNOPSIS
		New-IAzureSQLFirewallRule
	.DESCRIPTION
		Add a new Azure SQL Server firewall rule
	.PARAMETER resourceGroupName
		Azure Resource Group Name
	.PARAMETER serverName
		Azure SQL Server Name
	.PARAMETER startIP
		Starting IP address
	.PARAMETER endIP
		Ending IP address
	.EXAMPLE
		.\New-IAzureSQLFirewallRule -resourceGroupName MyResource -serverName MyServer -startIP 0.0.0.0 -endIP 0.0.0.0
	.INPUTS
	.OUTPUTS
	.NOTES
    .LINK
        https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/new-azurermsqlserverfirewallrule
#>

param
(
       [string]$resourceGroupName = "$(Read-Host 'Resource Group Name')",
       [string]$serverName = "$(Read-Host 'SQL Server Name')",
       [string]$startIP = "$(Read-Host 'Starting IP Address')",
       [string]$endIP = "$(Read-Host 'Ending IP Address')"
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
        $fwrulename = "ClientIPAddress_" + (Get-Date).ToString("yyyy-M-d_h-m-d")
        Get-AzureRmSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName -FirewallRuleName $fwrulename `
            -ErrorAction SilentlyContinue -ErrorVariable ProcessError
        #If a SQL Server Firewale rule does not exist, create it
        if ($ProcessError) {
            New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
                -ServerName $serverName `
                -FirewallRuleName $fwrulename -StartIpAddress $startIP -EndIpAddress $endIP `
                -Verbose
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
