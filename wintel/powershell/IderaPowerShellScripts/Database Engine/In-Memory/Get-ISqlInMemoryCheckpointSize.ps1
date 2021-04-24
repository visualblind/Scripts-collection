<#
	.SYNOPSIS
		Get-ISqlInMemoryCheckpointSize
	.DESCRIPTION
		In-Memory Checkpoint size
	.PARAMETER server
		Server instance
	.EXAMPLE
		.\Get-ISqlInMemoryCheckpointSize -server Server01\sql2016
	.INPUTS
	.OUTPUTS
		Returns In-Memory checkpoint size
	.NOTES
        Works on SQL 2014 version and greater
	.LINK
        https://msdn.microsoft.com/en-us/library/dn133201.aspx
#>

param (
	[string]$server = "$(Read-Host 'Server Instance [e.g Server01\SQL12016]')",
	[string]$database = "$(Read-Host 'Database name [e.g. imoltp]')"
)

process {
	try {
		Write-Verbose "Connecting to SQL Server and running query..."

		$sql = @"
SELECT state_desc
 , file_type_desc
 , COUNT(*) AS [count]
 , SUM(CASE
   WHEN state = 5 AND file_type=0 THEN 128*1024*1024
   WHEN state = 5 AND file_type=1 THEN 8*1024*1024
   WHEN state IN (6,7) THEN 68*1024*1024
   ELSE file_size_in_bytes
    END) / 1024 / 1024 AS [on-disk size MB] 
FROM sys.dm_db_xtp_checkpoint_files
GROUP BY state, state_desc, file_type, file_type_desc
ORDER BY state, file_type
"@

		$conn = New-Object System.Data.SqlClient.SqlConnection
		if (!$conn) {
			Throw "SqlConnection could not be created!"
		}

		$connString = "Server=$server;Database=$database;Integrated Security=True"

		# Now that we have built our connection string, attempt the connection
		$conn.ConnectionString = $connString
		$conn.Open()
		if ($conn.State -eq 1) {
            $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
            $SqlCmd.CommandText = $sql
            $SqlCmd.Connection = $conn
            $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
            $SqlAdapter.SelectCommand = $SqlCmd
 
            $DataSet = New-Object System.Data.DataSet
            $SqlAdapter.Fill($DataSet)
 
            $results = $DataSet.Tables[0] 		
		} else {
			Throw "Connection could not be opened!"
		}

		Write-Output $Results
	}
	catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
	finally {
		if ($DataSet -ne $null) { $DataSet.Dispose() }
		if ($SqlAdapter -ne $null) { $SqlAdapter.Dispose() }
		if ($SqlCmd -ne $null) { $SqlCmd.Dispose() }
		if ($conn -ne $null) {
			$conn.Close()
			$conn.Dispose()
		}
	}
}