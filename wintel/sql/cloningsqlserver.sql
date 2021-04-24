SELECT * FROM [master].[sys].[servers]
 
--Look for server_id=0 name is pointing to Server A
 
--Server_id=0 is local server
 
SELECT @@SERVERNAME --Returns(Server A)
 
EXEC sp_dropserver 'av01sqltest1'
 
EXEC sp_addserver 'av01sqltest2',local
 
--Important step
 
--Restart the local sql server service and the sql server agent service
 
SELECT @@SERVERNAME --Returns(Server B)
 
SELECT * FROM [master].[sys].[servers]
 
--Look for server_id=0 name is pointing to Server B
 
--Server_id=0 is local server
