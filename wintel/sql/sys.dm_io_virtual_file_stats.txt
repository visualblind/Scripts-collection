SELECT 
cast(DB_Name(a.database_id) as varchar) as Database_name,
b.physical_name, * 
FROM  
sys.dm_io_virtual_file_stats(null, null) a 
INNER JOIN sys.master_files b ON a.database_id = b.database_id and a.file_id = b.file_id
ORDER BY Database_Name