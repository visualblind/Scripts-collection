Use Mod06
GO
CREATE EVENT NOTIFICATION CreateDatabaseNotification 
ON SERVER 
FOR CREATE_DATABASE, DROP_DATABASE 
TO SERVICE '//Fabcorp.com/Notify-Service', 'current database';
GO

CREATE EVENT NOTIFICATION AuditLoginLogoutNotification 
ON SERVER 
FOR AUDIT_LOGIN, AUDIT_LOGOUT, AUDIT_LOGIN_FAILED 
TO SERVICE '//Fabcorp.com/Notify-Service', 'current database';
GO
