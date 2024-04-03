SELECT r.group_id, g.name, r.status, r.session_id, r.request_id, r.start_time, r.command, r.sql_handle, t.text 
FROM sys.dm_exec_requests r
INNER JOIN sys.dm_resource_governor_workload_groups g
ON g.group_id = r.group_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
ORDER BY g.name
GO 
