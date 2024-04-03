CREATE DATABASE Mod05
ON PRIMARY ( NAME = Primary_Data,
    FILENAME = 'D:\data\Mod05_Primary.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
    LOG ON ( NAME = Primary_Log,
    FILENAME = 'D:\data\Mod05_Log.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
