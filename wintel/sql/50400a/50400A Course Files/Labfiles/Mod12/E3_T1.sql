USE master
GO
CREATE DATABASE Mod12_Restore
    ON (FILENAME = 'D:\Data\Mod12_Restore.mdf'),
    (FILENAME = 'D:\Data\Mod12_Restore_Log.ldf')
    FOR ATTACH;
GO
