<#
	.SYNOPSIS
		Get-ISqlXEventWaitStatistics
	.DESCRIPTION
		Queries XEvent for 'wait_info' and 'wait_info_external' events
	.PARAMETER server
		Server instance
	.EXAMPLE
		.\Get-ISqlXEventWaitStatistics -server Server01\sql2012
	.INPUTS
	.OUTPUTS
	.NOTES
		Note that if you have an event session setup for a ring_buffer target 
		and the data you feed the target exceeds 4Mb, 
		you may not be able to retrieve all XML nodes from the target data.
	.LINK
		http://blogs.msdn.com/b/saponsqlserver/archive/2010/05/26/extended-events-with-sap-part-i.aspx		
#>

param (
	[string]$server = "$(Read-Host 'Server Instance [e.g Server01\SQL12012]')"
)

process {
	try {
		Write-Verbose "Connecting to SQL Server and running query..."

		$sql = @"
select 
    XEventData.XEvent.value('(data/text)[1]', 'varchar(max)') as wait_type,
    XEventData.XEvent.value('(data/text)[2]', 'varchar(max)') as opcode,
    XEventData.XEvent.value('(data/value)[3]', 'varchar(max)') as duration,
    XEventData.XEvent.value('(data/value)[4]', 'varchar(max)') as max_duration,
    XEventData.XEvent.value('(data/value)[5]', 'varchar(max)') as total_duration,
    XEventData.XEvent.value('(data/value)[6]', 'varchar(max)') as signal_duration,
    XEventData.XEvent.value('(data/value)[7]', 'varchar(max)') as completed_count
FROM
    (select CAST(target_data as xml) as TargetData 
     from sys.dm_xe_session_targets st join 
          sys.dm_xe_sessions s on s.address = st.event_session_address
     where name = 'system_health') AS Data
    CROSS APPLY TargetData.nodes ('//RingBufferTarget/event') 
    AS XEventData (XEvent)
where XEventData.XEvent.value('@name', 'varchar(4000)') = 'wait_info'
union all
select 
    XEventData.XEvent.value('(data/text)[1]', 'varchar(max)') as wait_type,
    XEventData.XEvent.value('(data/text)[2]', 'varchar(max)') as opcode,
    XEventData.XEvent.value('(data/value)[3]', 'varchar(max)') as duration,
    XEventData.XEvent.value('(data/value)[4]', 'varchar(max)') as max_duration,
    XEventData.XEvent.value('(data/value)[5]', 'varchar(max)') as total_duration,
    null,
    XEventData.XEvent.value('(data/value)[6]', 'varchar(max)') as completed_count
FROM
    (select CAST(target_data as xml) as TargetData 
     from sys.dm_xe_session_targets st join 
          sys.dm_xe_sessions s on s.address = st.event_session_address
     where name = 'system_health') AS Data
    CROSS APPLY TargetData.nodes ('//RingBufferTarget/event')
    AS XEventData (XEvent)
where XEventData.XEvent.value('@name', 'varchar(4000)') = 'wait_info_external'
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
						$waitStatistics = $ds.Tables[0]
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

		Write-Output $waitStatistics
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