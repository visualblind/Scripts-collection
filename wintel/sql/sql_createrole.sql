CREATE ROLE ViewReader AUTHORIZATION dbo
GO
exec sp_addrolemember 'ViewReader','sentric\APP_SQLDBA'
GO
