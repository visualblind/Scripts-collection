USE master
GO
CREATE DATABASE Mod12_File 
    ON (FILENAME = 'D:\Data\Mod12_File_Primary.mdf'),
(FILENAME = 'D:\Data\Mod12_File_Data.ndf'),
    (FILENAME = 'D:\Data\Mod12_File_Log.ldf')
    FOR ATTACH;
GO
