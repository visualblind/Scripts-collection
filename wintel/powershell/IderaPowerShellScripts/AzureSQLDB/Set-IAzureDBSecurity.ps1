<#
	.SYNOPSIS
		Set-IAzureDBSecurity
	.DESCRIPTION
		Set Azure SQL DB auditing and threat detection
	.PARAMETER resourceGroupName
		Azure Resource Group Name
	.PARAMETER location
		Azure Location
	.PARAMETER storageAccountName
		Azure storage account name
	.PARAMETER serverName
		Azure SQL Server Name
	.PARAMETER databaseName
		Azure SQL Database Name
	.PARAMETER notificationEmailRecepient
		Azure Notification email recepient
	.EXAMPLE
		.\Get-IAzureDBSecurity -resourceGroupName MyResource -location southcentralus -storageAccountName mystorageaccount
			-servername MyServer -databasename AdventureWorksLTv12 -notificationEmailRecepient myemail@xxx.com
	.INPUTS
	.OUTPUTS
	.NOTES
		Enabling Auditing and Threat Detection will incur additional Azure charges.
		If Auditing and Threat Detection are enabled on a database with an existing storage account
		  and you run this script and create a new storage account, the storage account will be
		  for reassigned for Auditing and Threat Detection to the storage account specified in this script
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/azurerm.storage/get-azurermstorageaccountnameavailability
		https://docs.microsoft.com/en-us/powershell/module/azurerm.storage/new-azurermstorageaccount
		https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/set-azurermsqldatabaseauditing
		https://docs.microsoft.com/en-us/powershell/module/azurerm.sql/set-azurermsqldatabasethreatdetectionpolicy
#>

param
(
       [string]$resourceGroupName = "$(Read-Host 'Resource Group Name')",
	   [string]$location = "$(Read-Host 'Location [eg. southcentralus]')",
	   [string]$storageAccountName = "$(Read-Host 'Storage Account Name')",
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
		#Storage account name must be between 3 and 24 characters in length and use numbers and
		#  lower-case letters only
		$storageAccountName = $storageAccountName
		$pat ="^[a-z0-9]+$"
		if ($storageAccountName.Length -lt 3 -or $storageAccountName -gt 24) {
			if ($storageAccountName -notmatch $pat) {
				Throw "The Storage account name ($storageAccountName) must be between 3 and 24 characters in length and use numbers and lower-case letters only."
			}
		}

		$result = Get-AzureRmStorageAccountNameAvailability -Name $storageAccountName
		# NameAvailable will return FALSE if it already exists
		if ($result.NameAvailable -eq $true) {
			Write-Verbose "Storage Account Name does not exist, creating $storageAccountName."
			New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -AccountName `
				$storageAccountName -Location $location -Type "Standard_LRS"
		} else {
			Write-Verbose "The storage name exists already. Will use the existing storage account."
		}

		# Set an auditing policy
		# To Remove auditing policy call
		#   Remove-AzureRmSqlDatabaseAuditing -ResourceGroupName -ServerName -DatabaseName
		Write-Verbose "Enabling Database Auditing for $databaseName."
		Set-AzureRmSqlDatabaseAuditing -State Enabled `
			-ResourceGroupName $resourceGroupName `
			-ServerName $serverName `
			-DatabaseName $databaseName `
			-StorageAccountName $storageAccountName `
			-Confirm

		# Set a threat detection policy
		# To Remove threat detection policy call
		#   Remove-AzureRmSqlDatabaseThreatDetectionPolicy -ResourceGroupName -ServerName -DatabaseName
		Write-Verbose "Enabling Database Threat Detection for $databaseName."
		Set-AzureRmSqlDatabaseThreatDetectionPolicy -ResourceGroupName $resourceGroupName `
			-ServerName $serverName `
			-DatabaseName $databaseName `
			-StorageAccountName $storageAccountName `
			-NotificationRecipientsEmails $notificationEmailRecepient `
			-EmailAdmins $False `
			-Confirm
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

