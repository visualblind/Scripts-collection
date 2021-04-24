-- Enable Login Auditing for failed logins
-- CIS 5.3 Check (Auditing and Logging)

EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', REG_DWORD, 2
	
-- Restart required