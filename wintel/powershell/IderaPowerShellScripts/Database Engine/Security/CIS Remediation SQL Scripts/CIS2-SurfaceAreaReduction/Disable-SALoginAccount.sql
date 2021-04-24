-- Disable SA Login Account
-- CIS 2.13 Check (Surface Area Reduction)

USE [master]
GO
DECLARE @tsql nvarchar(max)
SET @tsql = 'ALTER LOGIN ' + SUSER_NAME(0x01) + ' DISABLE'
EXEC (@tsql)
GO