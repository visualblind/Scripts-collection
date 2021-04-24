WITH Tasks 
AS (SELECT session_id, 
wait_type, 
wait_duration_ms, 
blocking_session_id, 
resource_description, 
PageID = CAST(Right(resource_description, 
LEN(resource_description) - 
CHARINDEX(':', resource_description, 3)) 
AS INT) 
FROM sys.dm_os_waiting_tasks 
WHERE wait_type LIKE 'PAGE%LATCH_%' 
AND resource_description LIKE '2:%') 
SELECT session_id, 
wait_type, 
wait_duration_ms, 
blocking_session_id, 
resource_description, 
ResourceType = 
CASE 
WHEN PageID = 1 Or PageID % 8088 = 0 
THEN 'Is PFS Page'
WHEN PageID = 2 Or PageID % 511232 = 0 
THEN 'Is GAM Page'
WHEN PageID = 3 Or (PageID - 1) % 511232 = 0
THEN 'Is SGAM Page'
ELSE 'Is Not PFS, GAM, or SGAM page’'
END 
FROM Tasks;
