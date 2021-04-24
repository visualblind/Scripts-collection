<#
	.SYNOPSIS
		Get-ISqlFilteredErrorLog
	.DESCRIPTION
		Locate keywords in error log
	.PARAMETER serverInstance
		SQL Server instance
	.PARAMETER filter
		Keyword to use for filtering the search
	.PARAMETER errorLog
		Number of error log to search. Leave blank to search current
	.EXAMPLE
		.\Get-ISqlFilteredErrorLog -serverInstance MyServer\SQL2012 -filter Error
	.INPUTS
	.OUTPUTS
	.NOTES
	.LINK
#>

param (
	[string]$serverInstance = "$(Read-Host 'Server Instance' [e.g. Server01\SQL2012])",
	[string]$filter = "$(Read-Host 'Keyword Filter' [e.g. Error])",
	[int]$logNumber = "$(Read-Host 'Log Number 0=Current' [e.g. 1])"
)

begin {
	[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')
}
process {
	try {
		$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $serverInstance
		
		If ($logNumber -eq 0) {
			If ($filter -eq "") {
				$output = $srv.ReadErrorLog() 
			} else {
				$output = $srv.ReadErrorLog() | where {$_.Text -like "$filter*"}
			}	
		} else {
			If ($filter -eq "") {
				$output = $srv.ReadErrorLog() 
			} else {
				$output = $srv.ReadErrorLog($logNumber) | where {$_.Text -like "$filter*"}		
			}
		}			
		
		Write-Output $output
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