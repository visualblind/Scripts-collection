SELECT 
    s.database_name,s.backup_finish_date,y.physical_device_name
FROM 
    msdb..backupset AS s INNER JOIN
    msdb..backupfile AS f ON f.backup_set_id = s.backup_set_id INNER JOIN
    msdb..backupmediaset AS m ON s.media_set_id = m.media_set_id INNER JOIN
    msdb..backupmediafamily AS y ON m.media_set_id = y.media_set_id
WHERE 
    (s.database_name = 'ebn')
ORDER BY 
    s.backup_finish_date DESC;