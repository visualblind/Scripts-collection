<#
	.SYNOPSIS
		Get-ISqlQueryStoreStatus
	.DESCRIPTION
		Determine if Query Store is currently active, and whether it is currently collects runtime stats or not
	.PARAMETER server
		Server instance
	.EXAMPLE
		.\Get-ISqlQueryStoreStatus -server Server01\sql2016
	.INPUTS
	.OUTPUTS
		Status results
	.NOTES
        Query Store feature only available on SQL 2016 editions or higher
	.LINK
#>

param (
	[string]$server = "$(Read-Host 'Server Instance [e.g Server01\SQL12016]')",
	[string]$dbName = "$(Read-Host 'Database Name [e.g. MyDatabase]')"
)

process {
	try {
		Write-Verbose "Connecting to SQL Server and running query..."

		$sql = @"
SELECT actual_state, actual_state_desc, readonly_reason, current_storage_size_mb, max_storage_size_mb
FROM sys.database_query_store_options;
"@

		$conn = New-Object System.Data.SqlClient.SqlConnection
		if (!$conn) {
			Throw "SqlConnection could not be created!"
		}

		$connString = "Server=$server;Database=$dbname;Integrated Security=True"

		# Now that we have built our connection string, attempt the connection
		$conn.ConnectionString = $connString
		$conn.Open()
		if ($conn.State -eq 1) {
			$cmd = New-Object System.Data.SqlClient.SqlCommand $sql, $conn
			if ($cmd) {
				$data = New-Object System.Data.SqlClient.SqlDataAdapter
				if ($data) {
					$ds = New-Object System.Data.DataSet
					if ($ds) {
						$data.SelectCommand = $cmd
						$data.Fill($ds)
						$Results = $ds.Tables[0]
					} else {
						Throw "Failed creating the data set object!"
					}
				} else {
					Throw "Failed creating the data adapter object!"
				}
			} else {
				Throw "Failed creating the command object!"
			}

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
		if ($ds -ne $null) { $ds.Dispose() }
		if ($data -ne $null) { $data.Dispose() }
		if ($cmd -ne $null) { $cmd.Dispose() }
		if ($conn -ne $null) {
			$conn.Close()
			$conn.Dispose()
		}
	}
}