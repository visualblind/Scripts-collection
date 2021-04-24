<#
	.SYNOPSIS
		Get-ISqlDBFileSizes
	.DESCRIPTION
		Get database physical file sizes for SQL Server instance
	.PARAMETER serverInstance
		SQL Server instance
	.EXAMPLE
		.\Get-ISqlDBFileSizes -serverInstance Server01\sql2012
	.INPUTS
	.OUTPUTS
		Database file size results
	.NOTES
	.LINK
#>

param
(
	[string]$serverInstance = "$(Read-Host 'Server Instance [e.g. server01\sql2012]')"
)

begin {
	[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}
process {
	try {
		Write-Verbose "Get SQL Server file sizes..."

		$results = @()

		$server = new-object Microsoft.SqlServer.Management.Smo.Server $serverInstance

		foreach ($db in $server.Databases)
		{
			$dbname = $db.Name
			$fileGroups = $db.FileGroups

			foreach ($fg in $fileGroups) {
				If ($fg) {
					$intRow++

					$mdfInfo = $fg.Files | Select Name, FileName, size, UsedSpace
					$result = New-Object -TypeName PSObject -Property @{
						DBName = $dbname
						Name = $mdfInfo.Name
						FileName = $mdfInfo.FileName
						Size = ($mdfInfo.size / 1000)
						UsedSpace = ($mdfInfo.UsedSpace / 1000)
					}
					$results += $result

					$logInfo = $db.LogFiles | Select Name, FileName, Size, UsedSpace
					$result = New-Object -TypeName PSObject -Property @{
						DBName = $dbname
						Name = $logInfo.Name
						FileName = $logInfo.FileName
						Size = ($logInfo.size / 1000)
						UsedSpace = ($logInfo.UsedSpace / 1000)
					}
					$results += $result
				}
			}
		}

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