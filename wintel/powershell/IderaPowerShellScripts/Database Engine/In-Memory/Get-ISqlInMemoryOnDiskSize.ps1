<#
	.SYNOPSIS
		Get-ISqlInMemoryOnDiskSize
	.DESCRIPTION
		Get on disk size of in-memory database files
	.PARAMETER server
		Server instance
	.EXAMPLE
		.\Get-ISqlInMemoryOnDiskSize -server Server01\sql2016
	.INPUTS
	.OUTPUTS
		Returns on disk size of in-memory database files
	.NOTES
        Works on SQL 2014 version and greater
	.LINK
#>

param (
	[string]$server = "$(Read-Host 'Server Instance [e.g Server01\SQL12016]')",
	[string]$database = "$(Read-Host 'Database name [e.g. imoltp]')"
)

process {
	try {
		Write-Verbose "Connecting to SQL Server and running query..."

		$sql = @"
SELECT SUM(df.size) * 8 / 1024 AS [On-disk size in MB]
FROM sys.filegroups f JOIN sys.database_files df 
   ON f.data_space_id=df.data_space_id
WHERE f.type=N'FX'
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