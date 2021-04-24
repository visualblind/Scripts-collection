<#
	.SYNOPSIS
		Get-ISqlXEventNonYieldingErrors
	.DESCRIPTION
		Queries XEvent for 'scheduler_monitor_non_yielding_ring_buffer_recorded' events
	.PARAMETER server
		Server instance
	.EXAMPLE
		.\Get-ISqlXEventNonYieldingErrors -server Server01\sql2012
	.INPUTS
	.OUTPUTS
	.NOTES
		Note that if you have an event session setup for a ring_buffer target 
		and the data you feed the target exceeds 4Mb, 
		you may not be able to retrieve all XML nodes from the target data.
	.LINK
		http://troubleshootingsql.com/2011/09/28/system-health-session-part-3/		
#>

param (
	[string]$server = "$(Read-Host 'Server Instance [e.g Server01\SQL12012]')"
)

process {
	try {
		Write-Verbose "Connecting to SQL Server and running query..."

		$sql = @"
SELECT CAST(xet.target_data AS XML) AS XMLDATA
INTO #SystemHealthSessionData
FROM sys.dm_xe_session_targets xet
JOIN sys.dm_xe_sessions xe ON (xe.address = xet.event_session_address)
WHERE xe.name = 'system_health'
 
;WITH CTE_HealthSession (EventXML) AS
( SELECT C.query('.') EventXML
FROM #SystemHealthSessionData a
CROSS APPLY a.XMLDATA.nodes('/RingBufferTarget/event') as T(C)
WHERE C.query('.').value('(/event/@name)[1]', 'varchar(255)') = 'scheduler_monitor_non_yielding_ring_buffer_recorded' )
SELECT EventXML.value('(/event/@timestamp)[1]', 'datetime') as EventTime,
EventXML.value('(/event/data/value)[4]', 'int') as NodeID,
EventXML.value('(/event/data/value)[5]', 'int') as SchedulerID,
CASE EventXML.value('(/event/data/value)[3]', 'int') WHEN 0 THEN 'BEGIN' WHEN 1 THEN 'END' ELSE '' END AS DetectionStage,
EventXML.value('(/event/data/value)[6]', 'varchar(50)') as Worker,
EventXML.value('(/event/data/value)[7]', 'bigint') as Yields,
EventXML.value('(/event/data/value)[8]', 'int') as Worker_Utilization,
EventXML.value('(/event/data/value)[9]', 'int') as Process_Utilization,
EventXML.value('(/event/data/value)[10]', 'int') as System_Idle,
EventXML.value('(/event/data/value)[11]', 'bigint') as User_Mode_Time,
EventXML.value('(/event/data/value)[12]', 'bigint') as Kernel_Mode_Time,
EventXML.value('(/event/data/value)[13]', 'bigint') as Page_Faults,
EventXML.value('(/event/data/value)[14]', 'float') as Working_Set_Delta,
EventXML.value('(/event/data/value)[15]', 'bigint') as Memory_Utilization
FROM CTE_HealthSession
ORDER BY EventTime,Worker

DROP TABLE #SystemHealthSessionData
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
						$nonyieldingErrors = $ds.Tables[0]
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

		Write-Output $nonyieldingErrors
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