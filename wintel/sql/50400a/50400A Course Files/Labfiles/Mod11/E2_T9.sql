RESTORE DATABASE Mod11
   FROM DISK='D:\Data\Mod11.bak'
   WITH NORECOVERY, 
      MOVE 'Primary_Data' TO 
         'D:\Data\Mod11_standby_Data.mdf', 
      MOVE 'Primary_Log' TO
         'D:\Data\Mod11_standby_Log.ldf';
GO
RESTORE LOG Mod11 
    FROM DISK = 'D:\Data\Mod11_Log.bak' 
    WITH NORECOVERY
GO
