CREATE DATABASE Mod03
ON PRIMARY ( NAME = Primary_Data,
    FILENAME = 'D:\Data\Mod03_Primary.mdf',
    SIZE = 10,
    MAXSIZE = 50,	
    FILEGROWTH = 5 )	
    LOG ON ( NAME = Primary_Log,		
    FILENAME = 'D:\Data\Mod03_Log.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
