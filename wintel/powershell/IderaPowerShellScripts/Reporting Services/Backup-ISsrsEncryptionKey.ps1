<#
	.SYNOPSIS
		Backup-ISsrsEncryptionKey
	.DESCRIPTION
		Backup reporting services encryption key
	.PARAMETER instance
		Reporting Service instance name
		Default = MSSQLSERVER
	.PARAMETER password
		Password conforming to password length, complexity and history policy
	.EXAMPLE
		.\Backup-ISsrsEncryptionKey -instance SQL2012 -password PasW0rd!
	.INPUTS
		
	.OUTPUTS
		Creates a file that should be securely stored with password to restore it
	.NOTES
		Must be run directly on the SQL Server Reporting instance
	.LINK
		http://technet.microsoft.com/en-us/library/ms157275.aspx	
#> 

param (
	[string]$instance = "$(Read-Host 'Server Instance Name' [e.g. SQL2012])",
	[string]$file = "$(Read-Host 'File to store encryption key' [e.g. C:\rsdbkey.snk])",
	[string]$password = "$(Read-Host 'Password for restoring')"
)

Write-Verbose "Backing up Reporting Services encryption key..."

rskeymgmt -e -f $file -p $password -i $instance