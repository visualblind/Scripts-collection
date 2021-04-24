<#
	.SYNOPSIS
		Initialize-IAzureRM
	.DESCRIPTION
		Install/upgrade the PowerShell module for Azure SQL Database
	.EXAMPLE
		.\Initialize-IAzureRM
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
		https://docs.microsoft.com/en-us/powershell/module/packagemanagement/install-packageprovider
		https://docs.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule
		https://docs.microsoft.com/en-us/powershell/module/powershellget/update-module
		https://docs.microsoft.com/en-us/powershell/module/powershellget/install-module
#>

begin {
	try {
		# The latest version of AzureRM which this script installs/updates requires PowerShell v5.0
		#Requires -Version 5.0

		# Install/upgrade prerequisites for this script

		# Using PowerShellGet requires an Execution Policy that allows you to run scripts.
		# For more information about PowerShell's Execution Policy, see About Execution Policies.
		# A workaround to elevating privileges is to use -Scope CurrentUser which is what this script uses

        # Install latest verions of NuGet
        Install-PackageProvider -Name NuGet -Force -Verbose -Scope CurrentUser

		# Install or upgrade PowerShellGet
		if (Get-InstalledModule -Name PowerShellGet) {
			# If module to be updated is the latest, nothing happens and you will see "skipping..." message
            Update-Module PowerShellGet -Verbose
        } else {
            Install-Module PowerShellGet -Verbose -Scope CurrentUser
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
process {
	try {
		# Install / upgrade AzureRM PowerShell module
		if (Get-InstalledModule -Name AzureRM) {
			# If module to be updated is the latest, nothing happens and you will see "skipping..." message
			Update-Module -Name AzureRM -Verbose
		} else {
			Install-Module -Name AzureRM -Verbose -Scope CurrentUser
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


