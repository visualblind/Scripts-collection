<#
	.SYNOPSIS
		Restore-ISsrsEncryptionKey
	.DESCRIPTION
		Restore reporting services encryption key
	.PARAMETER instance
		Reporting Service instance name
		Default = MSSQLSERVER
	.PARAMETER password
		Password conforming to password length, complexity and history policy
	.EXAMPLE
		.\Restore-ISsrsEncryptionKey -instance SQL2012 -password PasW0rd!
	.INPUTS
	.OUTPUTS
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

Write-Verbose "Restoring Reporting Services encryption key..."

rskeymgmt -a -f $file -p $password -i $instance