<#
	.SYNOPSIS
		Get-ISsrsEventLog
	.DESCRIPTION
		Get newest SSRS Event Log entries
	.PARAMETER serverInstance
		SQL Server Instance
	.PARAMETER newest
		Number of latest records
	.EXAMPLE
		.\Get-ISsrsEventLog -newest 1000
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#> 

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. server01\sql2012])",
	[int]$newest = 1000
)

try {
	Write-Verbose "Get newest Event Log Entries for SQL Server Reporting Services ..."

	$serverName = $serverInstance.Split("\")[0]
	if ($serverInstance.Contains("\")) {
		$instance = $serverInstance.Split("\")[1]
	} else {
		$instance = "MSSQLSERVER"
	}

	$source = "SQL Server Reporting Services ($instance)"
	
	$SSRSEvents = Get-EventLog -ComputerName $serverName -LogName application -Newest $newest | 
		Where-Object { $_.Source -eq $source } | 
		Select TimeGenerated, EntryType, Message
		
	Write-Output $SSRSEvents
}
catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
}