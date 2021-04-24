<#
	.SYNOPSIS
		Get-ISqlInMemoryOverallUtilzation
	.DESCRIPTION
		Overall memory utilization
	.PARAMETER server
		Server instance
	.EXAMPLE
		.\Get-ISqlInMemoryOverallUtilzation -server Server01\sql2014
	.INPUTS
	.OUTPUTS
		Returns overall memory utilization results
	.NOTES
        Works on SQL 2014 version and greater
	.LINK
        https://msdn.microsoft.com/en-us/library/ms175019.aspx
#>

param (
	[string]$server = "$(Read-Host 'Server Instance [e.g Server01\SQL12016]')"
)

process {
	try {
		Write-Verbose "Connecting to SQL Server and running query..."

		$sql = @"
SELECT type, name, pages_kb/1024 AS pages_MB 
FROM sys.dm_os_memory_clerks WHERE type LIKE '%xtp%'
"@

		$conn = New-Object System.Data.SqlClient.SqlConnection
		if (!$conn) {
			Throw "SqlConnection could not be created!"
		}

		$connString = "Server=$server;Database=master;Integrated Security=True"

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