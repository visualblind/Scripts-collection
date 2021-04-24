<#
	.SYNOPSIS
		Get-ISqlXEventSystemHealth
	.DESCRIPTION
		Queries XEvent data and returns all RingBufferTarget results as XML
	.PARAMETER server
		Server instance
	.EXAMPLE
		.\Get-ISqlXEventSystemHealth -server Server01\sql2012
	.INPUTS
	.OUTPUTS
		RingBufferTarget Events
	.NOTES
		Note that if you have an event session setup for a ring_buffer target 
		and the data you feed the target exceeds 4Mb, 
		you may not be able to retrieve all XML nodes from the target data.
	.LINK
#>

param (
	[string]$server = "$(Read-Host 'Server Instance [e.g Server01\SQL12012]')"
)

process {
	try {
		Write-Verbose "Connecting to SQL Server and running query..."

		$sql = @"
select CAST(xet.target_data as xml)
from sys.dm_xe_session_targets xet 
join sys.dm_xe_sessions xe 
on (xe.address = xet.event_session_address) 
where xe.name = 'system_health'
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
			$cmd = New-Object System.Data.SqlClient.SqlCommand $sql, $conn
			if ($cmd) {
				$data = New-Object System.Data.SqlClient.SqlDataAdapter
				if ($data) {
					$ds = New-Object System.Data.DataSet
					if ($ds) {
						$data.SelectCommand = $cmd
						$data.Fill($ds)
						[xml]$xmlResults = $ds.Tables[0].Rows[0].Item(0)
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

		Write-Output $xmlResults.RingBufferTarget.event
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